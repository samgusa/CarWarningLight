//
//  WarningLightCell.swift
//  CarWarningLight
//
//  Created by Sam Greenhill on 4/24/25.
//  Copyright © 2025 simplyAmazingMachines. All rights reserved.
//

import SwiftUI

struct WarningLightCell: View {
    let carData: CarSymbol
    let index: Int
    var namespace: Namespace.ID
    @Binding var isShowingLarge: Bool
    
    var body: some View {
        cellContent
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .modifier(CardStyle())
    }

    private var cellContent: some View {
        VStack(spacing: 12) {
            symbolImage
            titleText
        }
        .padding(.vertical, 8)
    }

    private var symbolImage: some View {
        Image(carData.imageName)
            .resizable()
            .renderingMode(.template)
            .matchedGeometryEffect(
                id: "\(index) logo",
                in: namespace,
                isSource: true
            )
            .foregroundStyle(carData.symbolType.color)
            .scaledToFit()
            .frame(height: 56)
            .padding(.top, 8)
            .padding(.horizontal, 10)
            .accessibilityHidden(true)
    }

    private var titleText: some View {
        Text(carData.name)
            .font(.system(size: 14, weight: .semibold))
            .multilineTextAlignment(.center)
            .lineLimit(2)
            .truncationMode(.tail)
            .frame(height: 36)
            .padding(.horizontal, 8)
            .accessibilityHidden(true)
    }
}

#Preview {
    ContentView()
        .environmentObject(UIStateManager())
}
