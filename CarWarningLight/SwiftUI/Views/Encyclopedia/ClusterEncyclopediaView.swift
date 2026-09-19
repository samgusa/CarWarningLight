//
//  ClusterEncyclopediaView.swift
//  CarWarningLight
//
//  Created by Sam Greenhill on 7/26/26.
//  Copyright © 2026 simplyAmazingMachines. All rights reserved.
//

import SwiftUI

struct ClusterEncyclopediaView: View {
    @State private var viewModel = ClusterEncyclopediaViewModel()
    @Environment(\.allLights) private var allLights
    @Binding var isScrolledDown: Bool
    var onLogEntry: (CarSymbol) -> Void = { _ in }

    @Namespace private var namespace
    @Binding var isDetailActive: Bool

    var body: some View {
        ZStack {
            contentView
                .opacity(viewModel.isShowingLarge ? 0 : 1)

            if let index = viewModel.selectedIndex {
                ClusterExpandedView(
                    carSymbol: allLights[index],
                    namespace: namespace,
                    isShowingLarge: $viewModel.isShowingLarge,
                    bigImageId: 999,
                    index: $viewModel.selectedIndex,
                    onLogEntry: { onLogEntry(allLights[index]) }
                )
                .opacity(viewModel.isShowingLarge ? 1 : 0)
                .transition(.opacity)
            }
        }
        .background(ClusterTheme.Colors.background)
        .ignoresSafeArea(edges: viewModel.isShowingLarge ? .top : [])
        .onChange(of: viewModel.isShowingLarge) { _, newValue in
            isDetailActive = newValue
        }
    }

    private var contentView: some View {
        GeometryReader { geometry in
            let columnCount = viewModel.columnCount(for: geometry.size.width)
            let columns = Array(
                repeating: GridItem(.flexible(), spacing: viewModel.gridSpacing),
                count: columnCount
            )
            let cellHeight = viewModel.cellHeight(
                width: geometry.size.width,
                columns: columnCount
            )

            ScrollView {
                LazyVGrid(columns: columns, spacing: viewModel.gridSpacing) {
                    ForEach(Array(allLights.enumerated()), id: \.element.id) { index, light in
                        cellView(for: light, at: index, height: max(130, cellHeight))
                    }
                }
                .padding(.horizontal, viewModel.horizontalPadding)
                .padding(.vertical, viewModel.gridSpacing)
            }
            .scrollIndicators(.hidden)
            .trackScrollOffset(isScrolledDown: $isScrolledDown)
        }
    }

    private func cellView(for light: CarSymbol, at index: Int, height: CGFloat) -> some View {
        ClusterWarningLightCell(
            carData: light,
            index: index,
            namespace: namespace,
            isShowingLarger: $viewModel.isShowingLarge
        )
        .frame(maxWidth: .infinity)
        .frame(height: height)
        .contentShape(Rectangle())
        .onTapGesture {
            guard viewModel.beginSelecting(index: index) else { return }
            withAnimation(.spring(response: 0.4, dampingFraction: 0.9)) {
                viewModel.finishTransition()
            }
        }
    }
}

#Preview {
    ClusterEncyclopediaView(
                            isScrolledDown: .constant(false),
                            isDetailActive: .constant(false)
    )
    .preferredColorScheme(.dark)
}
