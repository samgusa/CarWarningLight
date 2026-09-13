//
//  MaintenanceItem.swift
//  CarWarningLight
//
//  Created by Sam Greenhill on 9/13/26.
//  Copyright © 2026 simplyAmazingMachines. All rights reserved.
//

import SwiftUI
import SwiftData

enum MaintenanceCategory: String, Codable, CaseIterable, Identifiable {
    case wiperBlades, oilChange, airFilter, cabinFilter, brakePads, tires, battery, beltsHoses, sparkPlugs, other

    var id: String { rawValue }

    var label: String {
        switch self {
        case .wiperBlades:      return "Wiper Blades"
        case .oilChange:        return "Oil Change"
        case .airFilter:        return "Air Filter"
        case .cabinFilter:      return "Cabin Filter"
        case .brakePads:        return "Brake Pads"
        case .tires:            return "Tires"
        case .battery:          return "Battery"
        case .beltsHoses:       return "Belts / Hoses"
        case .sparkPlugs:       return "Spark Plugs"
        case .other:            return "Other"
        }
    }

    var icon: String {
        switch self {
        case .wiperBlades:   return "wind"
        case .oilChange:     return "drop.fill"
        case .airFilter:     return "aqi.medium"
        case .cabinFilter:   return "fan.fill"
        case .brakePads:     return "octagon.fill"
        case .tires:         return "circle.dashed"
        case .battery:       return "bolt.fill"
        case .beltsHoses:    return "arrow.triangle.2.circlepath"
        case .sparkPlugs:    return "sparkles"
        case .other:         return "wrench.and.screwdriver"
        }
    }
}

@Model
final class MaintenanceItem {
    var id: UUID                            = UUID()
    var dateCreated: Date                   = Date()
    var isActive: Bool                      = true
    var noteText: String                    = ""
    var mileage: Int?
    private var mileageUnitRaw: String      = DistanceUnit.deviceDefault.rawValue
    private var categoryRaw: String         = MaintenanceCategory.other.rawValue
    @Attribute(.externalStorage) private var photoData: Data?

    var vehicle: Vehicle?

    init(vehicle: Vehicle?, category: MaintenanceCategory, noteText: String = "", dateCreated: Date = Date(), mileage: Int? = nil) {
        self.vehicle = vehicle
        self.categoryRaw = category.rawValue
        self.noteText = noteText
        self.dateCreated = dateCreated
        self.mileage = mileage
    }

    var category: MaintenanceCategory {
        get { MaintenanceCategory(rawValue: categoryRaw) ?? .other }
        set { categoryRaw = newValue.rawValue }
    }

    var mileageUnit: DistanceUnit {
        get { DistanceUnit(rawValue: mileageUnitRaw) ?? .miles }
        set { mileageUnitRaw = newValue.rawValue }
    }

    var photoImage: UIImage? {
        get { photoData.flatMap(UIImage.init) }
        set { photoData = newValue?.jpegData(compressionQuality: 0.7) }
    }

    var title: String {
        category.label
    }
}
