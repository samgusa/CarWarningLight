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

    let bigImageId: Int = -1
    @State private var selectedIndex: Int? = nil
    @State private var isShowingLarge = false

    var backgroundColor: Color {
         Color(.systemGray4)
    }

    var body: some View {
        NavigationStack  {
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
                            ForEach(Array(viewModel.bundleLight.enumerated()), id: \.offset) { index, carLight in
                                WarningLightCell(
                                    carData: carLight,
                                    index: index,
                                    namespace: namespace)
                                .matchedGeometryEffect(
                                    id: index,
                                    in: namespace,
                                    isSource: true
                                )
                                .onTapGesture {
                                    selectedIndex = index
                                    withAnimation(.easeInOut) {
                                        isShowingLarge = true
                                    }
                                }
                                .frame(height: cellHeight)
                            }
                        }
                        .padding(spacing)
                    }
                    .opacity(isShowingLarge ? 0 : 1)
                    .background(backgroundColor)
                }

                if let index = selectedIndex {
                    ExpandedView(
                        carSymbol: viewModel.bundleLight[index],
                        namespace: namespace,
                        isShowingLarge: $isShowingLarge,
                        bigImageId: bigImageId,
                        index: $selectedIndex
                    )
                    .matchedGeometryEffect(
                        id: isShowingLarge ? bigImageId : index,
                        in: namespace,
                        isSource: false
                    )
                    .opacity(isShowingLarge ? 1 : 0)
                }
            }
        }
    }
}

#Preview {
    ContentView()
        .environmentObject(UIStateManager())
}
