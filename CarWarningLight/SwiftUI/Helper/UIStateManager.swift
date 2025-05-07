//
//  UIStateManager.swift
//  CarWarningLight
//
//  Created by Sam Greenhill on 5/3/25.
//  Copyright © 2025 simplyAmazingMachines. All rights reserved.
//

import Foundation
import SwiftUI

class UIStateManager: ObservableObject {
    @Published var shouldShowFAB: Bool = true
    @Published var activeDetailID: String? = nil

    func detailViewAppeared(id: String) {
        activeDetailID = id
        shouldShowFAB = false
    }

    func detailViewDisappeared(id: String) {
        if activeDetailID == id {
            activeDetailID = nil
            shouldShowFAB = true
        }
    }
}


