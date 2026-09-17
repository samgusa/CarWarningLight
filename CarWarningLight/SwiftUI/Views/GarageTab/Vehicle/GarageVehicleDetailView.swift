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
    @State private var showEditVehicle: Bool        = false

    @Environment(\.allLights) private var allLights

    @State private var viewModel                    = GarageVehicleDetailViewModel()
    @Namespace private var detailedNamespace

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
                        ForEach(viewModel.groupedTimeline(for: vehicle), id: \.day) { group in
                            VStack(alignment: .leading, spacing: 10) {
                                Text(viewModel.dayLabel(group.day))
                                    .font(ClusterTheme.Fonts.mono(11, weight: .bold))
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
                .padding(.bottom, 100)
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
        .navigationDestination(for: MaintenanceItem.self) { item in
            MaintenanceDetailView(item: item)
        }
        .sheet(isPresented: $viewModel.showAddIssue) {
            AddIssueView(vehicle: vehicle)
        }
        .sheet(isPresented: $viewModel.showAddMaintenance) {
            AddMaintenanceView(vehicle: vehicle)
        }
        .sheet(isPresented: $viewModel.showReportBuilder) {
            ReportBuilderView(vehicle: vehicle)
        }
        .sheet(isPresented: $showEditVehicle) {
            ClusterEditVehicleSheet(vehicle: vehicle)
        }
    }

    private var controlsRow: some View {
        HStack {
            Text(vehicle.name)
                .font(ClusterTheme.Fonts.mono(15, weight: .bold))
                .foregroundStyle(ClusterTheme.Colors.textPrimary)

            Spacer()

            ClusterSquareIconButton(icon: "doc.text.fill") {
                viewModel.showReportBuilder = true
            }
            .accessibilityLabel("Build a report")

            ClusterSquareIconButton(icon: "exclamationmark.triangle.fill") {
                viewModel.showAddIssue = true
            }
            .accessibilityLabel("Log an issue")

            ClusterSquareIconButton(icon: "wrench.and.screwdriver.fill") {
                viewModel.showAddMaintenance = true
            }
            .accessibilityLabel("Log maintenance")

            ClusterSquareIconButton(icon: "pencil") {
                showEditVehicle = true
            }
            .accessibilityLabel("Edit Vehicle")
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
        case .maintenance(let item):
            NavigationLink(value: item) {
                MaintenanceCardView(item: item)
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
                .font(ClusterTheme.Fonts.body(15, weight: .semibold))
                .foregroundStyle(ClusterTheme.Colors.textPrimary)
            Text("Add an issue, or scan a warning light, to start building this vehicle's history.")
                .font(ClusterTheme.Fonts.body(13))
                .foregroundStyle(ClusterTheme.Colors.textSecondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 40)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 60)
    }
}
