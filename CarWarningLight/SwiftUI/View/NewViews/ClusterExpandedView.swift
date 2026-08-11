//
//  ClusterExpandedView.swift
//  CarWarningLight
//
//  Created by Sam Greenhill on 7/25/26.
//  Copyright © 2026 simplyAmazingMachines. All rights reserved.
//

import SwiftUI

struct ClusterExpandedView: View {
    @EnvironmentObject private var uiState: UIStateManager
    @StateObject var viewModel              = ExpandedViewModel()

    let carSymbol: CarSymbol
    var namespace: Namespace.ID
    @Binding var isShowingLarge: Bool
    let bigImageId: Int
    @Binding var index: Int?
    var isStandAlone: Bool                  = false

    var logEntry: LightLogEntry?            = nil
    var onToggleResolved: (() -> Void)?     = nil
    var headerTitle: String                 = "WARNING LIGHT"
    var onDismiss: (() -> Void)?            = nil
    var onConfirmMatch: (() -> Void)?       = nil
    var onLogEntry: (() -> Void)?           = nil


    @State private var hasConfirmed: Bool   = false
    @State private var hasLoggedNow: Bool   = false

    private var telltale: Color { ClusterTheme.Colors.forSymbolType(carSymbol.symbolType) }
    private var safetyColor: Color { ClusterTheme.Colors.forDrivable(carSymbol.drivable) }


    var body: some View {
        Group {
            if isStandAlone {
                shapedContent
            } else {
                shapedContent
                    .matchedGeometryEffect(
                        id: isShowingLarge ? "\(bigImageId) card" : "\(index ?? 0) card",
                        in: namespace,
                        isSource: false
                    )
            }
        }
        .onAppear {
            uiState.detailViewAppeared(id: carSymbol.imageName)
            viewModel.resetAnimations()
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                viewModel.startAnimations()
                viewModel.hasAppeared   = true
            }
        }
        .onDisappear {
            viewModel.cancelAnimations()
            uiState.detailViewDisappeared(id: carSymbol.imageName)
            viewModel.hasAppeared       = false
        }
    }

    private var shapedContent: some View {
        ZStack {
            ClusterTheme.Colors.background
            mainContent
                .clusterTopSafeArea(fill: ClusterTheme.Colors.panel)
        }
        .ignoresSafeArea()
        .clipShape(RoundedRectangle(cornerRadius: isShowingLarge ? 0 : 16, style: .continuous))
    }

    private var mainContent: some View {
        VStack(spacing: 0) {
            headerBar

            ScrollView {
                VStack(alignment: .leading, spacing: 14) {
                    heroRow
                    safetyPlaquard
                    if onConfirmMatch != nil {
                        confirmMatchControl
                    }
                    if let logEntry {
                        resolvedControl(for: logEntry)
                    }
                    infoPanel(label: "DESCRIPTION", body: carSymbol.description)
                    infoPanel(label: "HOW TO FIX", body: carSymbol.fixDescription)
                }
                .padding(.bottom, 24)
            }
        }
    }

    private var headerBar: some View {
        HStack {
            Text(headerTitle)
                .font(ClusterTheme.Types.mono(11, weight: .bold))
                .tracking(1.5)
                .foregroundStyle(ClusterTheme.Colors.textSecondary)
            Spacer()
            Button {

                if let onDismiss {
                    onDismiss()
                } else {
                    withAnimation(.spring(response: 0.4, dampingFraction: 0.9)) {
                        isShowingLarge = false
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        index = nil
                    }
                }
            } label: {
                Image(systemName: onConfirmMatch != nil ? "chevron.left" : "xmark")
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
            .accessibilityLabel(onConfirmMatch != nil ? "Back to results" : "Close")
        }
        .padding()
        .background(ClusterTheme.Colors.panel)
    }

    private var heroRow: some View {
        HStack(spacing: 14) {
            ZStack {
                Circle()
                    .fill(telltale)
                    .frame(width: 60, height: 60)
                    .blur(radius: 18)
                    .opacity(0.5)

                Image(carSymbol.imageName)
                    .resizable()
                    .renderingMode(.template)
                    .foregroundStyle(telltale)
                    .scaledToFit()
                    .frame(width: 38, height: 38)
            }

            VStack(alignment: .leading, spacing: 3) {
                Text(carSymbol.name)
                    .font(ClusterTheme.Types.display(18))
                    .foregroundStyle(ClusterTheme.Colors.textPrimary)
                Text(carSymbol.symbolType.title.uppercased())
                    .font(ClusterTheme.Types.mono(10, weight: .bold))
                    .tracking(1.2)
                    .foregroundStyle(telltale)
            }
            .opacity(viewModel.hasAppeared ? 1 : 0)
            .offset(y: viewModel.hasAppeared ? 0 : 8)
            .animation(.easeInOut(duration: 0.25), value: viewModel.hasAppeared)
            Spacer()
        }
        .padding(.horizontal)
        .padding(.top, 16)
    }

    private var safetyPlaquard: some View {
        HStack(spacing: 0) {
            Rectangle()
                .fill(safetyColor)
                .frame(width: 5)

            VStack(alignment: .leading, spacing: 4) {
                Text("SAFE TO DRIVE?")
                    .font(ClusterTheme.Types.mono(10, weight: .bold))
                    .tracking(1.2)
                    .foregroundStyle(safetyColor)
                Text(carSymbol.drivable.message)
                    .font(ClusterTheme.Types.body(13))
                    .foregroundStyle(ClusterTheme.Colors.textSecondary)
            }
            .padding(14)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(ClusterTheme.Colors.panel)
        .clipShape(RoundedRectangle(cornerRadius: 8))
        .overlay(
            RoundedRectangle(cornerRadius: 8)
                .stroke(ClusterTheme.Colors.bezel, lineWidth: 1)
        )
        .padding(.horizontal)
    }

    private var confirmMatchControl: some View {
        Button {
            guard !hasConfirmed else { return }
            hasConfirmed = true
            onConfirmMatch?()
        } label: {
            HStack {
                Image(systemName: "checkmark.circle.fill")
                Text("Confirm & Log This Light")
                    .font(ClusterTheme.Types.body(14, weight: .bold))
                Spacer()
            }
            .foregroundStyle(ClusterTheme.Colors.background)
            .padding(14)
            .background(ClusterTheme.Colors.amber)
            .clipShape(RoundedRectangle(cornerRadius: 10))
        }
        .buttonStyle(.plain)
        .opacity(hasConfirmed ? 0.6 : 1)
        .disabled(hasConfirmed)
        .padding(.horizontal)
    }

    private func resolvedControl(for entry: LightLogEntry) -> some View {
        Button {
            onToggleResolved?()
        } label: {
            HStack {
                Image(systemName: entry.isActive ? "checkmark.circle.fill" : "arrow.uturn.backward.circle.fill")
                Text(entry.isActive ? "Mark as Fixed" : "Mark Active Again")
                    .font(ClusterTheme.Types.body(14, weight: .bold))
                Spacer()
                Text(entry.isActive ? "ACTIVE" : "RESOLVED")
                    .font(ClusterTheme.Types.mono(10, weight: .bold))
                    .tracking(1)
            }
            .foregroundStyle(entry.isActive ? ClusterTheme.Colors.background : ClusterTheme.Colors.textPrimary)
            .padding(14)
            .background(entry.isActive ? ClusterTheme.Colors.green : ClusterTheme.Colors.panel)
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(
                        entry.isActive ? .clear : ClusterTheme.Colors.bezel,
                        lineWidth: 1
                    )
            )
            .clipShape(RoundedRectangle(cornerRadius: 10))
        }
        .buttonStyle(.plain)
        .padding(.horizontal)
    }

    private func infoPanel(label: String, body: String) -> some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(label)
                .font(ClusterTheme.Types.mono(10, weight: .bold))
                .tracking(1.2)
                .foregroundStyle(ClusterTheme.Colors.textSecondary)
            Text(body)
                .font(ClusterTheme.Types.body(14))
                .foregroundStyle(ClusterTheme.Colors.textPrimary.opacity(0.9))
                .fixedSize(horizontal: false, vertical: true)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(14)
        .clusterPanel()
        .padding(.horizontal)
    }
}
