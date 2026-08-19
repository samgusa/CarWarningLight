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
    private let allLights: [CarSymbol] = Bundle.main.decode([CarSymbol].self, from: "carLights.json")

    var body: some Scene {
        WindowGroup {
            ClusterRootView(allLights: allLights)
                .environmentObject(uiState)
        }
        .modelContainer(for: [Vehicle.self, VehicleIssue.self, LightLogEntry.self])
    }
}
