//
//  ClusterEncyclopediaViewModel.swift
//  CarWarningLight
//
//  Created by Sam Greenhill on 8/31/26.
//  Copyright © 2026 simplyAmazingMachines. All rights reserved.
//
import Foundation

@Observable
final class ClusterEncyclopediaViewModel {
    var selectedIndex: Int?
    var isShowingLarge: Bool = false
    var isTransitioning: Bool = false

    let horizontalPadding: CGFloat                  = 16
    let gridSpacing: CGFloat                        = 15
    let minimumCellWidth: CGFloat           = 100
    let desiredCellAspectRatio: CGFloat     = 1.0

    @discardableResult
    func beginSelecting(index: Int) -> Bool {
        guard selectedIndex == nil, !isShowingLarge, !isTransitioning else { return false }
        isTransitioning = true
        selectedIndex   = index
        return true
    }

    func finishTransition() {
        isShowingLarge = true
        isTransitioning = false
    }

    func columnCount(for width: CGFloat) -> Int {
        let availableWidth = width - (horizontalPadding * 2)
        let possibleColumns = Int((availableWidth + gridSpacing) / (minimumCellWidth + gridSpacing))
        return max(2, possibleColumns)
    }

    func cellHeight(width: CGFloat, columns: Int) -> CGFloat {
        cellWidth(for: width, columns: columns) * desiredCellAspectRatio
    }

    private func cellWidth(for width: CGFloat, columns: Int) -> CGFloat {
        let availableWidth = width - (horizontalPadding * 2)
        return (availableWidth - (gridSpacing * CGFloat(columns - 1))) / CGFloat(columns)
    }
}
