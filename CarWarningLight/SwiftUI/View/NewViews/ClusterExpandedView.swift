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
    @Environment(\.dismiss) private var dismiss

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
    var onDeleteEntry: (() -> Void)?        = nil


    @State private var hasConfirmed: Bool       = false
    @State private var hasLoggedNow: Bool       = false
    @State private var showDeleteConfirm: Bool  = false

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

                    ClusterAccentBanner(
                        icon: "shield.lefthalf.filled",
                        title: "Safe To Drive?",
                        subtitle: carSymbol.drivable.message,
                        tint: safetyColor
                    )
                    .padding(.horizontal)

                    actionControl
                    if onDeleteEntry != nil {
                        deleteControl
                    }
                    infoPanel(label: "DESCRIPTION", body: carSymbol.description)
                    infoPanel(label: "HOW TO FIX", body: carSymbol.fixDescription)
                }
                .padding(.bottom, 24)
            }
        }
    }

    @ViewBuilder
    private var actionControl: some View {
        if onConfirmMatch != nil {
            confirmMatchControl
        } else if let logEntry {
            resolvedControl(for: logEntry)
        } else if onLogEntry != nil {
            logThisLightControl
        }
    }

    private func closeDetail() {
        if let onDismiss {
            onDismiss()
        } else if isStandAlone {
            dismiss()
        } else {
            withAnimation(.spring(response: 0.4, dampingFraction: 0.9)) {
                isShowingLarge      = false
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                index               = nil
            }
        }
    }

    private var headerBar: some View {
        ClusterHeaderBar(
            title: headerTitle,
            icon: onConfirmMatch != nil ? "chevron.left" : "xmark"
        ) {
            closeDetail()
        }
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

    private var confirmMatchControl: some View {
        ClusterConsoleActionButton(
            icon: "checkmark",
            label: hasConfirmed ? "Confirmed" : "Confirm & Log This Light",
            isEnabled: !hasConfirmed
        ) {
            guard !hasConfirmed else { return }
            hasConfirmed = true
            onConfirmMatch?()
        }
        .padding(.horizontal)
    }

    private var logThisLightControl: some View {
        ClusterConsoleActionButton(
            icon: hasLoggedNow ? "checkmark" : "plus",
            label: hasLoggedNow ? "Logged" : "Log This Light",
            isEnabled: !hasLoggedNow) {
                guard !hasLoggedNow else { return }
                hasLoggedNow = true
                onLogEntry?()
            }
            .padding(.horizontal)
            .animation(.spring(response: 0.35, dampingFraction: 0.85), value: hasLoggedNow)
    }

    private func resolvedControl(for entry: LightLogEntry) -> some View {
        ClusterStatusToggle(isActive: entry.isActive) {
            onToggleResolved?()
        }
        .padding(.horizontal)
    }

    private var deleteControl: some View {
        Button(role: .destructive) {
            showDeleteConfirm = true
        } label: {
            Text("Delete Light")
                .font(ClusterTheme.Types.body(14, weight: .semibold))
                .foregroundStyle(ClusterTheme.Colors.red)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 12)
        }
        .padding(.horizontal)
        .alert("Delete this logged light", isPresented: $showDeleteConfirm) {
            Button("Cencel", role: .cancel) { }
            Button("Delete", role: .destructive) {
                onDeleteEntry?()
                closeDetail()
            }
        }
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

#Preview {
    ClusterEncyclopediaView(allLights: [
        CarSymbol(id: 1, name: "Check Engine Light", imageName: "Check Engine Light", description: "Sample description.", symbolType: .warning, fixDescription: "Sample fix.", drivable: .no, categories: nil),
        CarSymbol(id: 2, name: "Battery Charging Light", imageName: "Battery Charging Light", description: "Sample description.", symbolType: .warning, fixDescription: "Sample fix.", drivable: .uncertain, categories: nil),
        CarSymbol(id: 3, name: "Tire Pressure Warning Light", imageName: "Tire Pressure Warning Light", description: "Sample description.", symbolType: .advisory, fixDescription: "Sample fix.", drivable: .yes, categories: nil),
        CarSymbol(id: 4, name: "Child Safety Lock", imageName: "Child Safety Lock", description: "Sample description.", symbolType: .info, fixDescription: "Sample fix.", drivable: .yes, categories: nil),
        CarSymbol(id: 5, name: "Adaptive Front Lighting System", imageName: "Adaptive Front Lighting System", description: "Sample description.", symbolType: .advisory, fixDescription: "Sample fix.", drivable: .yes, categories: nil),
        CarSymbol(id: 6, name: "Traction Control Light", imageName: "Traction Control Light", description: "Sample description.", symbolType: .advisory, fixDescription: "Sample fix.", drivable: .yes, categories: nil),
    ],
                            isScrolledDown: .constant(false),
                            logEntries: [],
                            selectedVehicleID: UUID(),
                            isDetailActive: .constant(false))
    .preferredColorScheme(.dark)
}
