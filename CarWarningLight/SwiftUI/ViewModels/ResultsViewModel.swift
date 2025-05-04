//
//  ResultsViewModel.swift
//  CarWarningLight
//
//  Created by Sam Greenhill on 4/27/25.
//  Copyright © 2025 simplyAmazingMachines. All rights reserved.
//

import Foundation

class ResultsViewModel: ObservableObject {

    @Published var isPressed: Bool = false
    @Published var symbolPressed: CarSymbol? = nil
    @Published var showCameraOptions: Bool = false

    func selectSymbol(_ carSymbol: CarSymbol) {
        isPressed = true
        symbolPressed = carSymbol
    }

    func onRetakePhoto() {
        print("Photo")
    }
    func onChooseFromLibrary() {
        print("Library")
    }
    func onDone() {
        print("Done")
    }

}
