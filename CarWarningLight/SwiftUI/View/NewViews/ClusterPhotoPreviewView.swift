//
//  ClusterPhotoPreviewView.swift
//  CarWarningLight
//
//  Created by Sam Greenhill on 7/27/26.
//  Copyright © 2026 simplyAmazingMachines. All rights reserved.
//

import SwiftUI

struct ClusterPhotoPreviewView: View {
    @StateObject private var viewModel = ImageDetectionViewModel()
    @Environment(\.dismiss) private var dismiss

    let capturedPhoto: CapturedPhoto?

    var onScanLogged: (CarSymbol) -> Void = { _ in }

    @State private var buttonState: ScanButtonState = .idle
    @State private var showResults: Bool = false

    private enum ScanButtonState: Equatable {
        case idle, loading, success, failed(String)
    }
    var body: some View {
        ZStack {
            ClusterTheme.Colors.background
                .ignoresSafeArea()

            if let photo = capturedPhoto {
                VStack(spacing: 20) {
                    headerBar
                    Spacer()
                    Image(uiImage: photo.image)
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
            } else {
                emptyState
            }
        }
        .navigationBarBackButtonHidden(true)
        .fullScreenCover(isPresented: $showResults) {
            ClusterScanResultsView(matches: viewModel.scanMatches) { selected in
                onScanLogged(selected)
            }
        }
    }

    private var headerBar: some View {
        HStack {
            Text("SCAN")
                .font(ClusterTheme.Types.mono(12, weight: .bold))
                .tracking(1.5)
                .foregroundStyle(ClusterTheme.Colors.textSecondary)
            Spacer()
            Button { dismiss() } label: {
                Image(systemName: "xmark")
                    .font(.system(size: 13, weight: .bold))
                    .foregroundStyle(ClusterTheme.Colors.textPrimary)
                    .frame(width: 28, height: 28)
                    .background(ClusterTheme.Colors.panel)
                    .overlay(
                        RoundedRectangle(cornerRadius: 6)
                            .stroke(ClusterTheme.Colors.bezel, lineWidth: 1)
                    )
                    .clipShape(RoundedRectangle(cornerRadius: 6))
            }
        }
        .padding()
        .background(ClusterTheme.Colors.panel)
    }

    private var identifySection: some View {
        VStack(spacing: 14) {
            Text("Analyze dashboard warning light")
                .font(ClusterTheme.Types.body(15, weight: .semibold))
                .foregroundStyle(ClusterTheme.Colors.textPrimary)
            identifyButton
        }
        .padding(.bottom, 36)
    }

    private var identifyButton: some View {
        Button(action: runIdentify) {
            ZStack {
                switch buttonState {
                case .idle:
                    Text("Identify Light")
                        .font(ClusterTheme.Types.body(16, weight: .bold))
                case .loading:
                    ClusterGaugeLoader(color: ClusterTheme.Colors.background, size: 24)
                case .success:
                    Image(systemName: "checkmark")
                        .font(.system(size: 18, weight: .bold))
                case .failed(let string):
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
        case .idle, .loading: return ClusterTheme.Colors.amber
        case .success: return ClusterTheme.Colors.green
        case .failed: return ClusterTheme.Colors.red
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
        guard buttonState == .idle, let photo = capturedPhoto else { return }
        buttonState = .loading
        Task {
            let status = await viewModel.processImage(photo: photo.image)
            switch status {
            case .success:
                buttonState = .success
                try? await Task.sleep(for: .seconds(0.6))
                showResults = true
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

    private var emptyState: some View {
        VStack(spacing: 16) {
            Image(systemName: "exclamationmark.triangle")
                .font(.system(size: 44))
                .foregroundStyle(ClusterTheme.Colors.textSecondary)
            Text("No photo available")
                .font(ClusterTheme.Types.body(16, weight: .semibold))
                .foregroundStyle(ClusterTheme.Colors.textPrimary)
            Button("Go Back") { dismiss() }
                .font(ClusterTheme.Types.body(14, weight: .semibold))
                .foregroundStyle(ClusterTheme.Colors.textPrimary)
                .padding(.horizontal, 20)
                .padding(.vertical, 10)
                .background(ClusterTheme.Colors.panel)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(ClusterTheme.Colors.bezel, lineWidth: 1)
                )
                .clipShape(RoundedRectangle(cornerRadius: 10))
        }
    }
}

#Preview {
    ClusterPhotoPreviewView(capturedPhoto: CapturedPhoto(image: UIImage(systemName: "photo.fill") ?? UIImage()))
}
