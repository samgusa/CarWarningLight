//
//  LightLogEntry.swift
//  CarWarningLight
//
//  Created by Sam Greenhill on 7/26/26.
//  Copyright © 2026 simplyAmazingMachines. All rights reserved.
//

import Foundation

struct LightLogEntry: Identifiable {
    let id = UUID()
    let carSymbol: CarSymbol
    let dateLogged: Date
    var isActive: Bool = true
    var note: String = ""
    var vehicleID: UUID = UUID()
}
