//
//  MaintenanceDetailViewModel.swift
//  CarWarningLight
//
//  Created by Sam Greenhill on 9/13/26.
//  Copyright © 2026 simplyAmazingMachines. All rights reserved.
//
import Foundation
import SwiftUI

@Observable
final class MaintenanceDetailViewModel {
    let item: MaintenanceItem

    var showDeleteConfirm: Bool     = false

    init(item: MaintenanceItem) {
        self.item = item
    }

    var dateLabel: String {
        let formatter               = DateFormatter()
        formatter.dateStyle         = .medium
        formatter.timeStyle         = .short
        return formatter.string(from: item.dateCreated)
    }

    var photo: UIImage? {
        get { item.photoImage }
        set { item.photoImage = newValue }
    }

    func toggleResolved() {
        item.isActive.toggle()
    }

    func requestDelete() {
        showDeleteConfirm = true
    }
}
