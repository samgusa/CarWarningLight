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

    func clearSelection() {
        withAnimation {
            selectedIndex = nil
            selectedSymbol = nil
            isShowingLarge = false
        }
    }
}
