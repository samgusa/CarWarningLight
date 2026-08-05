//
//  ClusterCategoryLightsView.swift
//  CarWarningLight
//
//  Created by Sam Greenhill on 8/4/26.
//  Copyright © 2026 simplyAmazingMachines. All rights reserved.
//

import SwiftUI

struct ClusterCategoryLightsView: View {
    @Environment(\.dismiss) private var dismiss

    let system: VehicleSystem
    let lights: [CarSymbol]
    let activeSymbolID: Set<Int>
    var onSelectLight: (CarSymbol) -> Void

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 12) {
                ClusterHeaderBar(title: system.rawValue) { dismiss() }

                if lights.isEmpty {
                    emptyState
                } else {
                    VStack(spacing: 10) {
                        ForEach(lights) { light in
                            row(for: light)
                                .onTapGesture { onSelectLight(light) }
                                .padding(.horizontal)
                        }
                    }
                    .padding(.top, 4)
                }
            }
            .padding(.bottom, 24)
        }
        .background(
            ClusterTheme.Colors.background.ignoresSafeArea()
        )
    }

    private func row(for light: CarSymbol) -> some View {
        let telltale = ClusterTheme.Colors.forSymbolType(light.symbolType)
        let isActive = activeSymbolID.contains(light.id)

        return HStack(spacing: 12) {
            ZStack {
                Circle()
                    .fill(telltale)
                    .frame(width: 20, height: 20)
                    .blur(radius: 8)
                    .opacity(isActive ? 0.5 : 0.15)

                Image(light.imageName)
                    .resizable()
                    .renderingMode(.template)
                    .scaledToFit()
                    .frame(width: 22, height: 22)
                    .foregroundStyle(isActive ? telltale : ClusterTheme.Colors.textSecondary)
            }
            .frame(width: 44, height: 44)

            VStack(alignment: .leading, spacing: 2) {
                Text(light.name)
                    .font(ClusterTheme.Types.body(14, weight: .semibold))
                    .foregroundStyle(ClusterTheme.Colors.textPrimary)
                    .lineLimit(1)
                Text(light.symbolType.title.uppercased())
                    .font(ClusterTheme.Types.mono(10, weight: .semibold))
                    .foregroundStyle(telltale)
            }
            Spacer()

            if isActive {
                Text("ACTIVE")
                    .font(ClusterTheme.Types.mono(9, weight: .bold))
                    .tracking(0.8)
                    .foregroundStyle(telltale)
            } else {
                Image(systemName: "chevron.right")
                    .font(.system(size: 12, weight: .semibold))
                    .foregroundStyle(ClusterTheme.Colors.textSecondary)
            }
        }
        .padding(12)
        .clusterPanel()
        .contentShape(Rectangle())
    }

    private var emptyState: some View {
        VStack(spacing: 10) {
            Image(systemName: "checkmark.seal")
                .font(.system(size: 32))
                .foregroundStyle(ClusterTheme.Colors.textSecondary)
            Text("No lights in this category yet")
                .font(ClusterTheme.Types.body(15, weight: .semibold))
                .foregroundStyle(ClusterTheme.Colors.textPrimary)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 60)
    }
}

#Preview {
    ClusterCategoryLightsView(
        system: .engine,
        lights: [
            CarSymbol(id: 23, name: "Check Engine Light", imageName: "Check Engine Light", description: "", symbolType: .warning, fixDescription: "", drivable: .no, categories: ["Engine & Powertrain"]),
            CarSymbol(id: 49, name: "Low Fuel Level", imageName: "Low Fuel Level", description: "", symbolType: .advisory, fixDescription: "", drivable: .no, categories: ["Engine & Powertrain"])
        ],
        activeSymbolID: [23],
        onSelectLight: { _ in }
    )
    .preferredColorScheme(.dark)
}
