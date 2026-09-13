//
//  ClusterHeaderBar.swift
//  CarWarningLight
//
//  Created by Sam Greenhill on 8/1/26.
//  Copyright © 2026 simplyAmazingMachines. All rights reserved.
//

import SwiftUI

struct ClusterHeaderBar: View {
    let title: String
    var icon: String            = "xmark"
    var onClose: (() -> Void)?  = nil

    var body: some View {
        HStack {
            Text(title.uppercased())
                .font(ClusterTheme.Fonts.mono(12, weight: .bold))
                .tracking(1.5)
                .foregroundStyle(ClusterTheme.Colors.textSecondary)
            Spacer()
            if let onClose {
                Button(action: onClose) {
                    Image(systemName: icon)
                        .font(.system(size: 13, weight: .bold))
                        .foregroundStyle(ClusterTheme.Colors.textPrimary)
                        .frame(width: 28, height: 28)
                        .background(ClusterTheme.Colors.panel)
                        .overlay(
                            RoundedRectangle(cornerRadius: 6)
                                .stroke(ClusterTheme.Colors.bezel, lineWidth: 1)
                        )
                        .clipShape(RoundedRectangle(cornerRadius: 6))
                }
                .accessibilityLabel(icon == "xmark" ? "Close" : "Back")
            }
        }
        .padding()
        .background(ClusterTheme.Colors.panel)
    }
}

#Preview {
    ClusterHeaderBar(title: "Scan") {  }
}
