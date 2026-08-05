//
//  GarageView.swift
//  CarWarningLight
//
//  Created by Sam Greenhill on 7/27/26.
//  Copyright © 2026 simplyAmazingMachines. All rights reserved.
//

import SwiftUI

struct GarageView: View {
    @Environment(\.dismiss) private var dismiss
    @Binding var vehicles: [Vehicle]
    @Binding var selectedVehicleID: UUID
    let logEntries: [LightLogEntry]
    @State private var showAddVehicle: Bool = false

    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            Text("GARAGE")
                .font(ClusterTheme.Types.mono(12, weight: .bold))
                .tracking(1.5)
                .foregroundStyle(ClusterTheme.Colors.textSecondary)
                .padding(.top, 20)

            ForEach(vehicles) { vehicle in
                let statuses = logEntries.systemStatuses(for: vehicle.id)
                let total = statuses.reduce(0) { $0 + $1.activeCount }
                let worst = statuses.compactMap(\.worstSeverity).min { $0.severityRank < $1.severityRank }

                VehicleRow(
                    vehicle: vehicle,
                    isSelected: vehicle.id == selectedVehicleID,
                    totalActive: total,
                    worstSeverity: worst
                )
                    .onTapGesture {
                        selectedVehicleID = vehicle.id
                        dismiss()
                    }
            }

            Button { showAddVehicle = true } label: {
                HStack {
                    Image(systemName: "plus")
                    Text("Add vehicle")
                    Spacer()
                }
                .font(ClusterTheme.Types.body(14, weight: .semibold))
                .foregroundStyle(ClusterTheme.Colors.textSecondary)
                .padding(14)
                .frame(maxWidth: .infinity)
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .strokeBorder(ClusterTheme.Colors.bezel, style: StrokeStyle(lineWidth: 1, dash: [5]))
                )
            }
            Spacer()
        }
        .padding(.horizontal)
        .background(ClusterTheme.Colors.background)
        .presentationBackground(ClusterTheme.Colors.background)
        .presentationDetents([.medium])
        .sheet(isPresented: $showAddVehicle) {
            ClusterAddVehicleView { newVehicle in
                vehicles.append(newVehicle)
                selectedVehicleID = newVehicle.id
            }
        }
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
                logEntries: $logEntries
            )
            .environmentObject(UIStateManager())
            .preferredColorScheme(.dark)
        }
    }
    return PreviewHost()
}
