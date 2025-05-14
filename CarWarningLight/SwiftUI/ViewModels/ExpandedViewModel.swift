//
//  ExpandedViewModel.swift
//  CarWarningLight
//
//  Created by Sam Greenhill on 4/27/25.
//  Copyright © 2025 simplyAmazingMachines. All rights reserved.
//

import Foundation
import SwiftUI

 class ExpandedViewModel: ObservableObject {
     // Title animation properties
     @Published var showText = false
     @Published var titleOpacity: Double = 0
     @Published var titleOffset: CGFloat = 30

     // Card animation properties
     @Published var card1Opacity: Double = 0
     @Published var card1Offset: CGFloat = 30

     @Published var card2Opacity: Double = 0
     @Published var card2Offset: CGFloat = 30

     @Published var card3Opacity: Double = 0
     @Published var card3Offset: CGFloat = 30

     // Animation timers
     private var animationTimers: [Timer] = []

     func startAnimations() {
         // Reset all animation states first
         resetAnimations()

         // Show title with animation
         withAnimation(.easeOut(duration: 0.4)) {
             showText = true
             titleOpacity = 1
             titleOffset = 0
         }

         // Stagger card animations with timers
         let card1Timer = Timer.scheduledTimer(withTimeInterval: 0.3, repeats: false) { [weak self] _ in
             withAnimation(.spring(response: 0.5, dampingFraction: 0.7)) {
                 self?.card1Opacity = 1
                 self?.card1Offset = 0
             }
         }
         animationTimers.append(card1Timer)

         let card2Timer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false) { [weak self] _ in
             withAnimation(.spring(response: 0.5, dampingFraction: 0.7)) {
                 self?.card2Opacity = 1
                 self?.card2Offset = 0
             }
         }
         animationTimers.append(card2Timer)

         let card3Timer = Timer.scheduledTimer(withTimeInterval: 0.7, repeats: false) { [weak self] _ in
             withAnimation(.spring(response: 0.5, dampingFraction: 0.7)) {
                 self?.card3Opacity = 1
                 self?.card3Offset = 0
             }
         }
         animationTimers.append(card3Timer)
     }

     func resetAnimations() {
         // Cancel any running animations
         cancelAnimations()

         // Reset all states to initial values
         showText = false
         titleOpacity = 0
         titleOffset = 30

         card1Opacity = 0
         card1Offset = 30

         card2Opacity = 0
         card2Offset = 30

         card3Opacity = 0
         card3Offset = 30
     }

     func cancelAnimations() {
         // Invalidate all timers
         animationTimers.forEach { $0.invalidate() }
         animationTimers.removeAll()
     }

     deinit {
         cancelAnimations()
     }
 }
