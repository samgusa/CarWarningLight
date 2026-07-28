//
//  Vehicle.swift
//  CarWarningLight
//
//  Created by Sam Greenhill on 7/27/26.
//  Copyright © 2026 simplyAmazingMachines. All rights reserved.
//

import SwiftUI

struct Vehicle: Identifiable {
    let id = UUID()
    var name: String
    var systemStatuses: [SystemStatus]
    var imageName: String = "vehicleSedan"

    private func severityRank(_ type: SymbolType) -> Int {
        switch type {
        case .advisory:
            return 1
        case .info:
            return 2
        case .warning:
            return 0
        }
    }

    var totalActive: Int {
        systemStatuses.reduce(0) { $0 + $1.activeCount }
    }
    var worstSeverity: SymbolType? {
        systemStatuses.compactMap(\.worstSeverity).min { severityRank($0) < severityRank($1) }
    }
}
