//
//  LogEntryRow.swift
//  CarWarningLight
//
//  Created by Sam Greenhill on 7/27/26.
//  Copyright © 2026 simplyAmazingMachines. All rights reserved.
//

import SwiftUI

struct LogEntryRow: View {
    let entry: LightLogEntry

    private var telltale: Color { ClusterTheme.Colors.forSymbolType(entry.carSymbol.symbolType) }

    private var relativeDate: String {
        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .abbreviated
        return formatter.localizedString(for: entry.dateLogged, relativeTo: Date())
    }
    var body: some View {
        HStack(spacing: 12) {
            ZStack {
                Circle()
                    .fill(telltale)
                    .frame(width: 20, height: 20)
                    .blur(radius: 8)
                    .opacity(entry.isActive ? 0.5 : 0.15)

                Image(entry.carSymbol.imageName)
                    .resizable()
                    .renderingMode(.template)
                    .scaledToFit()
                    .frame(width: 22, height: 22)
                    .foregroundStyle(entry.isActive ? telltale : ClusterTheme.Colors.textSecondary)
            }
            .frame(width: 44, height: 44)

            VStack(alignment: .leading, spacing: 2) {
                Text(entry.carSymbol.name)
                    .font(ClusterTheme.Types.body(14, weight: .semibold))
                    .foregroundStyle(ClusterTheme.Colors.textPrimary)
                    .lineLimit(1)
                Text(relativeDate.uppercased())
                    .font(ClusterTheme.Types.mono(10, weight: .semibold))
                    .foregroundStyle(ClusterTheme.Colors.textSecondary)
            }
            Spacer()

            Text(entry.isActive ? "ACTIVE" : "FIXED")
                .font(ClusterTheme.Types.mono(9, weight: .bold))
                .tracking(0.8)
                .foregroundStyle(entry.isActive ? telltale : ClusterTheme.Colors.green)
        }
        .padding(12)
        .clusterPanel()
    }
}

#Preview {
    let sampleEngine = CarSymbol(
        id: 1, name: "Check Engine Light", imageName: "Check Engine Light",
        description: "", symbolType: .warning, fixDescription: "", drivable: .no, categories: nil
    )
    let sampleBattery = CarSymbol(
        id: 2, name: "Battery Charging Light", imageName: "Battery Charging Light",
        description: "", symbolType: .warning, fixDescription: "", drivable: .uncertain, categories: nil
    )
    let sampleTire = CarSymbol(
        id: 3, name: "Tire Pressure Warning Light", imageName: "Tire Pressure Warning Light",
        description: "", symbolType: .advisory, fixDescription: "", drivable: .yes, categories: nil
    )
    return ClusterTripLogView(
        isScrolledDown: .constant(false),
        entries: [
        LightLogEntry(
            carSymbol: sampleEngine,
            dateLogged: Date().addingTimeInterval(-3600)),
        LightLogEntry(
            carSymbol: sampleTire,
            dateLogged: Date().addingTimeInterval(-86400 * 2)),
        LightLogEntry(
            carSymbol: sampleBattery,
            dateLogged: Date().addingTimeInterval(-86400 * 9),
            isActive: false)
    ]
    )
}
