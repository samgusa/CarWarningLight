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
    let allLights: [CarSymbol]
    @Binding var isScrolledDown: Bool
    let logEntries: [LightLogEntry]
    let selectedVehicleID: UUID
    var onLogEntry: (CarSymbol) -> Void = { _ in }
    var onToggleResolved: (LightLogEntry) -> Void = { _ in }

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
                    logEntry: viewModel
                        .entry(
                            for: allLights[index],
                            in: logEntries,
                            vehicleID: selectedVehicleID
                        ),
                    onToggleResolved: {
                        if let match = viewModel
                            .entry(
                                for: allLights[index],
                                in: logEntries,
                                vehicleID: selectedVehicleID
                            ) {
                            onToggleResolved(match)
                        }
                    },
                    onLogEntry: {
                        onLogEntry(allLights[index])
                    }
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
            let columns = calculateColumns(for: geometry.size.width)
            let cellHeight = calculateCellHeight(width: geometry.size.width, columns: columns.count)

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

    private func calculateColumns(for width: CGFloat) -> [GridItem] {
        let availableWidth = width - (viewModel.horizontalPadding * 2)
        let possibleColumns = Int((availableWidth + viewModel.gridSpacing) / (viewModel.minimumCellWidth + viewModel.gridSpacing))
        let actualColumns = max(2, possibleColumns)
        return Array(repeating: GridItem(.flexible(), spacing: viewModel.gridSpacing), count: actualColumns)
    }

    private func calculateCellWidth(for width: CGFloat, columns: Int) -> CGFloat {
        let availableWidth = width - (viewModel.horizontalPadding * 2)
        return (availableWidth - (viewModel.gridSpacing * CGFloat(columns - 1))) / CGFloat(columns)
    }

    private func calculateCellHeight(width: CGFloat, columns: Int) -> CGFloat {
        calculateCellWidth(for: width, columns: columns) * viewModel.desiredCellAspectRatio
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
    ],
                            isScrolledDown: .constant(false),
                            logEntries: [],
                            selectedVehicleID: UUID(),
                            isDetailActive: .constant(false))
    .preferredColorScheme(.dark)
}
