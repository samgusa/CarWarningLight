//
//  VehicleIssue.swift
//  CarWarningLight
//
//  Created by Sam Greenhill on 8/17/26.
//  Copyright © 2026 simplyAmazingMachines. All rights reserved.
//

import SwiftUI
import SwiftData

enum IssueCategory: String, Codable, CaseIterable, Identifiable {
    case noise, vibration, smell, leak, fluid, handling, starting, electrical, visibleDamage

    var id: String { rawValue }

    var label: String {
        switch self {
        case .noise:            return "Noise"
        case .vibration:        return "Vibration"
        case .smell:            return "Smell"
        case .leak:             return "Leak"
        case .fluid:            return "Fluid"
        case .handling:         return "Handling"
        case .starting:         return "Starting"
        case .electrical:       return "Electrical"
        case .visibleDamage:    return "Visible Damage"
        }
    }

    var icon: String {
        switch self {
        case .noise:            return "waveform"
        case .vibration:        return "waveform.path"
        case .smell:            return "wind"
        case .leak:             return "drop.triangle"
        case .fluid:            return "drop.fill"
        case .handling:         return "steeringwheel"
        case .starting:         return "key.fill"
        case .electrical:       return "bolt.fill"
        case .visibleDamage:    return "exclamationmark.triangle.fill"
        }
    }
}

@Model
final class VehicleIssue {
    var id: UUID                        = UUID()
    var dateCreated: Date               = Date()
    var isActive: Bool                  = true
    var noteText: String                = ""
    var mileage: Int?
    private var categoriesRaw: [String] = []
    @Attribute(.externalStorage) private var photoData: Data?

    var vehicle: Vehicle?

    init(vehicle: Vehicle?, categories: Set<IssueCategory> = [], noteText: String = "", dateCreated: Date = Date(), mileage: Int = 0) {
        self.vehicle                    = vehicle
        self.categoriesRaw              = categories.map(\.rawValue)
        self.noteText                   = noteText
        self.dateCreated                = dateCreated
        self.mileage                    = mileage
    }

    var categories: Set<IssueCategory> {
        get { Set(categoriesRaw.compactMap(IssueCategory.init(rawValue:))) }
        set { categoriesRaw = newValue.map(\.rawValue) }
    }

    var sortedCategories: [IssueCategory] {
        IssueCategory.allCases.filter { categories.contains($0) }
    }

    var title: String {
        sortedCategories.first?.label ?? "Issue"
    }

    private var markedZonesRaw: [String] = []

    var markedZones: Set<String> {
        get { Set(markedZonesRaw) }
        set { markedZonesRaw = Array(newValue) }
    }

    var photoImage: UIImage? {
        get { photoData.flatMap(UIImage.init) }
        set { photoData = newValue?.jpegData(compressionQuality: 0.7) }
    }
}

enum GarageTimelineItem: Identifiable {
    case light(LightLogEntry)
    case issue(VehicleIssue)

    var id: String {
        switch self {
        case .light(let entry):     return "light-\(entry.id)"
        case .issue(let issue):     return "issue-\(issue.id)"
        }
    }

    var date: Date {
        switch self {
        case .light(let entry): return entry.dateLogged
        case .issue(let issue): return issue.dateCreated
        }
    }

    var isActive: Bool {
        switch self {
        case .light(let entry): return entry.isActive
        case .issue(let issue): return issue.isActive
        }
    }
}
