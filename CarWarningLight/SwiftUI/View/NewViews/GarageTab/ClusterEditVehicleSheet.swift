//
//  ClusterEditVehicleSheet.swift
//  CarWarningLight
//
//  Created by Sam Greenhill on 8/17/26.
//  Copyright © 2026 simplyAmazingMachines. All rights reserved.
//

import SwiftUI

struct ClusterEditVehicleSheet: View {
    @Bindable var vehicle: Vehicle
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        VStack(spacing: 0) {
            ClusterHeaderBar(title: "Edit Vehicle") { dismiss() }
            VStack(alignment: .leading, spacing: 8) {
                Text("NICKNAME")
                    .font(ClusterTheme.Types.mono(11, weight: .bold))
                    .tracking(1.2)
                    .foregroundStyle(ClusterTheme.Colors.textSecondary)
                TextField("Vehicle name", text: $vehicle.name)
                    .font(ClusterTheme.Types.body(16))
                    .foregroundStyle(ClusterTheme.Colors.textPrimary)
                    .padding(14)
                    .background(ClusterTheme.Colors.panel)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(ClusterTheme.Colors.bezel, lineWidth: 1)
                    )
                    .clipShape(RoundedRectangle(cornerRadius: 10))
            }
            .padding()
            Spacer()
        }
        .background(ClusterTheme.Colors.background)
    }
}

#Preview {
    ClusterGarageView(isScrolledDown: .constant(false))
}
