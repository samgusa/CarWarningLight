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
            let columns = viewModel.calculateColumns(for: geometry.size.width)
            let columnCount = columns.count
            let cellHeight = viewModel.calculateCellHeight(
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
            viewModel.selectedIndex = index
            withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
                viewModel.isShowingLarge = true
            }
        }
    }
}

#Preview {
    ContentView()
        .environmentObject(UIStateManager())
}
