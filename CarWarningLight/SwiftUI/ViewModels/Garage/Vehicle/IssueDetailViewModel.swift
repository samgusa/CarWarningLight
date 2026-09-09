//
//  IssueDetailViewModel.swift
//  CarWarningLight
//
//  Created by Sam Greenhill on 8/26/26.
//  Copyright © 2026 simplyAmazingMachines. All rights reserved.
//

import Foundation
import SwiftUI

@Observable
final class IssueDetailViewModel {
    let issue: VehicleIssue

    var showDeleteConfirm: Bool = false

    init(issue: VehicleIssue) {
        self.issue = issue
    }

    var linkedLightSymbolIDsBinding: Binding<Set<Int>> {
        Binding(
            get: { self.issue.linkedLightSymbolIDs },
            set: { self.issue.linkedLightSymbolIDs = $0 }
        )
    }

    var dateLabel: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter.string(from: issue.dateCreated)
    }

    func toggleCategory(_ category: IssueCategory) {
        var updated = issue.categories
        if updated.contains(category) {
            updated.remove(category)
        } else {
            updated.insert(category)
        }
        issue.categories = updated
    }

    func toggleResolved() {
        issue.isActive.toggle()
    }

    var markedZonesBinding: Binding<Set<String>> {
        Binding(
            get: { self.issue.markedZones },
            set: { self.issue.markedZones = $0 }
        )
    }

    var photo: UIImage? {
        get { issue.photoImage }
        set { issue.photoImage = newValue }
    }

    func requestDelete() {
        showDeleteConfirm = true
    }
}
