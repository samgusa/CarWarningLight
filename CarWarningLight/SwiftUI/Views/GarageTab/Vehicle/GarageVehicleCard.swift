//
//  GarageVehicleCard.swift
//  CarWarningLight
//
//  Created by Sam Greenhill on 8/17/26.
//  Copyright © 2026 simplyAmazingMachines. All rights reserved.
//

import SwiftUI

struct GarageVehicleCard: View {
    let vehicle: Vehicle

    private var statusColor: Color {
        guard vehicle.totalActive > 0 else { return ClusterTheme.Colors.green }
        return vehicle.worstSeverity.map(ClusterTheme.Colors.forSymbolType) ?? ClusterTheme.Colors.amber
    }

    var body: some View {
        VStack(spacing: 10) {
            ZStack(alignment: .topTrailing) {
                ClusterVehicleImagePlate(imageName: vehicle.sideProfileImageName, size: 80)

                Circle()
                    .fill(statusColor)
                    .frame(width: 12, height: 12)
                    .overlay(
                        Circle()
                            .stroke(ClusterTheme.Colors.panel, lineWidth: 2)
                    )
                    .offset(x: 4, y: -2)
            }
            .padding(.top, 6)

            Text(vehicle.name)
                .font(ClusterTheme.Fonts.body(15, weight: .bold))
                .foregroundStyle(ClusterTheme.Colors.textPrimary)
                .lineLimit(1)

            Text(vehicle.totalActive > 0 ? "\(vehicle.totalActive) active" : "All clear")
                .font(ClusterTheme.Fonts.mono(11, weight: .semibold))
                .tracking(0.6)
                .foregroundStyle(vehicle.totalActive > 0 ? statusColor : ClusterTheme.Colors.textSecondary)
        }
        .frame(maxWidth: .infinity)
        .frame(height: 180)
        .clusterPanel(cornerRadius: 12)
    }
}

#Preview {
    let vehicle = Vehicle(name: "My Civic", imageName: "sideSedan")
    return HStack {
        GarageVehicleCard(vehicle: vehicle)
    }
    .padding()
    .background(ClusterTheme.Colors.background)
}
