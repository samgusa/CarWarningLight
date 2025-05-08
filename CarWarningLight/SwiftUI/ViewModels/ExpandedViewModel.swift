//
//  ExpandedViewModel.swift
//  CarWarningLight
//
//  Created by Sam Greenhill on 4/27/25.
//  Copyright © 2025 simplyAmazingMachines. All rights reserved.
//

import Foundation
import SwiftUI

// Extend the ViewModel to support our cascading animation
class ExpandedViewModel: ObservableObject {
    @Published var showText = false
    @Published var showContent = false
    @Published var textOffset: CGFloat = -50

    // Animation properties for each card
    @Published var descriptionOffset: CGFloat = -60
    @Published var descriptionOpacity: Double = 0

    @Published var fixOffset: CGFloat = -60
    @Published var fixOpacity: Double = 0

    @Published var driveOffset: CGFloat = -60
    @Published var driveOpacity: Double = 0

    func startCardAnimations() {
        showContent = true

        // First card animation
        withAnimation(.spring(response: 0.5, dampingFraction: 0.7)) {
            descriptionOpacity = 1
            descriptionOffset = 0
        }

        // Second card animation with delay
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            withAnimation(.spring(response: 0.5, dampingFraction: 0.7)) {
                self.fixOpacity = 1
                self.fixOffset = 0
            }

            // Third card animation with delay
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                withAnimation(.spring(response: 0.5, dampingFraction: 0.7)) {
                    self.driveOpacity = 1
                    self.driveOffset = 0
                }
            }
        }
    }
}
