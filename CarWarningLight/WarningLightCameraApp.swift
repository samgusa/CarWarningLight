//
//  WarningLightCameraApp.swift
//  CarWarningLight
//
//  Created by Sam Greenhill on 4/23/25.
//  Copyright © 2025 simplyAmazingMachines. All rights reserved.
//

import SwiftUI
import SwiftData

@main
struct WarningLightCameraApp: App {
    @StateObject private var uiState = UIStateManager()
    @State private var tipStore = TipJarStore()
    private let allLights: [CarSymbol] = CarSymbol.bundledLibrary

    var body: some Scene {
        WindowGroup {
            ClusterRootView()
                .environmentObject(uiState)
                .environment(tipStore)
                .environment(\.allLights, allLights)
        }
        .modelContainer(for: [Vehicle.self, VehicleIssue.self, LightLogEntry.self, MaintenanceItem.self])
    }
}
