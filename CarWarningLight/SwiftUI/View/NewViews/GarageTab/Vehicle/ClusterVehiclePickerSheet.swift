//
//  ClusterVehiclePickerSheet.swift
//  CarWarningLight
//
//  Created by Sam Greenhill on 8/18/26.
//  Copyright © 2026 simplyAmazingMachines. All rights reserved.
//

import SwiftUI

struct ClusterVehiclePickerSheet: View {
    let vehicle: [Vehicle]
    let symbol: CarSymbol
    var onSelect: (Vehicle) -> Void

    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        VStack(spacing: 0) {
            ClusterHeaderBar(title: "Log To Which Vehicle?") { dismiss() }

            ScrollView {
                VStack(alignment: .leading, spacing: 10) {
                    HStack(spacing: 10) {
                        Image(symbol.imageName)
                            .resizable()
                            .renderingMode(.template)
                            .scaledToFit()
                            .frame(width: 22, height: 22)
                            .foregroundStyle(ClusterTheme.Colors.forSymbolType(symbol.symbolType))

                        Text(symbol.name)
                            .font(ClusterTheme.Types.body(14, weight: .semibold))
                            .foregroundStyle(ClusterTheme.Colors.textPrimary)
                    }
                    .padding(.horizontal)
                    .padding(.top, 4)

                    ForEach(vehicle) { vehicle in
                        Button {
                            onSelect(vehicle)
                            dismiss()
                        } label: {
                            HStack(spacing: 12) {
                                ClusterVehicleImagePlate(imageName: vehicle.imageName, size: 36)
                                    .clipShape(RoundedRectangle(cornerRadius: 6))
                                Text(vehicle.name)
                                    .font(ClusterTheme.Types.body(15, weight: .semibold))
                                    .foregroundStyle(ClusterTheme.Colors.textPrimary)
                                Spacer()
                                Image(systemName: "chevron.right")
                                    .font(.system(size: 12, weight: .semibold))
                                    .foregroundStyle(ClusterTheme.Colors.textSecondary)
                            }
                            .padding(12)
                            .clusterPanel()
                        }
                        .buttonStyle(.plain)
                        .padding(.horizontal)
                    }
                }
                .padding(.top, 12)
                .padding(.bottom, 24)
            }
        }
        .background(ClusterTheme.Colors.background)
    }
}

#Preview {
    ClusterEncyclopediaView(allLights: [
        CarSymbol(id: 1, name: "Check Engine Light", imageName: "Check Engine Light", description: "Sample description.", symbolType: .warning, fixDescription: "Sample fix.", drivable: .no, categories: nil),
        CarSymbol(id: 2, name: "Battery Charging Light", imageName: "Battery Charging Light", description: "Sample description.", symbolType: .warning, fixDescription: "Sample fix.", drivable: .uncertain, categories: nil),
        CarSymbol(id: 3, name: "Tire Pressure Warning Light", imageName: "Tire Pressure Warning Light", description: "Sample description.", symbolType: .advisory, fixDescription: "Sample fix.", drivable: .yes, categories: nil),
        CarSymbol(id: 4, name: "Child Safety Lock", imageName: "Child Safety Lock", description: "Sample description.", symbolType: .info, fixDescription: "Sample fix.", drivable: .yes, categories: nil),
        CarSymbol(id: 5, name: "Adaptive Front Lighting System", imageName: "Adaptive Front Lighting System", description: "Sample description.", symbolType: .advisory, fixDescription: "Sample fix.", drivable: .yes, categories: nil),
        CarSymbol(id: 6, name: "Traction Control Light", imageName: "Traction Control Light", description: "Sample description.", symbolType: .advisory, fixDescription: "Sample fix.", drivable: .yes, categories: nil),
    ],
                            isScrolledDown: .constant(false),
                            logEntries: [],
                            selectedVehicleID: UUID(),
                            isDetailActive: .constant(false))
    .preferredColorScheme(.dark)
}
