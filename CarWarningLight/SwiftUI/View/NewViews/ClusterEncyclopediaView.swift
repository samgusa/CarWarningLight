//
//  ClusterEncyclopediaView.swift
//  CarWarningLight
//
//  Created by Sam Greenhill on 7/26/26.
//  Copyright © 2026 simplyAmazingMachines. All rights reserved.
//

import SwiftUI

struct ClusterEncyclopediaView: View {
    let allLights: [CarSymbol]
    @Binding var isScrolledDown: Bool

    @Namespace private var namespace
    @State private var selectedIndex: Int?
    @State private var isShowingLarge: Bool         = false
    @State private var isTransitioning: Bool        = false

    private let horizontalPadding: CGFloat          = 16
    private let gridSpacing: CGFloat                = 15
    private let minimumCellWidth: CGFloat           = 100
    private let desiredCellAspectRatio: CGFloat     = 1.35

    var body: some View {
        ZStack {
            contentView
                .opacity(isShowingLarge ? 0 : 1)

            if let index = selectedIndex {
                ClusterExpandedView(
                    carSymbol: allLights[index],
                    namespace: namespace,
                    isShowingLarge: $isShowingLarge,
                    bigImageId: 999,
                    index: $selectedIndex
                )
                .opacity(isShowingLarge ? 1 : 0)
                .transition(.opacity)
            }
        }
        .background(ClusterTheme.Colors.background)
    }

    private var contentView: some View {
        GeometryReader { geometry in
            let columns = calculateColumns(for: geometry.size.width)
            let cellHeight = calculateCellHeight(width: geometry.size.width, columns: columns.count)

            ScrollView {
                LazyVGrid(columns: columns, spacing: gridSpacing) {
                    ForEach(Array(allLights.enumerated()), id: \.element.id) { index, light in
                        cellView(for: light, at: index, height: max(130, cellHeight))
                    }
                }
                .padding(.horizontal, horizontalPadding)
                .padding(.vertical, gridSpacing)
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
            isShowingLarger: $isShowingLarge
        )
        .frame(maxWidth: .infinity)
        .frame(height: height)
        .contentShape(Rectangle())
        .onTapGesture {
            guard selectedIndex == nil, !isShowingLarge, !isTransitioning else { return }
            isTransitioning = true
            selectedIndex = index
            withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
                isShowingLarge = true
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.7) { isTransitioning = false }
        }
    }

    private func calculateColumns(for width: CGFloat) -> [GridItem] {
        let availableWidth = width - (horizontalPadding * 2)
        let possibleColumns = Int((availableWidth + gridSpacing) / (minimumCellWidth + gridSpacing))
        let actualColumns = max(2, possibleColumns)
        return Array(repeating: GridItem(.flexible(), spacing: gridSpacing), count: actualColumns)
    }

    private func calculateCellWidth(for width: CGFloat, columns: Int) -> CGFloat {
        let availableWidth = width - (horizontalPadding * 2)
        return (availableWidth - (gridSpacing * CGFloat(columns - 1))) / CGFloat(columns)
    }

    private func calculateCellHeight(width: CGFloat, columns: Int) -> CGFloat {
        calculateCellWidth(for: width, columns: columns) * desiredCellAspectRatio
    }
}

#Preview {
    ClusterEncyclopediaView(allLights: [
            CarSymbol(id: 1, name: "Check Engine Light", imageName: "Check Engine Light", description: "Sample description.", symbolType: .warning, fixDescription: "Sample fix.", drivable: .no, categories: nil),
            CarSymbol(id: 2, name: "Battery Charging Light", imageName: "Battery Charging Light", description: "Sample description.", symbolType: .warning, fixDescription: "Sample fix.", drivable: .uncertain, categories: nil),
            CarSymbol(id: 3, name: "Tire Pressure Warning Light", imageName: "Tire Pressure Warning Light", description: "Sample description.", symbolType: .advisory, fixDescription: "Sample fix.", drivable: .yes, categories: nil),
            CarSymbol(id: 4, name: "Child Safety Lock", imageName: "Child Safety Lock", description: "Sample description.", symbolType: .info, fixDescription: "Sample fix.", drivable: .yes, categories: nil),
            CarSymbol(id: 5, name: "Adaptive Front Lighting System", imageName: "Adaptive Front Lighting System", description: "Sample description.", symbolType: .advisory, fixDescription: "Sample fix.", drivable: .yes, categories: nil),
            CarSymbol(id: 6, name: "Traction Control Light", imageName: "Traction Control Light", description: "Sample description.", symbolType: .advisory, fixDescription: "Sample fix.", drivable: .yes, categories: nil),
    ], isScrolledDown: .constant(false))
    .preferredColorScheme(.dark)
}
