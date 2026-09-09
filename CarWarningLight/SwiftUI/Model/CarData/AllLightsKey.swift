//
//  AllLightsKey.swift
//  CarWarningLight
//
//  Created by Sam Greenhill on 9/8/26.
//  Copyright © 2026 simplyAmazingMachines. All rights reserved.
//

import Foundation
import SwiftUI

private struct AllLightsKey: EnvironmentKey {
    static let defaultValue: [CarSymbol] = []
}

extension EnvironmentValues {
    var allLights: [CarSymbol] {
        get { self[AllLightsKey.self] }
        set { self[AllLightsKey.self] = newValue }
    }
}
