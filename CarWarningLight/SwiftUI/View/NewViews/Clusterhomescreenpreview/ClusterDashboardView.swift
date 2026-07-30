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
    @State private var showGarage: Bool = false

    private var selectedVehicle: Vehicle {
        vehicles.first(where: { $0.id == selectedVehicleID }) ?? vehicles[0]
    }

    var body: some View {
        VStack(spacing: 0) {
            header
            ClusterSystemsDashboardView(statuses: selectedVehicle.systemStatuses, isScrolledDown: $isScrolledDown)
        }
        .background(ClusterTheme.Colors.background)
        .sheet(isPresented: $showGarage) {
            GarageView(vehicles: $vehicles, selectedVehicleID: $selectedVehicleID)
        }
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
            ClusterDashboardView(vehicles: $vehicles, selectedVehicleID: $selectedVehicleID, isScrolledDown: .constant(false))
        }
    }
    return PreviewHost()
}
