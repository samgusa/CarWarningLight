//
//  MainViewModel.swift
//  CarWarningLight
//
//  Created by Sam Greenhill on 4/27/25.
//  Copyright © 2025 simplyAmazingMachines. All rights reserved.
//

import Foundation

class MainViewModel2: ObservableObject {
    let bundleLight: [CarSymbol] = Bundle.main.decode([CarSymbol].self, from: "carLights.json")

    @Published  var isPressed: Bool = false
    @Published  var itemPressed: Int = 0
    @Published  var symbolPressed: CarSymbol = .empty

}
