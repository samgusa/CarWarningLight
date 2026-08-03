//
//  testView.swift
//  CarWarningLight
//
//  Created by Sam Greenhill on 8/2/26.
//  Copyright © 2026 simplyAmazingMachines. All rights reserved.
//

import SwiftUI

struct testView: View {
    var body: some View {
        ZStack {
            Color.red
                .ignoresSafeArea()

            // Your main content (the blue card)
            RoundedRectangle(cornerRadius: 20)
                .foregroundStyle(.blue)
                .ignoresSafeArea(edges: .bottom) // Ensures the blue goes to the bottom edge
                .safeAreaInset(edge: .top, spacing: 0) {
                    // This bar automatically sits exactly below the safe area line,
                    // but its background will bleed upward into the safe area.
                    Color.green
                        .frame(height: 50)
                        .background(Color.green.ignoresSafeArea(edges: .top))
                }
        }
    }
}

#Preview {
    testView()
}
