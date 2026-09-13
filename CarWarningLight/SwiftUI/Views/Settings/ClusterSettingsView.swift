//
//  ClusterSettingsView.swift
//  CarWarningLight
//
//  Created by Sam Greenhill on 9/6/26.
//  Copyright © 2026 simplyAmazingMachines. All rights reserved.
//

import SwiftUI
import StoreKit

struct ClusterSettingsView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(TipJarStore.self) private var tipStore

    var body: some View {
        VStack(spacing: 0) {
            ClusterHeaderBar(title: "Settings")
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    VStack(alignment: .leading, spacing: 10) {
                        Text("SUPPORT THE APP")
                            .font(ClusterTheme.Fonts.mono(11, weight: .bold))
                            .tracking(1.2)
                            .foregroundStyle(ClusterTheme.Colors.textSecondary)
                        Text("This app has no ads and never will. If it's been useful, you can leave a tip — completely optional, nothing is unlocked or changed either way.")
                            .font(ClusterTheme.Fonts.body(12))
                            .foregroundStyle(ClusterTheme.Colors.textSecondary)

                        ForEach(tipStore.products) { product in
                            tipRow(product)
                        }

                        if tipStore.hasEverTipped {
                            sayThanksRow
                        }
                    }
                    .padding(.horizontal)
                }
                .padding(.top, 16)
                .padding(.bottom, 24)
            }

        }
        .background(ClusterTheme.Colors.background)
        .task { await tipStore.loadProducts() }
        .overlay {
            if tipStore.showCelebration {
                ClusterThankYouOverlay {
                    withAnimation(.easeInOut(duration: 0.3)) {
                        tipStore.showCelebration = false
                    }
                }
            }
        }
    }

    private var sayThanksRow: some View {
        Button {
            tipStore.showCelebration = true
        } label: {
            HStack(spacing: 8) {
                Image(systemName: "heart.fill")
                    .font(.system(size: 12, weight: .bold))
                Text("YOU'VE SUPPORTED THIS APP — TAP TO SEE IT AGAIN")
                    .font(ClusterTheme.Fonts.mono(10, weight: .bold))
                    .tracking(0.4)
            }
            .foregroundStyle(ClusterTheme.Colors.amber)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 10)
        }
        .buttonStyle(.plain)
    }

    private func tipRow(_ product: Product) -> some View {
        Button {
            Task { await tipStore.purchase(product) }
        } label: {
            HStack {
                Text(product.displayName)
                    .font(ClusterTheme.Fonts.body(14, weight: .semibold))
                    .foregroundStyle(ClusterTheme.Colors.textPrimary)
                Spacer()
                Text(product.displayPrice)
                    .font(ClusterTheme.Fonts.mono(13, weight: .bold))
                    .foregroundStyle(ClusterTheme.Colors.amber)
            }
            .padding(14)
            .clusterPanel()
        }
        .buttonStyle(PressedButtonStyle())
    }
}

#Preview {
    ClusterSettingsView()
        .environment(TipJarStore())
}
