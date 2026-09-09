//
//  VehicleSystem.swift
//  CarWarningLight
//
//  Created by Sam Greenhill on 7/26/26.
//  Copyright © 2026 simplyAmazingMachines. All rights reserved.
//

import SwiftUI

enum VehicleSystem: String, CaseIterable, Identifiable {
    case engine             = "Engine & Powertrain"
    case braking            = "Braking"
    case electrical         = "Electrical"
    case lighting           = "Lighting"
    case driverAssist       = "Safety & Driver Assist"
    case tiresSuspension    = "Tires & Suspension"
    case comfort            = "Comfort & Climate"

    var id: String { rawValue }

    var icon: String {
        switch self {
        case .engine:          return "engine.combustion.fill"
        case .braking:         return "octagon.fill"
        case .electrical:      return "bolt.fill"
        case .lighting:        return "lightbulb.fill"
        case .driverAssist:    return "sensor.tag.radiowaves.forward.fill"
        case .tiresSuspension: return "tirepressure"
        case .comfort:         return "thermometer.medium"
        }
    }

    var shortLabel: String {
        switch self {
        case .driverAssist:    return "DRIVER ASSIST"
        case .tiresSuspension: return "TIRES"
        default:                return rawValue.uppercased()
        }
    }
}

struct SystemStatus: Identifiable {
    let system: VehicleSystem
    var activeCount: Int = 0
    var worstSeverity: SymbolType? = nil

    var id: VehicleSystem { system }
    var isActive: Bool { activeCount > 0 }

    var statusColor: Color {
        guard let worstSeverity else { return ClusterTheme.Colors.textSecondary }
        return ClusterTheme.Colors.forSymbolType(worstSeverity)
    }
}
