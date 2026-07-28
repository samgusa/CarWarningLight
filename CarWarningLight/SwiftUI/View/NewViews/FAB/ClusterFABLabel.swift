//
//  ClusterFABLabel.swift
//  CarWarningLight
//
//  Created by Sam Greenhill on 7/26/26.
//  Copyright © 2026 simplyAmazingMachines. All rights reserved.
//

import SwiftUI

struct ClusterFABLabel: View {
    let isExpanded: Bool

    var body: some View {
        Image(systemName: "plus")
            .font(.system(size: 18, weight: .bold))
            .foregroundStyle(ClusterTheme.Colors.textPrimary)
            .rotationEffect(.degrees(isExpanded ? 45 : 0))
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(ClusterTheme.Colors.panel)
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(isExpanded ? ClusterTheme.Colors.amber : ClusterTheme.Colors.bezel, lineWidth: 1.5)
            )
            .clipShape(RoundedRectangle(cornerRadius: 16))
            .shadow(color: .black.opacity(0.4), radius: 10, y: 4)
    }
}

#Preview {
    struct PreviewHost: View {
        @State var expanded = false
        var body: some View {
            ZStack(alignment: .bottomTrailing) {
                ClusterTheme.Colors.background.ignoresSafeArea()

                ClusterFloatingButtonView {
                    FloatingAction(symbol: "photo.fill", background: ClusterTheme.Colors.green) { }
                    FloatingAction(symbol: "camera.fill", background: ClusterTheme.Colors.amber) { }
                } label: { isExpanded in
                    ClusterFABLabel(isExpanded: isExpanded)
                }
                .padding(24)
            }
        }
    }
    return PreviewHost()
}
