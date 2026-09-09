//
//  VehicleFormViewModel.swift
//  CarWarningLight
//
//  Created by Sam Greenhill on 8/27/26.
//  Copyright © 2026 simplyAmazingMachines. All rights reserved.
//

import Foundation

@Observable
final class VehicleFormViewModel {
    var name: String
    var selectedImageName: String?

    var year: String        = ""
    var make: String        = ""
    var model: String       = ""
    var vin: String         = ""

    let existingVehicle: Vehicle?

    let bodyStyles: [(label: String, imageName: String)] = [
        ("Sedan",                                   "vehicleSedan"),
        ("SUV",                                     "vehicleSUV"),
        ("Pickup",                                  "vehiclePickup"),
        ("Hatchback",                               "vehicleHatchback"),
        ("Minivan",                                 "vehicleMinivan"),
        ("Coupe",                                   "vehicleCoupe"),
        ("Sports Car",                              "vehicleSportsCar"),
        ("Wagon",                                   "vehicleWagon")
    ]

    init(existingVehicle: Vehicle? = nil) {
        self.existingVehicle        = existingVehicle
        self.name                   = existingVehicle?.name ?? ""
        self.selectedImageName      = existingVehicle?.imageName ?? bodyStyles.first?.imageName
        self.year                   = existingVehicle?.year ?? ""
        self.make                   = existingVehicle?.make ?? ""
        self.model                  = existingVehicle?.model ?? ""
        self.vin                    = existingVehicle?.vin ?? ""
    }

    var trimmedName: String {
        name.trimmingCharacters(in: .whitespaces)
    }

    var isValid: Bool {
        !trimmedName.isEmpty && selectedImageName != nil
    }

    var hasChanges: Bool {
        guard let existingVehicle else { return true }
        return trimmedName      != existingVehicle.name
        || selectedImageName    != existingVehicle.imageName
        || year                 != existingVehicle.year
        || make                 != existingVehicle.make
        || model                != existingVehicle.model
        || vin                  != existingVehicle.vin
    }

    func buildNewVehicle() -> Vehicle? {
        guard isValid else { return nil }
        return Vehicle(
            name: trimmedName,
            imageName: selectedImageName ?? bodyStyles[0].imageName,
            year: year.trimmingCharacters(in: .whitespaces),
            make: make.trimmingCharacters(in: .whitespaces),
            model: model.trimmingCharacters(in: .whitespaces),
            vin: vin.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        )
    }

    func applyChanges() {
        guard let existingVehicle, isValid else { return }
        existingVehicle.name            = trimmedName
        existingVehicle.imageName       = selectedImageName ?? existingVehicle.imageName
        existingVehicle.year            = year.trimmingCharacters(in: .whitespaces)
        existingVehicle.make            = make.trimmingCharacters(in: .whitespaces)
        existingVehicle.model           = model.trimmingCharacters(in: .whitespaces)
        existingVehicle.vin             = vin.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
    }
}
