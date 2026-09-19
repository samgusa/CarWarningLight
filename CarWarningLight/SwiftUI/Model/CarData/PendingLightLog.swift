//
//  PendingLightLog.swift
//  CarWarningLight
//
//  Created by Sam Greenhill on 9/7/26.
//  Copyright © 2026 simplyAmazingMachines. All rights reserved.
//

import Foundation

struct PendingLightLog: Identifiable {
    let symbol: CarSymbol
    let completion: (Vehicle) -> Void
    var id: Int { symbol.id }
}
