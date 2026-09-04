//
//  ReportBuilderViewModel.swift
//  CarWarningLight
//
//  Created by Sam Greenhill on 8/27/26.
//  Copyright © 2026 simplyAmazingMachines. All rights reserved.
//

import SwiftUI

@Observable
@MainActor
final class ReportBuilderViewModel {
    let vehicle: Vehicle

    var includedLightIDs: Set<UUID>                              = []
    var includedCategoriesByIssue: [UUID: Set<IssueCategory>]    = [:]
    var isGenerating: Bool                                       = false
    var shareURL: IdentifiableURL?

    init(vehicle: Vehicle) {
        self.vehicle                                             = vehicle
    }

    var activeLights: [LightLogEntry] {
        vehicle.activeLightEntries.sorted { $0.dateLogged > $1.dateLogged }
    }

    var activeIssues: [VehicleIssue] {
        vehicle.activeIssues.sorted { $0.dateCreated > $1.dateCreated }
    }

    var hasAnythingToReport: Bool {
        !activeLights.isEmpty || !activeIssues.isEmpty
    }

    var selectedCount: Int {
        includedLightIDs.count + includedCategoriesByIssue.values.filter { !$0.isEmpty }.count
    }

    func preselectAll() {
        includedLightIDs = Set(activeLights.map(\.id))
        includedCategoriesByIssue = Dictionary(uniqueKeysWithValues: activeIssues.map { ($0.id, $0.categories) })
    }

    func isLightIncluded(_ entry: LightLogEntry) -> Bool {
        includedLightIDs.contains(entry.id)
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

    func generateReport() {
        isGenerating = true

        let lights = activeLights.filter { includedLightIDs.contains($0.id) }
        let issueEntries: [ReportIssueEntry] = activeIssues.compactMap { issue in
            guard let categories = includedCategoriesByIssue[issue.id], !categories.isEmpty else { return nil }

            let ordered = IssueCategory.allCases.filter { categories.contains($0) }
            return ReportIssueEntry(issue: issue, categories: ordered)
        }

        let document = ReportDocumentView(vehicle: vehicle, lights: lights, issueEntries: issueEntries)

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) { [weak self] in
            guard let self else { return }
            if let url = ReportPDFGenerator.generate(from: document, vehicleName: vehicle.name) {
                self.shareURL = IdentifiableURL(url: url)
            }
            self.isGenerating = false
        }
    }
}
