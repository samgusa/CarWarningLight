//
//  GarageVehicleDetailView.swift
//  CarWarningLight
//
//  Created by Sam Greenhill on 8/17/26.
//  Copyright © 2026 simplyAmazingMachines. All rights reserved.
//

import SwiftUI
import SwiftData

struct GarageVehicleDetailView: View {
    @Bindable var vehicle: Vehicle

    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \Vehicle.dateCreated) private var allVehicles: [Vehicle]

    @State private var showAddIssue: Bool           = false
    @State private var showReportBuilder: Bool      = false
    @Namespace private var detailedNamespace

    private var groupedTimeline: [(day: Date, items: [GarageTimelineItem])] {
        let calendar = Calendar.current
        let grouped = Dictionary(grouping: vehicle.timelineItems) { calendar.startOfDay(for: $0.date) }
        return grouped
            .sorted { $0.key > $1.key }
            .map { (day: $0.key, items: $0.value.sorted { $0.date > $1.date }) }
    }


    var body: some View {
        VStack(spacing: 0) {
            ClusterHeaderBar(title: vehicle.name, icon: "chevron.left") { dismiss() }

            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    controlsRow

                    if vehicle.totalActive > 0 {
                        ClusterCautionLabel(
                            icon: "eye.fill",
                            title: "\(vehicle.totalActive) thing\(vehicle.totalActive == 1 ? "" : "s") to keep an eye on",
                            subtitle: "Tap any entry for details, or mark it resolved"
                        )
                        .padding(.horizontal)
                    }

                    if vehicle.timelineItems.isEmpty {
                        emptyState
                    } else {
                        ForEach(groupedTimeline, id: \.day) { group in
                            VStack(alignment: .leading, spacing: 10) {
                                Text(daylabel(group.day))
                                    .font(ClusterTheme.Types.mono(11, weight: .bold))
                                    .tracking(1.2)
                                    .foregroundStyle(ClusterTheme.Colors.textSecondary)
                                    .padding(.horizontal)

                                ForEach(group.items) { item in
                                    timelineRow(for: item)
                                        .padding(.horizontal)
                                }
                            }
                        }
                    }
                }
                .padding(.top, 16)
                .padding(.bottom, 24)
            }
        }
        .background(ClusterTheme.Colors.background)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar(.hidden, for: .navigationBar)
        .navigationDestination(for: LightLogEntry.self) { entry in
            ClusterExpandedView(
                carSymbol: entry.carSymbol,
                namespace: detailedNamespace,
                isShowingLarge: .constant(true),
                bigImageId: 0,
                index: .constant(0),
                isStandAlone: true,
                logEntry: entry,
                onToggleResolved: { entry.isActive.toggle() },
                onDeleteEntry: { modelContext.delete(entry) }
            )
        }
        .navigationDestination(for: VehicleIssue.self) { issue in
            IssueDetailView(issue: issue)
        }
        .sheet(isPresented: $showAddIssue) {
            AddIssueView(vehicle: vehicle)
        }
        .sheet(isPresented: $showReportBuilder) {
            ReportBuilderView(vehicle: vehicle)
        }
    }

    private var controlsRow: some View {
        HStack {
            Menu {
                ForEach(allVehicles) { candidate in
                    if candidate.id == vehicle.id {
                        Label(candidate.name, systemImage: "checkmark")
                    } else {
                        NavigationLink(candidate.name, value: candidate)
                    }
                }
            } label: {
                HStack(spacing: 6) {
                    Image(systemName: "car.fill")
                        .font(.system(size: 12, weight: .semibold))
                    Text(vehicle.name)
                        .font(ClusterTheme.Types.body(15, weight: .bold))
                    Image(systemName: "chevron.down")
                        .font(.system(size: 10, weight: .bold))
                }
                .foregroundStyle(ClusterTheme.Colors.textPrimary)
                .padding(.horizontal, 14)
                .padding(.vertical, 8)
                .background(ClusterTheme.Colors.panel)
                .clipShape(RoundedRectangle(cornerRadius: 8))
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(ClusterTheme.Colors.bezel, lineWidth: 1)
                )
            }

            Spacer()

            ClusterSquareIconButton(icon: "doc.text.fill") {
                showReportBuilder = true
            }
            .accessibilityLabel("Build a report")

            ClusterAngledButton(icon: "plus", label: "Log Issue") {
                showAddIssue = true
            }
        }
        .padding(.horizontal)
    }

    @ViewBuilder
    private func timelineRow(for item: GarageTimelineItem) -> some View {
        switch item {
        case .light(let entry):
            NavigationLink(value: entry) {
                LogEntryRow(entry: entry)
            }
            .buttonStyle(.plain)
        case .issue(let issue):
            NavigationLink(value: issue) {
                IssueCardView(issue: issue)
            }
            .buttonStyle(.plain)
        }
    }

    private var emptyState: some View {
        VStack(spacing: 10) {
            Image(systemName: "tray")
                .font(.system(size: 32))
                .foregroundStyle(ClusterTheme.Colors.textSecondary)
            Text("Nothing logged yet")
                .font(ClusterTheme.Types.body(15, weight: .semibold))
                .foregroundStyle(ClusterTheme.Colors.textPrimary)
            Text("Add an issue, or scan a warning light, to start building this vehicle's history.")
                .font(ClusterTheme.Types.body(13))
                .foregroundStyle(ClusterTheme.Colors.textSecondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 40)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 60)
    }

    private func daylabel(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d"
        return formatter.string(from: date).uppercased()
    }
}
