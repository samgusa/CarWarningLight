//
//  CarSymbolLibrary.swift
//  CarWarningLight
//
//  Created by Sam Greenhill on 9/10/26.
//  Copyright © 2026 simplyAmazingMachines. All rights reserved.
//

import Foundation

extension CarSymbol {

    static let bundledLibrary: [CarSymbol] = {
        do {
            return try Bundle.main.decodeOrThrow([CarSymbol].self, from: "carLights.json")
        } catch {
            #if DEBUG
            assertionFailure("carLights.json failed to decode: \(error)")
            #endif
            return []
        }
    }()
}
