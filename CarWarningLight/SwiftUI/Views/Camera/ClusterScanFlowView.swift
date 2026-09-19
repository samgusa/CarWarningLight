//
//  ClusterScanFlowView.swift
//  CarWarningLight
//
//  Created by Sam Greenhill on 8/7/26.
//  Copyright © 2026 simplyAmazingMachines. All rights reserved.
//

import SwiftUI

struct ClusterScanFlowView: View {
    @State private var viewModel = ImageDetectionViewModel()
    let capturedPhoto: CapturedPhoto

    var onScanLogged: (CarSymbol) -> Void = { _ in }
    var onNoMatch: () -> Void = { }
    var onDismiss: () -> Void = { }
    var onRetakePhoto: (PhotoSource) -> Void = { _ in }

    @Namespace private var previewNamespace

    @State private var buttonState: ScanButtonState = .idle
    @State private var showResults: Bool = false
    @State private var selectedMatch: ScanMatch?

    private enum ScanButtonState: Equatable {
        case idle, loading, success, failed(String)
    }

    private let confidenceThreshold: Double = 0.35

    private var top: ScanMatch? {
        guard let first = viewModel.scanMatches.first, first.confidence >= confidenceThreshold else { return nil }
        return first
    }

    private var alternates: [ScanMatch] { Array(viewModel.scanMatches.dropFirst()) }


    var body: some View {
        ZStack {
            ClusterTheme.Colors.background

            captureStage
                .opacity(showResults || selectedMatch != nil ? 0 : 1)
                .allowsHitTesting(!showResults && selectedMatch == nil)
                .accessibilityHidden(showResults || selectedMatch != nil)

            if showResults {
                resultsStage
                    .opacity(selectedMatch != nil ? 0 : 1)
                    .transition(.stageTransition)
                    .zIndex(1)
                    .allowsHitTesting(selectedMatch == nil)
                    .accessibilityHidden(selectedMatch != nil)
            }

            if let match = selectedMatch {
                ClusterExpandedView(
                    carSymbol: match.carSymbol,
                    namespace: previewNamespace,
                    isShowingLarge: .constant(true),
                    bigImageId: 0,
                    index: .constant(0),
                    isStandAlone: true,
                    headerTitle: "PREVIEW MATCH",
                    onDismiss: {
                        withAnimation(stageAnimation) { selectedMatch = nil }
                    },
                    onConfirmMatch: {
                        onScanLogged(match.carSymbol)
                    }
                )
                .transition(.stageTransition)
                .zIndex(2)
            }
        }
        .ignoresSafeArea()
    }

    private var captureStage: some View {
        VStack(spacing: 0) {
            ClusterHeaderBar(title: "Scan") { onDismiss() }
                .clusterTopSafeArea(fill: ClusterTheme.Colors.panel)

            VStack(spacing: 20) {
                Spacer()

                Image(uiImage: capturedPhoto.image)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .clipShape(RoundedRectangle(cornerRadius: 16))
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(ClusterTheme.Colors.bezel, lineWidth: 1)
                    )
                    .padding(.horizontal)

                Spacer()

                identifySection
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(ClusterTheme.Colors.background)
    }

    private var identifySection: some View {
        VStack(spacing: 14) {
            Text("Analyze dashboard warning light")
                .font(ClusterTheme.Fonts.body(15, weight: .semibold))
                .foregroundStyle(ClusterTheme.Colors.textPrimary)
            identifyButton

            Button {
                onRetakePhoto(capturedPhoto.source)
            } label: {
                Text(capturedPhoto.source == .camera ? "Retake Photo" : "Choose a Different Photo")
                    .font(ClusterTheme.Fonts.mono(12, weight: .semibold))
                    .foregroundStyle(ClusterTheme.Colors.textSecondary)
            }
            .buttonStyle(.plain)
            .disabled(buttonState != .idle)
        }
        .padding(.bottom, 36)
    }

    private var identifyButton: some View {
        Button(action: runIdentify) {
            ZStack {
                switch buttonState {
                case .idle:
                    Text("Identify Light")
                        .font(ClusterTheme.Fonts.body(16, weight: .bold))
                case .loading:
                    ClusterGaugeLoader(color: ClusterTheme.Colors.background, size: 24)
                case .success:
                    Image(systemName: "checkmark")
                        .font(.system(size: 18, weight: .bold))
                case .failed(_ ):
                    Image(systemName: "xmark")
                        .font(.system(size: 18, weight: .bold))
                }
            }
            .foregroundStyle(ClusterTheme.Colors.background)
            .frame(width: 220, height: 52)
            .background(stateColor)
            .clipShape(Capsule())
            .animation(.spring(duration: 0.3), value: buttonState)
        }
        .buttonStyle(.plain)
        .disabled(buttonState != .idle)
        .alert(failureMessage ?? "", isPresented: showFailureAlert) {
            Button("OK", role: .cancel) { }
        }
    }

    private var stateColor: Color {
        switch buttonState {
        case .idle, .loading:   return ClusterTheme.Colors.amber
        case .success:          return ClusterTheme.Colors.green
        case .failed:           return ClusterTheme.Colors.red
        }
    }

    private var failureMessage: String? {
        if case .failed(let message) = buttonState { return message }
        return nil
    }

    private var showFailureAlert: Binding<Bool> {
        Binding(get: { failureMessage != nil }, set: { _ in })
    }

    private func runIdentify() {
        guard buttonState == .idle else { return }
        buttonState = .loading
        Task {
            let status = await viewModel.processImage(photo: capturedPhoto.image)
            switch status {
            case .success:
                buttonState = .success
                try? await Task.sleep(for: .seconds(0.6))
                withAnimation(stageAnimation) {
                    showResults = true
                }
                buttonState = .idle
            case .failed(let message):
                buttonState = .failed(message)
                try? await Task.sleep(for: .seconds(1.6))
                buttonState = .idle
            case .idle:
                buttonState = .idle
            }
        }
    }

    // MARK: Results stage

    private var resultsStage: some View {
        VStack(spacing: 0) {
            ClusterHeaderBar(title: "Scan", icon: "chevron.left") {
                withAnimation(stageAnimation) { showResults = false }
            }
            .clusterTopSafeArea(fill: ClusterTheme.Colors.panel)

            ScrollView {
                VStack(spacing: 20) {
                    if let top {
                        confidenceGauge(for: top)
                    } else {
                        noMatchState
                    }
                    if !alternates.isEmpty { alternatesSection }
                    noneOfTheseButton
                }
                .padding(.top, 20)
                .padding(.bottom, 24)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(ClusterTheme.Colors.background)
    }

    private func confidenceGauge(for match: ScanMatch) -> some View {
        let telltale = ClusterTheme.Colors.forSymbolType(match.carSymbol.symbolType)
        return VStack(spacing: 16) {
            ZStack {
                Circle()
                    .trim(from: 0.12, to: 0.88)
                    .stroke(ClusterTheme.Colors.bezel, style: StrokeStyle(lineWidth: 9, lineCap: .round))
                    .rotationEffect(.degrees(90))

                Circle()
                    .trim(from: 0.12, to: 0.12 + 0.76 * match.confidence)
                    .stroke(telltale, style: StrokeStyle(lineWidth: 9, lineCap: .round))
                    .rotationEffect(.degrees(90))
                    .shadow(color: telltale.opacity(0.6), radius: 8)

                VStack(spacing: 2) {
                    Text(match.confidenceLabel)
                        .font(ClusterTheme.Fonts.mono(28, weight: .bold))
                        .foregroundStyle(ClusterTheme.Colors.textPrimary)
                    Text("MATCH")
                        .font(ClusterTheme.Fonts.mono(9, weight: .bold))
                        .tracking(1.2)
                        .foregroundStyle(ClusterTheme.Colors.textSecondary)
                }
            }
            .frame(width: 160, height: 160)
            .padding(.top, 8)

            HStack(spacing: 10) {
                Image(match.carSymbol.imageName)
                    .resizable()
                    .renderingMode(.template)
                    .scaledToFit()
                    .frame(width: 22, height: 22)
                    .foregroundStyle(telltale)
                    .frame(width: 40, height: 40)
                    .background(Circle().fill(telltale.opacity(0.15)))

                VStack(alignment: .leading, spacing: 2) {
                    Text(match.carSymbol.name)
                        .font(ClusterTheme.Fonts.display(16))
                        .foregroundStyle(ClusterTheme.Colors.textPrimary)
                    Text(match.carSymbol.symbolType.title.uppercased())
                        .font(ClusterTheme.Fonts.mono(9, weight: .bold))
                        .tracking(1.0)
                        .foregroundStyle(telltale)
                }
                Spacer()
                Image(systemName: "chevron.right")
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundStyle(ClusterTheme.Colors.textSecondary)
            }
        }
        .padding(16)
        .frame(maxWidth: .infinity)
        .clusterPanel()
        .padding(.horizontal)
        .contentShape(Rectangle())
        .onTapGesture {
            withAnimation(stageAnimation) { selectedMatch = match }
        }
        .accessibilityAddTraits(.isButton)
    }

    private var alternatesSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("OTHER POSSIBLE MATCHES")
                .font(ClusterTheme.Fonts.mono(10, weight: .bold))
                .tracking(1.0)
                .foregroundStyle(ClusterTheme.Colors.textSecondary)
                .padding(.horizontal)

            ForEach(Array(alternates.enumerated()), id: \.offset) { _, alt in
                HStack(spacing: 10) {
                    Image(alt.carSymbol.imageName)
                        .resizable()
                        .renderingMode(.template)
                        .scaledToFit()
                        .frame(width: 18, height: 18)
                        .foregroundStyle(ClusterTheme.Colors.textSecondary)
                    Text(alt.carSymbol.name)
                        .font(ClusterTheme.Fonts.body(13, weight: .medium))
                        .foregroundStyle(ClusterTheme.Colors.textPrimary.opacity(0.85))
                    Spacer()
                    Text(alt.confidenceLabel)
                        .font(ClusterTheme.Fonts.mono(11, weight: .semibold))
                        .foregroundStyle(ClusterTheme.Colors.textSecondary)
                    Image(systemName: "chevron.right")
                        .font(.system(size: 11, weight: .semibold))
                        .foregroundStyle(ClusterTheme.Colors.textSecondary.opacity(0.6))
                }
                .padding(12)
                .clusterPanel()
                .padding(.horizontal)
                .opacity(0.75)
                .contentShape(Rectangle())
                .onTapGesture {
                    withAnimation(stageAnimation) { selectedMatch = alt }
                }
                .accessibilityAddTraits(.isButton)
            }
        }
    }

    private var noneOfTheseButton: some View {
        Button {
            onNoMatch()
        } label: {
            Text("Can't find it? Browse the Encyclopedia")
                .font(ClusterTheme.Fonts.mono(12, weight: .semibold))
                .foregroundStyle(ClusterTheme.Colors.textSecondary)
                .padding(.vertical, 10)
        }
        .buttonStyle(.plain)
    }

    private var noMatchState: some View {
        VStack(spacing: 10) {
            Image(systemName: "questionmark.circle")
                .font(.system(size: 32))
                .foregroundStyle(ClusterTheme.Colors.textSecondary)
            Text("No confident match")
                .font(ClusterTheme.Fonts.body(15, weight: .semibold))
                .foregroundStyle(ClusterTheme.Colors.textPrimary)
            Text("Try again with the light centered and well lit.")
                .font(ClusterTheme.Fonts.body(13))
                .foregroundStyle(ClusterTheme.Colors.textSecondary)
                .multilineTextAlignment(.center)
        }
        .padding(.vertical, 60)
        .padding(.horizontal, 40)
    }

    private var stageAnimation: Animation {
        .spring(response: 0.5, dampingFraction: 0.86)
    }

}

extension AnyTransition {

    static var stageTransition: AnyTransition {
        .asymmetric(
            insertion: .move(edge: .bottom)
                .combined(with: .opacity)
                .combined(with: .scale(scale: 0.97, anchor: .center)),
            removal: .move(edge: .bottom)
                .combined(with: .opacity)
        )
    }
}
