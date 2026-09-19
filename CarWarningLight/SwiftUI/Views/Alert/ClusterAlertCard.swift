//
//  ClusterAlertCard.swift
//  CarWarningLight
//
//  Created by Sam Greenhill on 9/6/26.
//  Copyright © 2026 simplyAmazingMachines. All rights reserved.
//

import SwiftUI

struct ClusterAlertCard: View {
    let title: String
    let message: String
    let confirmLabel: String
    let cancelLabel: String
    let isDestructive: Bool
    let onConfirm: () -> Void
    let onCancel: () -> Void

    var body: some View {
        VStack(spacing: 0) {
            VStack(spacing: 8) {
                Text(title.uppercased())
                    .font(ClusterTheme.Fonts.mono(13, weight: .bold))
                    .tracking(0.8)
                    .foregroundStyle(ClusterTheme.Colors.textPrimary)
                    .multilineTextAlignment(.center)
                Text(message)
                    .font(ClusterTheme.Fonts.body(13))
                    .foregroundStyle(ClusterTheme.Colors.textSecondary)
                    .multilineTextAlignment(.center)
            }
            .padding(20)

            Rectangle()
                .fill(ClusterTheme.Colors.bezel)
                .frame(height: 1)

            HStack(spacing: 1) {
                Button(action: onCancel) {
                    Text(cancelLabel.uppercased())
                        .font(ClusterTheme.Fonts.mono(12, weight: .bold))
                        .foregroundStyle(ClusterTheme.Colors.textSecondary)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 14)
                }
                Rectangle()
                    .fill(ClusterTheme.Colors.bezel)
                    .frame(width: 1, height: 44)
                Button(action: onConfirm) {
                    Text(confirmLabel.uppercased())
                        .font(ClusterTheme.Fonts.mono(12, weight: .bold))
                        .foregroundStyle(isDestructive ? ClusterTheme.Colors.red : ClusterTheme.Colors.amber)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 14)
                }
            }
        }
        .frame(width: 300)
        .background(ClusterTheme.Colors.panel)
        .clipShape(ClusterCornerCutShape(cut: 14))
        .overlay(
            ClusterCornerCutShape(cut: 14)
                .stroke(ClusterTheme.Colors.bezel, lineWidth: 1)
        )
    }
}

#Preview {
    ClusterAlertCard(title: "Title", message: "Not sure what to say", confirmLabel: "Confirm", cancelLabel: "Cancel", isDestructive: false, onConfirm: { } , onCancel: {})
}
