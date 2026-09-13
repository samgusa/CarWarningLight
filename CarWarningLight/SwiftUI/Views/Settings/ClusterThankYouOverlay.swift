//
//  ClusterThankYouOverlay.swift
//  CarWarningLight
//
//  Created by Sam Greenhill on 9/7/26.
//  Copyright © 2026 simplyAmazingMachines. All rights reserved.
//

import SwiftUI

struct ClusterThankYouOverlay: View {
    var onDismiss: () -> Void
    @State private var startAnimation: Bool = false

    var body: some View {
        ZStack {
            Color.black.opacity(0.75)
                .ignoresSafeArea()
                .onTapGesture { onDismiss() }

            VStack(spacing: 14) {
                Image(systemName: "heart.fill")
                    .font(.system(size: 34, weight: .bold))
                    .foregroundStyle(ClusterTheme.Colors.amber)

                Text("THANK YOU")
                    .font(ClusterTheme.Fonts.display(22))
                    .foregroundStyle(ClusterTheme.Colors.textPrimary)

                Text("Your support means a lot — it goes straight back into building this app.")
                    .font(ClusterTheme.Fonts.body(13))
                    .foregroundStyle(ClusterTheme.Colors.textSecondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 30)

                Button(action: onDismiss) {
                    Text("CLOSE")
                        .font(ClusterTheme.Fonts.mono(12, weight: .bold))
                        .tracking(0.8)
                        .foregroundStyle(ClusterTheme.Colors.background)
                        .padding(.horizontal, 24)
                        .padding(.vertical, 12)
                        .background(ClusterTheme.Colors.amber)
                        .clipShape(Capsule())
                }
                .padding(.top, 6)
            }
            .padding(28)
            .frame(width: 300)
            .background(ClusterTheme.Colors.panel)
            .clipShape(ClusterCornerCutShape(cut: 16))
            .overlay(
                ClusterCornerCutShape(cut: 16)
                    .stroke(ClusterTheme.Colors.bezel, lineWidth: 1)
            )

            ConfettiView(isAnimating: $startAnimation)
                .allowsHitTesting(false)
                .ignoresSafeArea()
        }
        .transition(.opacity.combined(with: .scale(scale: 0.92)))
        .onAppear {
            startAnimation = true
            DispatchQueue.main
                .asyncAfter(deadline: .now() + 3.5) {
                    startAnimation = false
                }
        } 
    }
}

#Preview {
    ClusterThankYouOverlay(onDismiss: {})
}
