//
//  Vehicle.swift
//  CarWarningLight
//
//  Created by Sam Greenhill on 7/27/26.
//  Copyright © 2026 simplyAmazingMachines. All rights reserved.
//

import SwiftUI
import SwiftData

@Model
final class Vehicle {
    var id: UUID                = UUID()
    var name: String            = ""
    var imageName: String       = "vehicleSedan"
    var dateCreated: Date       = Date()
    var year: String            = ""
    var make: String            = ""
    var model: String           = ""
    var vin: String             = ""

    @Relationship(deleteRule: .cascade, inverse: \VehicleIssue.vehicle)
    var issues: [VehicleIssue]  = []

    @Relationship(deleteRule: .cascade, inverse: \LightLogEntry.vehicle)
    var lightLogEntries: [LightLogEntry] = []

    init(name: String, imageName: String = "vehicleSedan", year: String = "", make: String = "", model: String = "", vin: String = "") {
        self.name               = name
        self.imageName          = imageName
        self.year               = year
        self.make               = make
        self.model              = model
        self.vin                = vin
    }

    // MARK: - Derived status (Garage card + banners read these)

    var activeIssues: [VehicleIssue] { issues.filter(\.isActive) }
    var activeLightEntries: [LightLogEntry] { lightLogEntries.filter(\.isActive) }

    var totalActive: Int { activeIssues.count + activeLightEntries.count }

    var worstSeverity: SymbolType? {
        activeLightEntries
            .map(\.carSymbol.symbolType)
            .min { $0.severityRank < $1.severityRank }
    }

    var timelineItems: [GarageTimelineItem] {
        let lights = lightLogEntries.map(GarageTimelineItem.light)
        let issueItems = issues.map(GarageTimelineItem.issue)
        return (lights + issueItems).sorted { $0.date > $1.date }
    }

    func imageName(for kind: VehicleDiagramKind) -> String {
        switch kind {
        case .topDown:                  return imageName
        case .leftSide, .rightSide:     return imageName.replacingOccurrences(of: "vehicle", with: "side")
        }
    }
}

