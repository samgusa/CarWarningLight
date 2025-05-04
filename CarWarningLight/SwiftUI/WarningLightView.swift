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
         Color(.systemGray4)
    }

    var body: some View {
        GeometryReader { geometry in
            NavigationStack {
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
                            NavigationLink(value: carLight) {
                                WarningLightCell(
                                    carData: carLight
                                )
                                .matchedTransitionSource(id: carLight.id, in: namespace) {
                                    $0
                                        .background(.clear)
                                        .clipShape(.rect(cornerRadius: 15))
                                }
                                .frame(height: cellHeight)
                            }
                            .buttonStyle(CustomButtonStyleNoBorder())

                        }
                    }
                    .padding(spacing)
                }
                .navigationDestination(for: CarSymbol.self) { carSymbol in
                    ExpandedView(
                        carSymbol: carSymbol,
                        namespace: namespace
                    )
                    .toolbarVisibility(.hidden, for: .navigationBar)
                }
                .background(backgroundColor)
            }
        }
    }
}

#Preview {
    ContentView()
        .environmentObject(UIStateManager())
}
