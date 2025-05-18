 //
 //  MainViewModel2.swift
 //  CarWarningLight
 //
 //  Created by Sam Greenhill on 4/27/25.
 //  Copyright © 2025 simplyAmazingMachines. All rights reserved.
 //

 import Foundation
 import SwiftUI

 class MainViewModel: ObservableObject {
     // All car warning lights loaded from json
     let allLights: [CarSymbol] = Bundle.main.decode([CarSymbol].self, from: "carLights.json")

     @Published  var isShowingLarge: Bool = false
     @Published  var symbolPressed: CarSymbol?
     @Published var selectedSymbol: CarSymbol?
     @Published var isTransitioning: Bool = false
     @Published var selectedIndex: Int? = nil {
         didSet {
             if !isShowingLarge && selectedIndex != nil {
                 DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                     if !self.isShowingLarge {
                         self.selectedIndex = nil
                     }
                 }
             }
         }
     }

     let bigImageId: Int = -1
     let desiredCellAspectRatio: CGFloat = 1.5
     let gridSpacing: CGFloat = 16
     let minimumCellWidth: CGFloat = 100
     let horizontalPadding: CGFloat = 16

     private var lastTransitionTime: Date = Date(timeIntervalSince1970: 0)
     private let minimumTransitionInterval: TimeInterval = 0.2

     func shouldAllowTransition() -> Bool {
         let now = Date()
         let elapsed = now.timeIntervalSince(lastTransitionTime)

         if elapsed > minimumTransitionInterval {
             lastTransitionTime = now
             return true
         }
         return false
     }
 }
