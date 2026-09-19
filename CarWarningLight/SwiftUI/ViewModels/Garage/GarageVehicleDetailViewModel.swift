//
//  GarageVehicleDetailViewModel.swift
//  CarWarningLight
//
//  Created by Sam Greenhill on 8/28/26.
//  Copyright © 2026 simplyAmazingMachines. All rights reserved.
//

import Foundation

@Observable
final class GarageVehicleDetailViewModel {
    var showAddIssue: Bool          = false
    var showAddMaintenance: Bool    = false
    var showReportBuilder: Bool     = false

    private static let dayLabelFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d"
        return formatter
    }()

    func groupedTimeline(for vehicle: Vehicle) -> [(day: Date, items: [GarageTimelineItem])] {
        let calendar = Calendar.current
        let grouped = Dictionary(grouping: vehicle.timelineItems) { calendar.startOfDay(for: $0.date) }
        return grouped
            .sorted { $0.key > $1.key }
            .map { (day: $0.key, items: $0.value.sorted { $0.date > $1.date }) }
    }

    func dayLabel(_ date: Date) -> String {
        Self.dayLabelFormatter.string(from: date).uppercased()
    }
}
