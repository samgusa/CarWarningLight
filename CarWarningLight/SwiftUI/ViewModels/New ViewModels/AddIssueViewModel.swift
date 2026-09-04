//
//  AddIssueViewModel.swift
//  CarWarningLight
//
//  Created by Sam Greenhill on 8/26/26.
//  Copyright © 2026 simplyAmazingMachines. All rights reserved.
//

import Foundation
import SwiftUI

@Observable
final class AddIssueViewModel {
    var selectedCategories: Set<IssueCategory> = []
    var noteText: String                        = ""
    var markedZones: Set<String>                = []
    var capturedPhoto: UIImage?
    var mileageText: String                     = ""

    var isValid: Bool {
        !selectedCategories.isEmpty
    }

    func toggleCategory(_ category: IssueCategory) {
        if selectedCategories.contains(category) {
            selectedCategories.remove(category)
        } else {
            selectedCategories.insert(category)
        }
    }

    func buildIssue(for vehicle: Vehicle) -> VehicleIssue? {
        guard isValid else { return nil }

        let issue = VehicleIssue(
            vehicle:        vehicle,
            categories:     selectedCategories,
            noteText:       noteText.trimmingCharacters(in: .whitespacesAndNewlines)
        )
        issue.markedZones   = markedZones
        issue.photoImage    = capturedPhoto
        issue.mileage = Int(mileageText.trimmingCharacters(in: .whitespaces))
        return issue
    }
}
