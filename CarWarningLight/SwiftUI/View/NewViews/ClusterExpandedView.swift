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
    @StateObject var viewModel          = ExpandedViewModel()

    let carSymbol: CarSymbol
    var namespace: Namespace.ID
    @Binding var isShowingLarge: Bool
    let bigImageId: Int
    @Binding var index: Int?

    var logEntry: LightLogEntry?        = nil
    var onToggleResolved: (() -> Void)? = nil

    private var telltale: Color { ClusterTheme.Colors.forSymbolType(carSymbol.symbolType) }
    private var safetyColor: Color { ClusterTheme.Colors.forDrivable(carSymbol.drivable) }


    var body: some View {
        VStack(spacing: 0) {
            headerBar

            ScrollView {
                VStack(alignment: .leading, spacing: 14) {
                    heroRow
                    safetyPlaquard
                    if let logEntry {
                        resolvedControl(for: logEntry)
                    }
                    infoPanel(label: "DESCRIPTION", body: carSymbol.description)
                    infoPanel(label: "HOW TO FIX", body: carSymbol.fixDescription)
                }
                .padding(.bottom, 24)
            }
        }
        .background(ClusterTheme.Colors.background)
        .onAppear {
            uiState.detailViewAppeared(id: carSymbol.imageName)
            viewModel.resetAnimations()
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                viewModel.startAnimations()
                viewModel.hasAppeared = true
            }
        }
        .onDisappear {
            viewModel.cancelAnimations()
            uiState.detailViewDisappeared(id: carSymbol.imageName)
            if !viewModel.isDismissing { viewModel.hasAppeared = false }
        }
    }

    private var headerBar: some View {
        HStack {
            Text("WARNING LIGHT")
                .font(ClusterTheme.Types.mono(11, weight: .bold))
                .tracking(1.5)
                .foregroundStyle(ClusterTheme.Colors.textSecondary)
            Spacer()
            Button {
                guard viewModel.showDismissButton else { return }
                viewModel.dismissView()
                withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
                    isShowingLarge = false
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
                    index = nil
                }
            } label: {
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
            .opacity(viewModel.showDismissButton ? 1 : 0.5)
            .accessibilityLabel("Close")
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
                    .matchedGeometryEffect(
                        id: isShowingLarge ? "\(bigImageId)" : "\(index ?? 0) logo",
                        in: namespace,
                        isSource: false
                    )
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

#Preview("Browsing encyclopedia — no log context") {
    struct PreviewHost: View {
        @Namespace var ns
        @State var isShowingLarge: Bool = true
        @State var index: Int? = 0
        let sample = CarSymbol(
                    id: 1, name: "Check Engine Light",
                    imageName: "Check Engine Light",
                    description: "This light indicates there's an issue with the engine. It could mean something minor, like a loose gas cap, or a much larger problem.",
                    symbolType: .warning,
                    fixDescription: "Get a professional mechanic to check it out, especially if the light is blinking.",
                    drivable: .no, categories: nil
                )

        var body: some View {
            ClusterExpandedView(
                carSymbol: sample, namespace: ns, isShowingLarge: $isShowingLarge, bigImageId: 1, index: $index
            )
            .environmentObject(UIStateManager())
            .preferredColorScheme(.dark)
        }
    }
    return PreviewHost()
}


#Preview("From Trip Log — active") {
    struct PreviewHost: View {
        @Namespace var ns
        @State var isShowingLarge: Bool = true
        @State var index: Int? = 0
        @State var entry = LightLogEntry(
            carSymbol: CarSymbol(
                id: 1,
                name: "Check Engine Light",
                imageName: "Check Engine Light",
                description: "This light indicates there's an issue with the engine. It could mean something minor, like a loose gas cap, or a much larger problem.",
                symbolType: .warning,
                fixDescription: "Get a professional mechanic to check it out, especially if the light is blinking.",
                drivable: .no,
                categories: nil
            ),
            dateLogged: Date()
        )

        var body: some View {
            ClusterExpandedView(
                carSymbol: entry.carSymbol,
                namespace: ns,
                isShowingLarge: $isShowingLarge,
                bigImageId: 1,
                index: $index,
                logEntry: entry,
                onToggleResolved: { entry.isActive.toggle() }
            )
            .environmentObject(UIStateManager())
            .preferredColorScheme(.dark)
        }
    }
    return PreviewHost()
}
