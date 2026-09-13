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
                            .font(ClusterTheme.Fonts.body(14, weight: .semibold))
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
                                    .font(ClusterTheme.Fonts.body(15, weight: .semibold))
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
    ClusterEncyclopediaView(
                            isScrolledDown: .constant(false),
                            isDetailActive: .constant(false))
    .preferredColorScheme(.dark)
}
