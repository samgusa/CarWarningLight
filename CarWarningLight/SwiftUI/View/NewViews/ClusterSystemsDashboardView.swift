//
//  ClusterSystemsDashboardView.swift
//  CarWarningLight
//
//  Created by Sam Greenhill on 7/26/26.
//  Copyright © 2026 simplyAmazingMachines. All rights reserved.
//

import SwiftUI

struct ClusterSystemsDashboardView: View {
    let statuses: [SystemStatus]
    var onSelect: (VehicleSystem) -> Void = { _ in }
    @Binding var isScrolledDown: Bool

    private let columns = [GridItem(.flexible(), spacing: 12), GridItem(.flexible(), spacing: 12)]

    private var totalActive: Int { statuses.reduce(0) { $0 + $1.activeCount } }

    private var activeSystemCount: Int { statuses.filter(\.isActive).count }

    private func severityRank(_ type: SymbolType) -> Int {
        switch type {
        case .warning:  return 0
        case .advisory: return 1
        case .info:     return 2
        }
    }

    private var worstOverall: SymbolType? {
        statuses.compactMap(\.worstSeverity).min { severityRank($0) < severityRank($1) }
    }

    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                statusBanner

                LazyVGrid(columns: columns, spacing: 12) {
                    ForEach(statuses) { status in
                        SystemGaugeTile(status: status)
                            .contentShape(Rectangle())
                            .onTapGesture { onSelect(status.system) }
                    }
                }
                .padding(.horizontal)
            }
            .padding(.vertical, 12)
        }
        .trackScrollOffset(isScrolledDown: $isScrolledDown)
        .background(ClusterTheme.Colors.background)
    }

    private var statusBanner: some View {
        HStack(spacing: 10) {
            Image(systemName: totalActive > 0 ? "exclamationmark.triangle.fill" : "checkmark.seal.fill")
                .font(.title3)
                .foregroundStyle(
                    totalActive > 0
                    ? (worstOverall.map(ClusterTheme.Colors.forSymbolType) ?? ClusterTheme.Colors.amber)
                    : ClusterTheme.Colors.green
                )

            VStack(alignment: .leading, spacing: 2) {
                Text(totalActive > 0 ? "\(totalActive) ACTIVE ISSUE\(totalActive == 1 ? "" : "S")" : "ALL SYSTEMS NORMAL")
                    .font(ClusterTheme.Types.mono(12, weight: .bold))
                    .tracking(1.0)
                    .foregroundStyle(ClusterTheme.Colors.textPrimary)

                Text(totalActive > 0 ? "Across \(activeSystemCount) system\(activeSystemCount == 1 ? "" : "s")" : "No warning lights logged")
                    .font(ClusterTheme.Types.body(12))
                    .foregroundStyle(ClusterTheme.Colors.textSecondary)
            }
            Spacer()
        }
        .padding(14)
        .clusterPanel()
        .padding(.horizontal)
    }
}

#Preview {
    ClusterSystemsDashboardView(statuses: [
        SystemStatus(system: .engine, activeCount: 2, worstSeverity: .warning),
        SystemStatus(system: .braking, activeCount: 1, worstSeverity: .advisory),
        SystemStatus(system: .electrical, activeCount: 0, worstSeverity: nil),
        SystemStatus(system: .lighting, activeCount: 0, worstSeverity: nil),
        SystemStatus(system: .driverAssist, activeCount: 1, worstSeverity: .info),
        SystemStatus(system: .tiresSuspension, activeCount: 0, worstSeverity: nil),
        SystemStatus(system: .comfort, activeCount: 0, worstSeverity: nil),
    ], isScrolledDown: .constant(false))
    .preferredColorScheme(.dark)
}

#Preview("All clear") {
    ClusterSystemsDashboardView(
        statuses: VehicleSystem.allCases.map { SystemStatus(system: $0) }, isScrolledDown: .constant(false)
    )
    .preferredColorScheme(.dark)
}
