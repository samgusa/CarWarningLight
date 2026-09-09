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

    @Environment(\.allLights) private var allLights
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
                isScrolledDown: $isScrolledDownLocal,
                onLogEntry: { symbol in
                    onLogEntry(symbol)
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        dismiss()
                    }
                },
                isDetailActive: $isDetailActiveLocal
            )
        }
        .background(ClusterTheme.Colors.background)
    }
}

#Preview {
    ClusterLightPickerView(
        logEntries: [],
        selectedVehicleID: UUID(),
        onLogEntry: { _ in },
        onToggleResolved: {_ in }
    )
}
