//
//  WarningLightCameraApp.swift
//  CarWarningLight
//
//  Created by Sam Greenhill on 4/23/25.
//  Copyright © 2025 simplyAmazingMachines. All rights reserved.
//

import SwiftUI

@main
struct WarningLightCameraApp: App {
    @StateObject private var uiState = UIStateManager()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(uiState)
        }
    }
}
