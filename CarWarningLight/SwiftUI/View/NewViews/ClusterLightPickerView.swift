//
//  ClusterLightPickerView.swift
//  CarWarningLight
//
//  Created by Sam Greenhill on 8/11/26.
//  Copyright © 2026 simplyAmazingMachines. All rights reserved.
//

import SwiftUI

struct ClusterLightPickerView: View {
    @Environment(\.dismiss) private var dismiss

    let allLights: [CarSymbol]
    let logEntries: [LightLogEntry]
    let selectedVehicleID: UUID
    var onLogEntry: (CarSymbol) -> Void
    var onToggleResolved: (LightLogEntry) -> Void

    @State private var isScrolledDownLocal = false
    @State private var isDetailActiveLocal = false

    var body: some View {
        VStack(spacing: 0) {
            ClusterHeaderBar(title: "Add Light") { dismiss() }
                .clusterTopSafeArea(fill: ClusterTheme.Colors.panel)

            ClusterEncyclopediaView(
                allLights: allLights,
                isScrolledDown: $isScrolledDownLocal,
                logEntries: logEntries,
                selectedVehicleID: selectedVehicleID,
                onLogEntry: { symbol in
                    onLogEntry(symbol)
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        dismiss()
                    }
                },
                onToggleResolved: onToggleResolved,
                isDetailActive: $isDetailActiveLocal
            )
        }
        .background(ClusterTheme.Colors.background)
    }
}

#Preview {
    ClusterLightPickerView(
        allLights: [
            CarSymbol(id: 1, name: "Check Engine Light", imageName: "Check Engine Light", description: "Sample description.", symbolType: .warning, fixDescription: "Sample fix.", drivable: .no, categories: nil),
            CarSymbol(id: 2, name: "Battery Charging Light", imageName: "Battery Charging Light", description: "Sample description.", symbolType: .warning, fixDescription: "Sample fix.", drivable: .uncertain, categories: nil),
            CarSymbol(id: 3, name: "Tire Pressure Warning Light", imageName: "Tire Pressure Warning Light", description: "Sample description.", symbolType: .advisory, fixDescription: "Sample fix.", drivable: .yes, categories: nil),
            CarSymbol(id: 4, name: "Child Safety Lock", imageName: "Child Safety Lock", description: "Sample description.", symbolType: .info, fixDescription: "Sample fix.", drivable: .yes, categories: nil),
            CarSymbol(id: 5, name: "Adaptive Front Lighting System", imageName: "Adaptive Front Lighting System", description: "Sample description.", symbolType: .advisory, fixDescription: "Sample fix.", drivable: .yes, categories: nil),
            CarSymbol(id: 6, name: "Traction Control Light", imageName: "Traction Control Light", description: "Sample description.", symbolType: .advisory, fixDescription: "Sample fix.", drivable: .yes, categories: nil),
    ],
        logEntries: [],
        selectedVehicleID: UUID(),
        onLogEntry: { _ in },
        onToggleResolved: {_ in }
    )
}
