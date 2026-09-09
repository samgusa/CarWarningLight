//
//  IssueCardView.swift
//  CarWarningLight
//
//  Created by Sam Greenhill on 8/17/26.
//  Copyright © 2026 simplyAmazingMachines. All rights reserved.
//

import SwiftUI

struct IssueCardView: View {
    @Environment(\.allLights) private var allLights
    let issue: VehicleIssue

    private var relativeDate: String {
        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .abbreviated
        return formatter.localizedString(for: issue.dateCreated, relativeTo: Date())
    }
    var body: some View {
        HStack(spacing: 12) {
            ClusterStackedIcon(
                icons: issue.sortedCategories.map(\.icon),
                tint: ClusterTheme.Colors.amber,
                isDimmed: !issue.isActive
            )

            VStack(alignment: .leading, spacing: 3) {
                Text(issue.displayTitle(allLights: allLights))
                    .font(ClusterTheme.Types.body(14, weight: .semibold))
                    .foregroundStyle(ClusterTheme.Colors.textPrimary)
                    .lineLimit(1)

                HStack {
                    if issue.sortedCategories.count > 1 {
                        Text("+\(issue.sortedCategories.count - 1) more")
                            .font(ClusterTheme.Types.mono(9, weight: .semibold))
                            .foregroundStyle(ClusterTheme.Colors.textSecondary)
                            .padding(.horizontal, 6)
                            .padding(.vertical, 2)
                            .background(ClusterTheme.Colors.bezel.opacity(0.5))
                            .clipShape(RoundedRectangle(cornerRadius: 4))
                    }
                    Text(relativeDate.uppercased())
                        .font(ClusterTheme.Types.mono(10, weight: .semibold))
                        .foregroundStyle(ClusterTheme.Colors.textSecondary)
                }
            }
            Spacer()

            Text(issue.isActive ? "ACTIVE" : "RESOLVED")
                .font(ClusterTheme.Types.mono(9, weight: .bold))
                .tracking(1.0)
                .foregroundStyle(issue.isActive ? ClusterTheme.Colors.amber : ClusterTheme.Colors.green)
        }
        .padding(12)
        .clusterPanel()
    }
}

#Preview {
    let issue = VehicleIssue(vehicle: nil, categories: [.noise, .vibration], noteText: "Grinding noise from front left when braking.")
    return IssueCardView(issue: issue)
        .padding()
        .background(ClusterTheme.Colors.background)
}
