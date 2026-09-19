//
//  ClusterGaugeLoader.swift
//  CarWarningLight
//
//  Created by Sam Greenhill on 7/25/26.
//  Copyright © 2026 simplyAmazingMachines. All rights reserved.
//

import SwiftUI

struct ClusterGaugeLoader: View {
    var color: Color = ClusterTheme.Colors.amber
    var size: CGFloat = 24

    @State private var sweeping: Bool = false

    var body: some View {
        ZStack {
            Circle()
                .stroke(ClusterTheme.Colors.bezel, lineWidth: 3)

            Circle()
                .trim(from: 0, to: sweeping ? 0.82 : 0.12)
                .stroke(color, style: StrokeStyle(lineWidth: 3, lineCap: .round))
                .rotationEffect(.degrees(-90))
        }
        .frame(width: size, height: size)
        .onAppear {
            withAnimation(.easeInOut(duration: 0.9).repeatForever(autoreverses: true)) {
                sweeping = true
            }
        }
    }
}

#Preview {
    VStack(spacing: 24) {
        ClusterGaugeLoader(color: ClusterTheme.Colors.amber, size: 50)
        ClusterGaugeLoader(color: ClusterTheme.Colors.red, size: 50)
        ClusterGaugeLoader(color: ClusterTheme.Colors.green, size: 50)
    }
    .padding(40)
    .background(ClusterTheme.Colors.background)
}
