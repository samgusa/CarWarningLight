//
//  VehicleRow.swift
//  CarWarningLight
//
//  Created by Sam Greenhill on 7/27/26.
//  Copyright © 2026 simplyAmazingMachines. All rights reserved.
//

import SwiftUI

struct VehicleRow: View {
    let vehicle: Vehicle
    let isSelected: Bool
    let totalActive: Int
    let worstSeverity: SymbolType?

    private var statusColor: Color {
        guard let worstSeverity else { return ClusterTheme.Colors.textSecondary }
        return ClusterTheme.Colors.forSymbolType(worstSeverity)
    }


    var body: some View {
        HStack(spacing: 14) {
            ZStack(alignment: .bottomTrailing) {
                Image(vehicle.imageName)
                    .resizable()
                    .scaledToFit()
                    .padding(8)
                    .frame(width: 64, height: 64)
                    .background(ClusterTheme.Colors.background)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(ClusterTheme.Colors.bezel, lineWidth: 1)
                    )

                if vehicle.totalActive > 0 {
                    Circle()
                        .fill(statusColor)
                        .frame(width: 14, height: 14)
                        .overlay(
                            Circle()
                                .stroke(ClusterTheme.Colors.panel, lineWidth: 2)
                        )
                        .offset(x: 4, y: 4)
                }
            }
            VStack(alignment: .leading, spacing: 2) {
                Text(vehicle.name)
                    .font(ClusterTheme.Types.body(15, weight: .semibold))
                    .foregroundStyle(ClusterTheme.Colors.textPrimary)
                Text(vehicle.totalActive > 0 ? "\(vehicle.totalActive) active" : "All clear")
                    .font(ClusterTheme.Types.mono(10, weight: .semibold))
                    .foregroundStyle(statusColor)
            }
            Spacer()

            if isSelected {
                Image(systemName: "checkmark.circle.fill")
                    .foregroundStyle(ClusterTheme.Colors.amber)
            }
        }
        .padding(12)
        .clusterPanel()
        .overlay(
            RoundedRectangle(cornerRadius: 8)
                .stroke(isSelected ? ClusterTheme.Colors.amber.opacity(0.6) : .clear, lineWidth: 1.5)
        )
    }
}

#Preview {
    struct PreviewHost: View {
        @State var vehicles: [Vehicle]
        @State var selectedVehicleID: UUID
        @State var logEntries: [LightLogEntry]
        let sampleLights: [CarSymbol]

        init() {
            let initialVehicles = [
                Vehicle(name: "My Civic", systemStatuses: [], imageName: "vehicleSedan"),
                Vehicle(name: "Wife's CR-V", systemStatuses: [], imageName: "vehicleSUV")
            ]
            _vehicles = State(initialValue: initialVehicles)
            _selectedVehicleID = State(initialValue: initialVehicles[0].id)

            let checkEngine = CarSymbol(id: 23, name: "Check Engine Light", imageName: "Check Engine Light", description: "Sample.", symbolType: .warning, fixDescription: "Sample.", drivable: .no, categories: ["Engine & Powertrain"])
            let fogLight = CarSymbol(id: 75, name: "Fog Lights On", imageName: "Fog Lights On", description: "Sample.", symbolType: .info, fixDescription: "Sample.", drivable: .yes, categories: ["Lighting"])
            sampleLights = [checkEngine, fogLight]
            _logEntries = State(initialValue: [
                LightLogEntry(carSymbol: checkEngine, dateLogged: Date(), vehicleID: initialVehicles[0].id)
            ])
        }

        var body: some View {
            ClusterDashboardView(
                vehicles: $vehicles,
                selectedVehicleID: $selectedVehicleID,
                isScrolledDown: .constant(false),
                allLights: sampleLights,
                logEntries: $logEntries,
                onOpenLight: { _, _ in }
            )
            .environmentObject(UIStateManager())
            .preferredColorScheme(.dark)
        }
    }
    return PreviewHost()
}
