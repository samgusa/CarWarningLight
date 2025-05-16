//
//  MainViewModel2.swift
//  CarWarningLight
//
//  Created by Sam Greenhill on 4/27/25.
//  Copyright © 2025 simplyAmazingMachines. All rights reserved.
//

import Foundation
import SwiftUI

class MainViewModel: ObservableObject {
    // All car warning lights loaded from json
    let allLights: [CarSymbol] = Bundle.main.decode([CarSymbol].self, from: "carLights.json")

    @Published  var isShowingLarge: Bool = false
    @Published  var symbolPressed: CarSymbol?
    @Published var selectedSymbol: CarSymbol?
    @Published var selectedIndex: Int? = nil {
        didSet {
            if let index = selectedIndex, index >= 0 && index < allLights.count {
                selectedSymbol = allLights[index]
            } else {
                selectedSymbol = nil
            }
        }
    }

    let bigImageId: Int = -1
    let desiredCellAspectRatio: CGFloat = 1.5
    let gridSpacing: CGFloat = 16
    let minimumCellWidth: CGFloat = 100
    let horizontalPadding: CGFloat = 16
    var backgroundColor: Color {
        isShowingLarge ? Color(.systemBackground) : Color(.systemGray6)
    }

    // Grid calculation methods
       func calculateColumns(for width: CGFloat) -> [GridItem] {
           let availableWidth = width - (horizontalPadding * 2)
           let possibleColumns = Int((availableWidth + gridSpacing) / (minimumCellWidth + gridSpacing))
           let actualColumns = max(2, possibleColumns)

           return Array(repeating: GridItem(.flexible(), spacing: gridSpacing), count: actualColumns)
       }

       func calculateCellWidth(for width: CGFloat, columns: Int) -> CGFloat {
           let availableWidth = width - (horizontalPadding * 2)
           return (availableWidth - (gridSpacing * CGFloat(columns - 1))) / CGFloat(columns)
       }

       func calculateCellHeight(width: CGFloat, columns: Int) -> CGFloat {
           let cellWidth = calculateCellWidth(for: width, columns: columns)
           return cellWidth * desiredCellAspectRatio
       }


}
