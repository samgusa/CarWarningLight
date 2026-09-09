//
//  DistanceUnit.swift
//  CarWarningLight
//
//  Created by Sam Greenhill on 9/4/26.
//  Copyright © 2026 simplyAmazingMachines. All rights reserved.
//

import Foundation

enum DistanceUnit: String, Codable, CaseIterable, Identifiable {
    case miles, kilometers
    var id: String { rawValue }
    var abbreviation: String { self == .miles ? "mi" : "km" }

    static var deviceDefault: DistanceUnit {
        switch Locale.current.measurementSystem {
        case .us, .uk:          return .miles
        default:                return .kilometers
        }
    }
}
