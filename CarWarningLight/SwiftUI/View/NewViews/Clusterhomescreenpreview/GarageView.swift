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
    @State private var showAddVehicle: Bool = false

    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            Text("GARAGE")
                .font(ClusterTheme.Types.mono(12, weight: .bold))
                .tracking(1.5)
                .foregroundStyle(ClusterTheme.Colors.textSecondary)
                .padding(.top, 20)

            ForEach(vehicles) { vehicle in
                VehicleRow(vehicle: vehicle, isSelected: vehicle.id == selectedVehicleID)
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

        init() {
            // 1. Create the initial data array locally
            let initialVehicles = [
                Vehicle(name: "My Civic", systemStatuses: [
                    SystemStatus(system: .engine, activeCount: 1, worstSeverity: .warning),
                    SystemStatus(system: .braking, activeCount: 0),
                    SystemStatus(system: .electrical, activeCount: 0),
                    SystemStatus(system: .lighting, activeCount: 1, worstSeverity: .advisory),
                    SystemStatus(system: .driverAssist, activeCount: 0),
                    SystemStatus(system: .tiresSuspension, activeCount: 0),
                    SystemStatus(system: .comfort, activeCount: 0),
                ], imageName: "vehicleSedan"),
                Vehicle(name: "Wife's CR-V", systemStatuses: VehicleSystem.allCases.map { SystemStatus(system: $0) }, imageName: "vehicleSUV")
            ]

            // 2. Initialize both State wrappers safely
            _vehicles = State(initialValue: initialVehicles)
            _selectedVehicleID = State(initialValue: initialVehicles[0].id)
        }

        var body: some View {
            ClusterDashboardView(vehicles: $vehicles, selectedVehicleID: $selectedVehicleID)
        }
    }
    return PreviewHost()
}
