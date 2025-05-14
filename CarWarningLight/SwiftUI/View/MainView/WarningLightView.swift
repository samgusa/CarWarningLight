//
//  WarningLightView.swift
//  CarWarningLight
//
//  Created by Sam Greenhill on 4/23/25.
//  Copyright © 2025 simplyAmazingMachines. All rights reserved.
//

import SwiftUI

struct WarningLightView: View {
    @StateObject var viewModel = MainViewModel()
    @Namespace var namespace

    private let desiredCellAspectRatio: CGFloat = 1.5
    private let gridSpacing: CGFloat = 16
    private let minimumCellWidth: CGFloat = 100
    private let horizontalPadding: CGFloat = 16

    var backgroundColor: Color {
        viewModel.isShowingLarge ? Color(.systemBackground) : Color(.systemGray6)
    }

    var body: some View {
        NavigationStack {
            ZStack {
                contentView
                    .opacity(viewModel.isShowingLarge ? 0 : 1)

                if let index = viewModel.selectedIndex {
                    ExpandedView(
                        carSymbol: viewModel.allLights[index],
                        namespace: namespace,
                        isShowingLarge: $viewModel.isShowingLarge,
                        bigImageId: viewModel.bigImageId,
                        index: $viewModel.selectedIndex
                    )
                    .opacity(viewModel.isShowingLarge ? 1 : 0)
                    .transition(.opacity)
                }
            }
        }
    }

    private var contentView: some View {
        GeometryReader { geometry in

            let availableWidth = geometry.size.width - (horizontalPadding * 2)
            let columns = calculateColumns(for: availableWidth)
            let cellWidth = calculateCellWidth(for: availableWidth, columns: columns)
            let cellHeight = cellWidth * desiredCellAspectRatio

            ScrollView {
                LazyVGrid(columns: columns, spacing: gridSpacing) {
                    ForEach(Array(viewModel.allLights.enumerated()), id: \.element.id) { index, light in
                        cellView(for: light, at: index, height: max(50, cellHeight))
                    }
                }
                .padding(.horizontal, horizontalPadding)
                .padding(.vertical, gridSpacing)
                .animation(.easeInOut, value: viewModel.allLights.count)
            }
            .scrollIndicators(.hidden)
        }
    }

    private func cellView(for light: CarSymbol, at index: Int, height: CGFloat) -> some View {
        WarningLightCell(
            carData: light,
            index: index,
            namespace: namespace,
            isShowingLarge: $viewModel.isShowingLarge
        )
        .frame(height: height)
        .contentShape(Rectangle())
        .onTapGesture {
            viewModel.selectedIndex = index
            withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
                viewModel.isShowingLarge = true
            }
        }
    }

    private func calculateColumns(for width: CGFloat) -> [GridItem] {
        let possibleColumns = Int((width + gridSpacing) / (minimumCellWidth + gridSpacing))
        let actualColumns = max(2, possibleColumns)

        return Array(repeating: GridItem(.flexible(), spacing: gridSpacing), count: actualColumns)
    }

    private func calculateCellWidth(for width: CGFloat, columns: [GridItem]) -> CGFloat {
        let columnCount = columns.count
        return (width - (gridSpacing * CGFloat(columnCount - 1))) / CGFloat(columnCount)
    }
}

#Preview {
    ContentView()
        .environmentObject(UIStateManager())
}

/*
 NavigationStack  {
     ZStack {
         GeometryReader { geometry in
             let availableWidth = geometry.size.width - (gridSpacing * 2)

             let possibleColumns = Int((availableWidth + gridSpacing) / (minimumCellWidth + gridSpacing))
             let actualColumns = max(1, possibleColumns)

             let cellWidth = (availableWidth - (CGFloat(actualColumns - 1) * gridSpacing)) / CGFloat(actualColumns)
             let cellHeight = cellWidth * desiredCellAspectRatio // Calculate height based on the new aspect ratio

             let gridItem = GridItem(.fixed(cellWidth), spacing: gridSpacing)
             let columns = Array(repeating: gridItem, count: actualColumns)

             ScrollView {
                 LazyVGrid(columns: columns, spacing: gridSpacing) {
                     ForEach(Array(viewModel.bundleLight.enumerated()), id: \.offset) { index, carLight in
                         Color.clear
                             .aspectRatio(0.7, contentMode: .fit)
                             .overlay {
                                 WarningLightCell(
                                     carData: carLight,
                                     index: index,
                                     namespace: namespace,
                                     isShowingLarge: $viewModel.isShowingLarge)
                             }
                             .clipped()
                             .contentShape(Rectangle())
                         .onTapGesture {
                             viewModel.selectedIndex = index
                             withAnimation(.easeInOut(duration: 0.5)) {
                                 viewModel.isShowingLarge = true
                             }
                         }
                         .frame(height: cellHeight)
                     }
                 }
             }
             .opacity(viewModel.isShowingLarge ? 0 : 1)
             .background(backgroundColor)
         }

         if let index = viewModel.selectedIndex {
             ExpandedView(
                 carSymbol: viewModel.bundleLight[index],
                 namespace: namespace,
                 isShowingLarge: $viewModel.isShowingLarge,
                 bigImageId: viewModel.bigImageId,
                 index: $viewModel.selectedIndex
             )
             .opacity(viewModel.isShowingLarge ? 1 : 0)
         }
     }
 }
 */
