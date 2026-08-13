//
//  ClusterTripLogView.swift
//  CarWarningLight
//
//  Created by Sam Greenhill on 7/27/26.
//  Copyright © 2026 simplyAmazingMachines. All rights reserved.
//

import SwiftUI

struct ClusterTripLogView: View {
    @Binding var isScrolledDown: Bool
    let entries: [LightLogEntry]
    var onAddLight: () -> Void = { }
    var onSelect: (LightLogEntry) -> Void = { _ in }

    private var active: [LightLogEntry] { entries.filter(\.isActive).sorted { $0.dateLogged > $1.dateLogged }}

    private var resolved: [LightLogEntry] { entries.filter { !$0.isActive }.sorted { $0.dateLogged > $1.dateLogged }}

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                header

                if entries.isEmpty {
                    emptyState
                } else {
                    if !active.isEmpty {
                        section(title: "ACTIVE", entries: active)
                    }
                    if !resolved.isEmpty {
                        section(title: "RESOLVED", entries: resolved)
                    }
                }
            }
            .padding(.bottom, 24)
        }
        .trackScrollOffset(isScrolledDown: $isScrolledDown)
        .background(ClusterTheme.Colors.background)
    }

    private var header: some View {
        HStack(alignment: .top) {
            VStack(alignment: .leading, spacing: 2) {
                Text("Trip Log")
                    .font(ClusterTheme.Types.display(24))
                    .foregroundStyle(ClusterTheme.Colors.textPrimary)
                Text("\(entries.count) light\(entries.count == 1 ? "" : "s") logged")
                    .font(ClusterTheme.Types.body(13))
                    .foregroundStyle(ClusterTheme.Colors.textSecondary)
            }
            Spacer()
            Button(action: onAddLight) {
                Image(systemName: "plus")
                    .font(.system(size: 14, weight: .bold))
                    .foregroundStyle(ClusterTheme.Colors.background)
                    .frame(width: 32, height: 32)
                    .background(ClusterTheme.Colors.amber)
                    .clipShape(Circle())
            }
            .accessibilityLabel("Add a Light")
        }
        .padding(.horizontal)
        .padding(.top, 20)
    }

    private var emptyState: some View {
        VStack(spacing: 10) {
            Image(systemName: "tray")
                .font(.system(size: 32))
                .foregroundStyle(ClusterTheme.Colors.textSecondary)
            Text("Nothing logged yet")
                .font(ClusterTheme.Types.body(15, weight: .semibold))
                .foregroundStyle(ClusterTheme.Colors.textPrimary)
            Text("Lights you identify will show up here.")
                .font(ClusterTheme.Types.body(13))
                .foregroundStyle(ClusterTheme.Colors.textSecondary)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 60)
    }

    private func section(title: String, entries: [LightLogEntry]) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(title)
                .font(ClusterTheme.Types.mono(11, weight: .bold))
                .tracking(1.5)
                .foregroundStyle(ClusterTheme.Colors.textSecondary)
                .padding(.horizontal)

            ForEach(entries) { entry in
                LogEntryRow(entry: entry)
                    .padding(.horizontal)
                    .onTapGesture { onSelect(entry) }
            }
        }
    }
}

#Preview {
    let sampleEngine = CarSymbol(
        id: 1, name: "Check Engine Light", imageName: "Check Engine Light",
        description: "", symbolType: .warning, fixDescription: "", drivable: .no, categories: nil
    )
    let sampleBattery = CarSymbol(
        id: 2, name: "Battery Charging Light", imageName: "Battery Charging Light",
        description: "", symbolType: .warning, fixDescription: "", drivable: .uncertain, categories: nil
    )
    let sampleTire = CarSymbol(
        id: 3, name: "Tire Pressure Warning Light", imageName: "Tire Pressure Warning Light",
        description: "", symbolType: .advisory, fixDescription: "", drivable: .yes, categories: nil
    )
    return ClusterTripLogView(
        isScrolledDown: .constant(false),
        entries: [
        LightLogEntry(
            carSymbol: sampleEngine,
            dateLogged: Date().addingTimeInterval(-3600)),
        LightLogEntry(
            carSymbol: sampleTire,
            dateLogged: Date().addingTimeInterval(-86400 * 2)),
        LightLogEntry(
            carSymbol: sampleBattery,
            dateLogged: Date().addingTimeInterval(-86400 * 9),
            isActive: false)
    ]
    )
}
