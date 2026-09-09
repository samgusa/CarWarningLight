//
//  LightLogEntry.swift
//  CarWarningLight
//
//  Created by Sam Greenhill on 7/26/26.
//  Copyright © 2026 simplyAmazingMachines. All rights reserved.
//

import Foundation
import SwiftData

@Model
final class LightLogEntry {
    var id: UUID            = UUID()
    var carSymbolData: Data = Data()
    var dateLogged: Date    = Date()
    var isActive: Bool      = true
    var note: String        = ""

    var vehicle: Vehicle?

    var carSymbol: CarSymbol {
        get { (try? JSONDecoder().decode(CarSymbol.self, from: carSymbolData)) ?? .empty }
        set { carSymbolData = (try? JSONEncoder().encode(newValue)) ?? Data() }
    }

    init(carSymbol: CarSymbol, dateLogged: Date = Date(), isActive: Bool = true, note: String = "", vehicle: Vehicle? = nil) {
        self.carSymbolData  = (try? JSONEncoder().encode(carSymbol)) ?? Data()
        self.dateLogged     = dateLogged
        self.isActive       = isActive
        self.note           = note
        self.vehicle        = vehicle
    }
}
