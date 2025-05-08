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
    let bundleLight: [CarSymbol] = Bundle.main.decode([CarSymbol].self, from: "carLights.json")
    @Published  var isShowingLarge: Bool = false
    @Published  var symbolPressed: CarSymbol = .empty
    @Published var selectedIndex: Int? = nil
    let bigImageId: Int = -1
    
}
