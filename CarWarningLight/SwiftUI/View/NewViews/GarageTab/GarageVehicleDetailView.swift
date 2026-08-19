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

    @Environment(\.modelContext) private var modelContext
    @Query(sort: \Vehicle.dateCreated) private var allVehicles: [Vehicle]

    @State private var showAddIssue: Bool = false
    @Namespace private var detailedNamespace

    private var groupedTimeline: [(day: Date, items: [GarageTimelineItem])] {
        let calendar = Calendar.current
        let grouped = Dictionary(grouping: vehicle.timelineItems) { calendar.startOfDay(for: $0.date) }
        return grouped
            .sorted { $0.key > $1.key }
            .map { (day: $0.key, items: $0.value.sorted { $0.date > $1.date }) }
    }


    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                header

                if vehicle.totalActive > 0 {
                    activeBanner
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
            .padding(.bottom, 24)
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
                onToggleResolved: { entry.isActive.toggle() }
            )
        }
        .navigationDestination(for: VehicleIssue.self) { issue in
            IssueDetailView(issue: issue)
        }
        .sheet(isPresented: $showAddIssue) {
            AddIssueView(vehicle: vehicle)
        }
    }

    private var header: some View {
        HStack {
            Menu {
                ForEach(allVehicles) { candidate in
                    if candidate.id == vehicle.id {
                        Label(candidate.name, systemImage: "checkmark")
                    } else {
                        // Pushes a new detail screen for the chosen vehicle,
                        // reusing the navigationDestination(for: Vehicle.self)
                        // declared up in ClusterGarageView.
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
                .clipShape(Capsule())
                .overlay(Capsule().stroke(ClusterTheme.Colors.bezel, lineWidth: 1))
            }

            Spacer()

            Button {
                showAddIssue = true
            } label: {
                Image(systemName: "plus")
                    .font(.system(size: 14, weight: .bold))
                    .foregroundStyle(ClusterTheme.Colors.background)
                    .frame(width: 32, height: 32)
                    .background(ClusterTheme.Colors.amber)
                    .clipShape(Circle())
            }
            .accessibilityLabel("Log an issue")
        }
        .padding(.horizontal)
        .padding(.top, 16)
    }

    private var activeBanner: some View {
        HStack(spacing: 12) {
            ZStack {
                Circle()
                    .fill(ClusterTheme.Colors.amber.opacity(0.18))
                Image(systemName: "eye")
                    .font(.system(size: 15, weight: .semibold))
                    .foregroundStyle(ClusterTheme.Colors.amber)
            }
            .frame(width: 40, height: 40)

            VStack(alignment: .leading, spacing: 2) {
                Text("\(vehicle.totalActive) thing\(vehicle.totalActive == 1 ? "" : "s") to keep an eye on")
                    .font(ClusterTheme.Types.body(14, weight: .bold))
                    .foregroundStyle(ClusterTheme.Colors.textPrimary)
                Text("Tap any entry for details, or mark it resolved")
                    .font(ClusterTheme.Types.body(12))
                    .foregroundStyle(ClusterTheme.Colors.textSecondary)
            }
            Spacer(minLength: 0)
        }
        .padding(14)
        .background(ClusterTheme.Colors.amber.opacity(0.08))
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(ClusterTheme.Colors.amber.opacity(0.35), lineWidth: 1)
        )
        .clipShape(RoundedRectangle(cornerRadius: 12))
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

//#Preview {
//    GarageVehicleDetailView()
//}
