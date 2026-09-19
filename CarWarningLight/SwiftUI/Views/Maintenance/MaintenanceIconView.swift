//
//  MaintenanceIconView.swift
//  CarWarningLight
//
//  Created by Sam Greenhill on 9/14/26.
//  Copyright © 2026 simplyAmazingMachines. All rights reserved.
//

import SwiftUI

// MARK: - Icon view

struct MaintenanceIconView: View {
    let category: MaintenanceCategory
    var color: Color = ClusterTheme.Colors.amber
    var size: CGFloat = 22
    var lineWidth: CGFloat = 1.8

    var body: some View {
        Group {
            switch category {
            case .other:
                Image(systemName: category.icon)
                    .resizable()
                    .scaledToFit()
                    .font(.system(size: size * 0.8, weight: .semibold))
            default:
                Image(category.icon)
                    .resizable()
                    .renderingMode(.template)
                    .scaledToFit()
                    .frame(width: size + 10, height: size + 10)
            }
        }
        .foregroundStyle(color)
        .frame(width: size, height: size)
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
