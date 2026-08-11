//
//  ClusterDashboardView.swift
//  CarWarningLight
//
//  Created by Sam Greenhill on 7/27/26.
//  Copyright © 2026 simplyAmazingMachines. All rights reserved.
//

import SwiftUI

struct ClusterDashboardView: View {
    @Binding var vehicles: [Vehicle]
    @Binding var selectedVehicleID: UUID
    @Binding var isScrolledDown: Bool
    let allLights: [CarSymbol]
    @Binding var logEntries: [LightLogEntry]
    var onOpenLight: (CarSymbol, LightLogEntry?) -> Void

    @State private var showGarage: Bool = false

    private var selectedVehicle: Vehicle {
        vehicles.first(where: { $0.id == selectedVehicleID }) ?? vehicles[0]
    }

    private var statuses: [SystemStatus] {
        logEntries.systemStatuses(for: selectedVehicleID)
    }

    private var activeSymbolIDs: Set<Int> {
        Set(logEntries.filter { $0.vehicleID == selectedVehicleID && $0.isActive }.map { $0.carSymbol.id })
    }

    var body: some View {
        VStack(spacing: 0) {
            header
            ClusterSystemsDashboardView(
                statuses: selectedVehicle.systemStatuses,
                isScrolledDown: $isScrolledDown
            )
        }
        .background(ClusterTheme.Colors.background)
    }

    private var header: some View {
        HStack {
            Text("Dashboard")
                .font(ClusterTheme.Types.display(17))
                .foregroundStyle(ClusterTheme.Colors.textPrimary)

            Spacer()

            Button { showGarage = true } label: {
                HStack(spacing: 6) {
                    Image(selectedVehicle.imageName)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 20, height: 20)
                    Text(selectedVehicle.name)
                        .lineLimit(1)
                    Image(systemName: "chevron.down")
                        .font(.system(size: 9, weight: .bold))
                }
                .font(ClusterTheme.Types.mono(12, weight: .semibold))
                .foregroundStyle(ClusterTheme.Colors.textPrimary)
                .padding(.horizontal, 12)
                .padding(.vertical, 8)
                .background(ClusterTheme.Colors.panel)
                .overlay(
                    Capsule()
                        .stroke(ClusterTheme.Colors.bezel, lineWidth: 1)
                )
                .clipShape(Capsule())
            }
        }
        .padding(.horizontal)
        .padding(.top, 12)
        .padding(.bottom, 4)
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
