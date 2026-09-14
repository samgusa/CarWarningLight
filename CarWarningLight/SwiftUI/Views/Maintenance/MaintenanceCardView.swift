//
//  MaintenanceCardView.swift
//  CarWarningLight
//
//  Created by Sam Greenhill on 9/13/26.
//  Copyright © 2026 simplyAmazingMachines. All rights reserved.
//

import SwiftUI

struct MaintenanceCardView: View {
    let item: MaintenanceItem

    private var relativeDate: String {
        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .abbreviated
        return formatter.localizedString(for: item.dateCreated, relativeTo: Date())
    }

    var body: some View {
        HStack(spacing: 12) {
            ZStack {
                RoundedRectangle(cornerRadius: 8)
                    .fill(ClusterTheme.Colors.panel)
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(ClusterTheme.Colors.bezel, lineWidth: 1)
                    )
                MaintenanceIconView(
                    category: item.category,
                    color: item.isActive ? ClusterTheme.Colors.amber : ClusterTheme.Colors.textSecondary,
                    size: 22
                )
            }
            .frame(width: 44, height: 44)

            VStack(alignment: .leading, spacing: 3) {
                Text(item.title)
                    .font(ClusterTheme.Fonts.body(14, weight: .semibold))
                    .foregroundStyle(ClusterTheme.Colors.textPrimary)
                    .lineLimit(1)
                Text(relativeDate.uppercased())
                    .font(ClusterTheme.Fonts.mono(10, weight: .semibold))
                    .foregroundStyle(ClusterTheme.Colors.textSecondary)
            }
            Spacer()

            Text(item.isActive ? "NEEDED" : "DONE")
                .font(ClusterTheme.Fonts.mono(9, weight: .bold))
                .tracking(1.0)
                .foregroundStyle(item.isActive ? ClusterTheme.Colors.amber : ClusterTheme.Colors.green)
        }
        .padding(12)
        .clusterPanel()
    }
}

#Preview {
    let item = MaintenanceItem(vehicle: nil, category: .wiperBlades, noteText: "Streaking badly in the rain")

    return MaintenanceCardView(item: item)
        .padding()
        .background(ClusterTheme.Colors.background)
}
