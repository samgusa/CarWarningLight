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
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color(.systemBackground))
                    .shadow(
                        color: Color.black.opacity(0.1),
                        radius: 4,
                        x: 0,
                        y: 2
                    )
            )
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

/*

 var body: some View {
     RoundedRectangle(cornerRadius: 25)
         .foregroundStyle(Color.clear)
         .overlay {
             VStack(spacing: 12) {
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
         }
         .frame(maxWidth: .infinity, maxHeight: .infinity)
         .background(Color(.systemBackground))
         .cornerRadius(12)
         .shadow(color: Color.black.opacity(0.1), radius: 3)
         .opacity(isShowingLarge ? 0 : 1)
 }
 */
