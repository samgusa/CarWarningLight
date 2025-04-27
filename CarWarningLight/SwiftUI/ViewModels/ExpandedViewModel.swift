//
//  ExpandedViewModel.swift
//  CarWarningLight
//
//  Created by Sam Greenhill on 4/27/25.
//  Copyright © 2025 simplyAmazingMachines. All rights reserved.
//

import Foundation

class ExpandedViewModel: ObservableObject {
    @Published var showText: Bool = false
    @Published var descriptionOpacity: Bool = false
    @Published var fixDescriptionOpacity: Bool = false
    @Published var drivableOpacity: Bool = false

    func triggerAnimations() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.descriptionOpacity = true
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            self.fixDescriptionOpacity = true
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            self.drivableOpacity = true
        }
    }

    var testText = { (text: String) in
        return ""
    }
}
