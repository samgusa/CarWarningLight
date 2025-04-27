//
//  WarningLightView.swift
//  CarWarningLight
//
//  Created by Sam Greenhill on 4/23/25.
//  Copyright © 2025 simplyAmazingMachines. All rights reserved.
//

import SwiftUI

struct WarningLightView: View {
    @StateObject var viewModel = MainViewModel2()
    let desiredCellAspectRatio: CGFloat = 1.5 
    let spacing: CGFloat = 16
    let minimumCellWidth: CGFloat = 100

    @Namespace var namespace

    var backgroundColor: Color {
        viewModel.isPressed ? Color(.systemBackground) : Color(.systemGray4)
    }

    var body: some View {
        ZStack {
            GeometryReader { geometry in
                let availableWidth = geometry.size.width - (spacing * 2)

                let possibleColumns = Int((availableWidth + spacing) / (minimumCellWidth + spacing))
                let actualColumns = max(1, possibleColumns)

                let cellWidth = (availableWidth - (CGFloat(actualColumns - 1) * spacing)) / CGFloat(actualColumns)
                let cellHeight = cellWidth * desiredCellAspectRatio // Calculate height based on the new aspect ratio

                let gridItem = GridItem(.fixed(cellWidth), spacing: spacing)
                let columns = Array(repeating: gridItem, count: actualColumns)

                ScrollView {
                    LazyVGrid(columns: columns, spacing: spacing) {
                        ForEach(viewModel.bundleLight, id: \.id) { carLight in
                            WarningLightCell(
                                carData: carLight,
                                namespace: namespace)
                            .frame(height: cellHeight) // Set the dynamic height based on the new aspect ratio
                            .onTapGesture {
                                withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
                                    viewModel.selectSymbol(carLight)
                                }
                            }
                        }
                    }
                    .padding(spacing)
                }
                .opacity(viewModel.isPressed ? 0 : 1)

                if viewModel.isPressed {
                    ExpandedView(
                        carSymbol: viewModel.symbolPressed,
                        namespace: namespace,
                        isPressed: $viewModel.isPressed
                    )
                    .edgesIgnoringSafeArea(.all)
                }
            }
        }
        .background(backgroundColor)
    }
}

#Preview {
    ContentView()
}
