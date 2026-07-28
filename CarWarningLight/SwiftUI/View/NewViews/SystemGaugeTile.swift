//
//  SystemGaugeTile.swift
//  CarWarningLight
//
//  Created by Sam Greenhill on 7/26/26.
//  Copyright © 2026 simplyAmazingMachines. All rights reserved.
//

import SwiftUI

struct SystemGaugeTile: View {
    let status: SystemStatus
    @State private var pulse: Bool = false

    private var fillAmount: CGFloat { min(1, CGFloat(status.activeCount) / 3.0) }

    var body: some View {
        VStack(spacing: 10) {
            ZStack {
                Circle()
                    .trim(from: 0.12, to: 0.88)
                    .stroke(ClusterTheme.Colors.bezel, style: StrokeStyle(lineWidth: 5, lineCap: .round))
                    .rotationEffect(.degrees(90))

                if status.isActive {
                    Circle()
                        .trim(from: 0.12, to: 0.12 + 0.76 * fillAmount)
                        .stroke(status.statusColor, style: StrokeStyle(lineWidth: 5, lineCap: .round))
                        .rotationEffect(.degrees(90))
                }

                Circle()
                    .fill(status.statusColor)
                    .frame(width: 26, height: 26)
                    .blur(radius: 9)
                    .opacity(status.isActive ? (pulse ? 0.75 : 0.35) : 0.12)

                Image(systemName: status.system.icon)
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundStyle(status.isActive ? status.statusColor : ClusterTheme.Colors.textSecondary)
            }
            .frame(width: 64, height: 64)

            VStack(spacing: 2) {
                Text(status.system.shortLabel)
                    .font(ClusterTheme.Types.mono(10, weight: .bold))
                    .tracking(0.8)
                    .foregroundStyle(ClusterTheme.Colors.textPrimary)
                    .lineLimit(1)
                    .minimumScaleFactor(0.8)

                Text(status.isActive ? "\(status.activeCount) ACTIVE" : "CLEAR")
                    .font(ClusterTheme.Types.mono(9, weight: .semibold))
                    .foregroundStyle(status.isActive ? status.statusColor : ClusterTheme.Colors.textSecondary.opacity(0.7))
            }
        }
        .padding(.vertical, 16)
        .frame(maxWidth: .infinity)
        .clusterPanel()
        .onAppear {
            guard status.isActive else { return }
            withAnimation(.easeInOut(duration: 1.4).repeatForever(autoreverses: true)) {
                pulse = true
            }
        }
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
    ])
    .preferredColorScheme(.dark)
}

#Preview("All clear") {
    ClusterSystemsDashboardView(
        statuses: VehicleSystem.allCases.map { SystemStatus(system: $0) }
    )
    .preferredColorScheme(.dark)
}
