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
    case noise, vibration, smell, leak, fluid, handling, starting, electrical, visibleDamage, unsure

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
        case .unsure:           return "Not Sure"
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
        case .unsure:           return "questionmark.circle"
        }
    }
}

@Model
final class VehicleIssue {
    var id: UUID                                = UUID()
    var dateCreated: Date                       = Date()
    var isActive: Bool                          = true
    var noteText: String                        = ""
    var mileage: Int?
    private var mileageUnitRaw: String          = DistanceUnit.deviceDefault.rawValue
    private var categoriesRaw: [String]         = []
    private var linkedLightSymbolIDsRaw: [Int]  = []
    @Attribute(.externalStorage) private var photoData: Data?

    var mileageUnit: DistanceUnit {
        get { DistanceUnit(rawValue: mileageUnitRaw) ?? .miles }
        set { mileageUnitRaw = newValue.rawValue }
    }

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

    var linkedLightSymbolIDs: Set<Int> {
        get { Set(linkedLightSymbolIDsRaw) }
        set { linkedLightSymbolIDsRaw = Array(newValue) }
    }

    func displayTitle(allLights: [CarSymbol]) -> String {
        if let category = sortedCategories.first?.label { return category }

        let trimmedNote = noteText.trimmingCharacters(in: .whitespacesAndNewlines)
        if !trimmedNote.isEmpty {
            return Self.truncatedTitle(from: trimmedNote, limit: 40)
        }

        if let firstID = linkedLightSymbolIDs.first,
           let light = allLights.first(where: { $0.id == firstID }) {
            let extra = linkedLightSymbolIDs.count > 1 ? " + \(linkedLightSymbolIDs.count - 1)" : ""
            return light.name + extra
        }
        return "Untitled Issue"
     }

    private static func truncatedTitle(from text: String, limit: Int) -> String {
        guard text.count > limit else { return text }
        let prefix = String(text.prefix(limit))
        if let lastSpace = prefix.lastIndex(of: " ") {
            return String(prefix[..<lastSpace]) + "..."
        }
        return prefix + "..."
    }
}

enum GarageTimelineItem: Identifiable {
    case light(LightLogEntry)
    case issue(VehicleIssue)
    case maintenance(MaintenanceItem)

    var id: String {
        switch self {
        case .light(let entry):         return "light-\(entry.id)"
        case .issue(let issue):         return "issue-\(issue.id)"
        case .maintenance(let item):    return "maintenance-\(item.id)"
        }
    }

    var date: Date {
        switch self {
        case .light(let entry):         return entry.dateLogged
        case .issue(let issue):         return issue.dateCreated
        case .maintenance(let item):    return item.dateCreated
        }
    }

    var isActive: Bool {
        switch self {
        case .light(let entry):         return entry.isActive
        case .issue(let issue):         return issue.isActive
        case .maintenance(let item):    return item.isActive
        }
    }
}
