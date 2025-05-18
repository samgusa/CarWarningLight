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
            let columns = calculateColumns(for: geometry.size.width)
            let columnCount = columns.count
            let cellHeight = calculateCellHeight(
                width: geometry.size.width,
                columns: columnCount
            )

            ScrollView {
                LazyVGrid(columns: columns, spacing: viewModel.gridSpacing) {
                    ForEach(Array(viewModel.allLights.enumerated()), id: \.element.id) { index, light in
                        cellView(for: light, at: index, height: max(50, cellHeight))
                    }
                }
                .padding(.horizontal, viewModel.horizontalPadding)
                .padding(.vertical, viewModel.gridSpacing)
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

            guard viewModel.shouldAllowTransition() else { return }

            guard viewModel.selectedIndex == nil && !viewModel.isShowingLarge else { return }

            viewModel.selectedIndex = index
            withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
                viewModel.isShowingLarge = true
            }

            // Reset the flag after transition completes
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.7) {
                viewModel.isTransitioning = false
            }
        }
    }

    // Grid calculation methods
    func calculateColumns(for width: CGFloat) -> [GridItem] {
        let availableWidth = width - (viewModel.horizontalPadding * 2)
        let possibleColumns = Int((availableWidth + viewModel.gridSpacing) / (viewModel.minimumCellWidth + viewModel.gridSpacing))
        let actualColumns = max(2, possibleColumns)

        return Array(repeating: GridItem(.flexible(), spacing: viewModel.gridSpacing), count: actualColumns)
    }

    func calculateCellWidth(for width: CGFloat, columns: Int) -> CGFloat {
        let availableWidth = width - (viewModel.horizontalPadding * 2)
        return (availableWidth - (viewModel.gridSpacing * CGFloat(columns - 1))) / CGFloat(columns)
    }
    
    func calculateCellHeight(width: CGFloat, columns: Int) -> CGFloat {
        let cellWidth = calculateCellWidth(for: width, columns: columns)
        return cellWidth * viewModel.desiredCellAspectRatio
    }
}

#Preview {
    ContentView()
        .environmentObject(UIStateManager())
}
