//
//  AddMaintenanceViewModel.swift
//  CarWarningLight
//
//  Created by Sam Greenhill on 9/13/26.
//  Copyright © 2026 simplyAmazingMachines. All rights reserved.
//

import Foundation
import SwiftUI

@Observable
final class AddMaintenanceViewModel {
    var selectedCategory: MaintenanceCategory?
    var noteText: String            = ""
    var capturedPhoto: UIImage?
    var mileageText: String         = ""
    var mileageUnit: DistanceUnit   = .deviceDefault

    var isValid: Bool { selectedCategory != nil }

    func buildItem(for vehicle: Vehicle) -> MaintenanceItem? {
        guard let selectedCategory else { return nil }

        let item = MaintenanceItem(
            vehicle: vehicle,
            category: selectedCategory,
            noteText: noteText.trimmingCharacters(in: .whitespacesAndNewlines)
        )
        item.photoImage             = capturedPhoto
        item.mileage                = Int(mileageText.trimmingCharacters(in: .whitespaces))
        item.mileageUnit            = mileageUnit
        return item
    }
}
