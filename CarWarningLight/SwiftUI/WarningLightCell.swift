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

    var body: some View {
        VStack(spacing: 12) {
            Image(carData.imageName)
                .resizable()
                .renderingMode(.template)
                .foregroundStyle(carData.symbolType.color)
                .scaledToFit()
                .padding(10)

            Text(carData.name)
                .font(.system(size: 12, weight: .semibold))
                .multilineTextAlignment(.center)
                .lineLimit(2)
                .truncationMode(.tail)
                .frame(height: 32)
                .padding(.horizontal, 5)
                .padding(.bottom, 8)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.1), radius: 3)
    }
}

#Preview {
    ContentView()
        .environmentObject(UIStateManager())
}
