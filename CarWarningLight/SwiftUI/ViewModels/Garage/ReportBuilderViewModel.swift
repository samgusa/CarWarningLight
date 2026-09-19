//
//  ReportBuilderViewModel.swift
//  CarWarningLight
//
//  Created by Sam Greenhill on 8/27/26.
//  Copyright © 2026 simplyAmazingMachines. All rights reserved.
//

import SwiftUI
import SwiftData

@Observable
@MainActor
final class ReportBuilderViewModel {
    let vehicle: Vehicle

    var includedLightIDs: Set<UUID>                                 = []
    var includedIssueIDs: Set<UUID>                                 = []
    var includedCategoriesByIssue: [UUID: Set<IssueCategory>]       = [:]
    var includedMaintenanceIDs: Set<UUID>                           = []
    var isGenerating: Bool                                          = false
    var shareURL: IdentifiableURL?

    var contactName: String {
        get { UserDefaults.standard.string(forKey: "reportContactName") ?? "" }
        set { UserDefaults.standard.set(newValue, forKey: "reportContactName") }
    }

    var contactPhone: String {
        get { UserDefaults.standard.string(forKey: "reportContactPhone") ?? "" }
        set { UserDefaults.standard.set(newValue, forKey: "reportContactPhone") }
    }

    init(vehicle: Vehicle) {
        self.vehicle                                             = vehicle
    }

    var activeLights: [LightLogEntry] {
        vehicle.activeLightEntries.sorted { $0.dateLogged > $1.dateLogged }
    }

    var activeIssues: [VehicleIssue] {
        vehicle.activeIssues.sorted { $0.dateCreated > $1.dateCreated }
    }

    var activeMaintenanceItems: [MaintenanceItem] {
        vehicle.activeMaintenanceItems.sorted { $0.dateCreated > $1.dateCreated }
    }

    var hasAnythingToReport: Bool {
        !activeLights.isEmpty || !activeIssues.isEmpty || !activeMaintenanceItems.isEmpty
    }

    var selectedCount: Int {
        includedLightIDs.count + includedIssueIDs.count + includedMaintenanceIDs.count
    }

    func preselectAll() {
        includedLightIDs = Set(activeLights.map(\.id))
        includedIssueIDs = Set(activeIssues.map(\.id))
        includedCategoriesByIssue = Dictionary(uniqueKeysWithValues: activeIssues.map { ($0.id, $0.categories) })
        includedMaintenanceIDs = Set(activeMaintenanceItems.map(\.id))
    }

    func isIssueIncluded(_ issue: VehicleIssue) -> Bool {
        includedIssueIDs.contains(issue.id)
    }

    func isLightIncluded(_ entry: LightLogEntry) -> Bool {
        includedLightIDs.contains(entry.id)
    }

    func toggleIssueIncluded(_ issue: VehicleIssue) {
        if includedIssueIDs.contains(issue.id) { includedIssueIDs.remove(issue.id) }
        else { includedIssueIDs.insert(issue.id) }
    }

    func toggleLight(_ entry: LightLogEntry) {
        if includedLightIDs.contains(entry.id) {
            includedLightIDs.remove(entry.id)
        } else {
            includedLightIDs.insert(entry.id)
        }
    }

    func includedCategories(for issue: VehicleIssue) -> Set<IssueCategory> {
        includedCategoriesByIssue[issue.id] ?? []
    }

    func toggleCategory(_ category: IssueCategory, for issue: VehicleIssue) {
        var updated = includedCategories(for: issue)
        if updated.contains(category) {
            updated.remove(category)
        } else {
            updated.insert(category)
        }
        includedCategoriesByIssue[issue.id] = updated
    }

    func isMaintenanceIncluded(_ item: MaintenanceItem) -> Bool {
        includedMaintenanceIDs.contains(item.id)
    }

    func toggleMaintenance(_ item: MaintenanceItem) {
        if includedMaintenanceIDs.contains(item.id) {
            includedMaintenanceIDs.remove(item.id)
        } else {
            includedMaintenanceIDs.insert(item.id)
        }
    }

    func generateReport(allLights: [CarSymbol]) {
        isGenerating = true

        let lights = activeLights.filter { includedLightIDs.contains($0.id) }
        let issueEntries: [ReportIssueEntry] = activeIssues.compactMap { issue in
            guard includedIssueIDs.contains(issue.id) else { return nil }
            let categories = includedCategoriesByIssue[issue.id] ?? []
            let ordered = IssueCategory.allCases.filter { categories.contains($0) }
            
            return ReportIssueEntry(issue: issue, categories: ordered)
        }
        let maintenanceItems = activeMaintenanceItems.filter { includedMaintenanceIDs.contains($0.id) }

        Task { [weak self] in
            guard let self else { return }
            let url = await ReportPDFGenerator.generate(
                vehicle: vehicle,
                lights: lights,
                issueEntries: issueEntries,
                maintenanceItems: maintenanceItems,
                allLights: allLights,
                ownerName: contactName,
                ownerContact: contactPhone
            )
            if let url {
                self.shareURL = IdentifiableURL(url: url, title: "\(vehicle.name) - Report")
            }
            self.isGenerating = false
        }
    }
}
