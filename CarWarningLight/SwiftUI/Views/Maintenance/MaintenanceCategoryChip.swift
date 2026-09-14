//
//  MaintenanceCategoryChip.swift
//  CarWarningLight
//
//  Created by Sam Greenhill on 9/14/26.
//  Copyright © 2026 simplyAmazingMachines. All rights reserved.
//

import SwiftUI

struct MaintenanceCategoryChip: View {
    var category: MaintenanceCategory
    var isSelected: Bool
    var action: () -> Void

    var body: some View {
        Button(action: action) {
            VStack(spacing: 6) {
                MaintenanceIconView(
                    category: category,
                    color: isSelected ? ClusterTheme.Colors.background : ClusterTheme.Colors.textPrimary,
                    size: 20,
                    lineWidth: 1.6
                )
                Text(category.label.uppercased())
                    .font(ClusterTheme.Fonts.mono(9, weight: .bold))
                    .tracking(0.4)
                    .multilineTextAlignment(.center)
                    .lineLimit(2)
                    .minimumScaleFactor(0.85)
                    .foregroundStyle(isSelected ? ClusterTheme.Colors.background : ClusterTheme.Colors.textPrimary)
            }
            .frame(maxWidth: .infinity)
            .frame(height: 72)
            .background(isSelected ? ClusterTheme.Colors.amber : ClusterTheme.Colors.panel)
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(isSelected ? .clear : ClusterTheme.Colors.bezel, lineWidth: 1)
            )
            .clipShape(RoundedRectangle(cornerRadius: 10))
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 5), spacing: 16) {
        ForEach(MaintenanceCategory.allCases) { category in
            VStack(spacing: 6) {
                MaintenanceIconView(category: category, color: .white, size: 32)
                Text(category.label)
                    .font(.system(size: 9))
                    .foregroundStyle(.white.opacity(0.7))
            }
        }
    }
    .padding(24)
    .background(Color.black)
}
