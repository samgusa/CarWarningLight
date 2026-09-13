//
//  ScanMatch.swift
//  CarWarningLight
//
//  Created by Sam Greenhill on 7/27/26.
//  Copyright © 2026 simplyAmazingMachines. All rights reserved.
//

import SwiftUI

struct ScanMatch: Identifiable {
    let carSymbol: CarSymbol
    let confidence: Double
    var id: Int { carSymbol.id }

    var confidenceLabel: String {
        let percent = confidence * 100
        if percent < 1 {
            return "<1%"
        }
        return "\(Int(percent))%"
    }
}
