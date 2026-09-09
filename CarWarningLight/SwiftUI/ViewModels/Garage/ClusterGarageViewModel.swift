//
//  ClusterGarageViewModel.swift
//  CarWarningLight
//
//  Created by Sam Greenhill on 8/28/26.
//  Copyright © 2026 simplyAmazingMachines. All rights reserved.
//

import Foundation

@Observable
final class ClusterGarageViewModel {
    var showAddVehicle: Bool        = false
    var editingVehicle: Vehicle?
    var vehicleToDelete: Vehicle?

    func beginEditing(_ vehicle: Vehicle) {
        editingVehicle = vehicle
    }

    func requestDelete(_ vehicle: Vehicle) {
        vehicleToDelete = vehicle
    }

    func cancelDelete() {
        vehicleToDelete = nil
    }

    func confirmDelete() -> Vehicle? {
        defer { vehicleToDelete = nil }
        return vehicleToDelete
    }
}
