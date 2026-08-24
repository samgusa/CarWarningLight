//
//  ReportBuilderView.swift
//  CarWarningLight
//
//  Created by Sam Greenhill on 8/22/26.
//  Copyright © 2026 simplyAmazingMachines. All rights reserved.
//

import SwiftUI

struct ReportBuilderView: View {
    let vehicle: Vehicle
    @Environment(\.dismiss) private var dismiss

    @State private var includedLightIDs: Set<UUID>                              = []
    @State private var includedCategoriesByIssue: [UUID: Set<IssueCategory>]    = [:]
    @State private var isGenerating: Bool                                       = false
    @State private var shareURL: IdentifiableURL?

    private var activeLights: [LightLogEntry] {
        vehicle.activeLightEntries.sorted { $0.dateLogged > $1.dateLogged }
    }

    private var activeIssues: [VehicleIssue] {
        vehicle.activeIssues.sorted { $0.dateCreated > $1.dateCreated }
    }
    private var hasAnythingToReport: Bool {
        !activeLights.isEmpty || !activeIssues.isEmpty
    }
    private var selectedCount: Int {
        includedLightIDs.count + includedCategoriesByIssue.values.filter { !$0.isEmpty }.count
    }

    var body: some View {
        VStack(spacing: 0) {
            ClusterHeaderBar(title: "Build Report", icon: "chevron.left") { dismiss() }

            if hasAnythingToReport {
                ScrollView {
                    VStack(alignment: .leading, spacing: 24) {
                        Text("Everything active is included by default. Tap anything to leave it out.")
                            .font(ClusterTheme.Types.body(12))
                            .foregroundStyle(ClusterTheme.Colors.textSecondary)
                            .padding(.horizontal)

                        if !activeLights.isEmpty { lightsSection }
                        if !activeIssues.isEmpty { issuesSection }
                    }
                    .padding(.top, 16)
                    .padding(.bottom, 110)
                }
                generateBar
            } else {
                emptyState
            }
        }
        .background(ClusterTheme.Colors.background)
        .onAppear {
            preselectAll()
        }
        .sheet(item: $shareURL) { wrapped in
            ShareSheet(activityItems: [wrapped.url])
        }
    }

    private func preselectAll() {
        includedLightIDs = Set(activeLights.map(\.id))
        includedCategoriesByIssue = Dictionary(uniqueKeysWithValues: activeIssues.map { ($0.id, $0.categories) })
    }

    private var lightsSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("WARNING LIGHTS")
                .font(ClusterTheme.Types.mono(11, weight: .bold))
                .tracking(1.2)
                .foregroundStyle(ClusterTheme.Colors.textSecondary)
                .padding(.horizontal)

            ForEach(activeLights) { entry in
                lightRow(entry)
                    .padding(.horizontal)
            }
        }
    }

    private func lightRow(_ entry: LightLogEntry) -> some View {
        let isIncluded = includedLightIDs.contains(entry.id)
        let telltale = ClusterTheme.Colors.forSymbolType(entry.carSymbol.symbolType)

        return Button {
            if isIncluded { includedLightIDs.remove(entry.id) } else { includedLightIDs.insert(entry.id) }
        } label: {
            HStack(spacing: 12) {
                Image(entry.carSymbol.imageName)
                    .resizable()
                    .renderingMode(.template)
                    .scaledToFit()
                    .frame(width: 20, height: 20)
                    .foregroundStyle(isIncluded ? telltale : ClusterTheme.Colors.textSecondary)
                    .frame(width: 36, height: 36)
                    .background(ClusterTheme.Colors.panel)
                    .clipShape(RoundedRectangle(cornerRadius: 8))

                Text(entry.carSymbol.name)
                    .font(ClusterTheme.Types.body(14, weight: .semibold))
                    .foregroundStyle(ClusterTheme.Colors.textPrimary)

                Spacer()

                Image(systemName: isIncluded ? "checkmark.square.fill" : "square")
                    .font(.system(size: 18))
                    .foregroundStyle(isIncluded ? ClusterTheme.Colors.amber : ClusterTheme.Colors.textSecondary)
            }
            .padding(12)
            .clusterPanel()
            .opacity(isIncluded ? 1 : 0.45)
        }
        .buttonStyle(.plain)
    }

    private var issuesSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("ISSUES")
                .font(ClusterTheme.Types.mono(11, weight: .bold))
                .tracking(1.2)
                .foregroundStyle(ClusterTheme.Colors.textSecondary)
                .padding(.horizontal)

            ForEach(activeIssues) { issue in
                issueCard(issue)
                    .padding(.horizontal)
            }
        }
    }

    private func issueCard(_ issue: VehicleIssue) -> some View {
        let included = includedCategoriesByIssue[issue.id] ?? []
        let anyIncluded = !included.isEmpty

        return VStack(alignment: .leading, spacing: 10) {
            HStack(spacing: 10) {
                ClusterStackedIcon(icons: issue.sortedCategories.map(\.icon), tint: ClusterTheme.Colors.amber)
                    .opacity(anyIncluded ? 1 : 0.4)
                VStack(alignment: .leading, spacing: 2) {
                    Text(issue.title)
                        .font(ClusterTheme.Types.body(14, weight: .semibold))
                        .foregroundStyle(ClusterTheme.Colors.textPrimary)
                    Text(issue.dateCreated, style: .date)
                        .font(ClusterTheme.Types.mono(10, weight: .semibold))
                        .foregroundStyle(ClusterTheme.Colors.textSecondary)
                }
                Spacer()
            }
            FlowChip(items: issue.sortedCategories) { category in
                let isOn = included.contains(category)
                Button {
                    var updated = included
                    if isOn { updated.remove(category) } else { updated.insert(category) }
                    includedCategoriesByIssue[issue.id] = updated
                } label: {
                    HStack(spacing: 4) {
                        Image(systemName: category.icon)
                            .font(.system(size: 10, weight: .semibold))
                        Text(category.label)
                            .font(ClusterTheme.Types.mono(10, weight: .semibold))
                    }
                    .padding(.horizontal, 9)
                    .padding(.vertical, 6)
                    .foregroundStyle(isOn ? ClusterTheme.Colors.background : ClusterTheme.Colors.textSecondary)
                    .background(isOn ? ClusterTheme.Colors.amber : ClusterTheme.Colors.bezel.opacity(0.5))
                    .clipShape(RoundedRectangle(cornerRadius: 6))
                }
                .buttonStyle(.plain)
            }

            if !issue.noteText.isEmpty {
                Text(issue.noteText)
                    .font(ClusterTheme.Types.body(12))
                    .foregroundStyle(ClusterTheme.Colors.textSecondary)
                    .opacity(anyIncluded ? 1 : 0.4)
            }
        }
        .padding(12)
        .clusterPanel()
    }

    private var generateBar: some View {
        VStack {
            Button {
                generateReport()
            } label: {
                HStack {
                    if isGenerating {
                        ClusterGaugeLoader(color: ClusterTheme.Colors.background, size: 18)
                    } else {
                        Image(systemName: "doc.text.fill")
                    }
                    Text(isGenerating ? "Building…" : "Generate Report (\(selectedCount))")
                        .font(ClusterTheme.Types.body(16, weight: .bold))
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 14)
                .background(selectedCount > 0 ? ClusterTheme.Colors.amber : ClusterTheme.Colors.bezel)
                .foregroundStyle(selectedCount > 0 ? ClusterTheme.Colors.background : ClusterTheme.Colors.textSecondary)
                .clipShape(RoundedRectangle(cornerRadius: 10))
            }
            .disabled(selectedCount == 0 || isGenerating)
            .padding()
        }
        .background(ClusterTheme.Colors.panel)
    }

    private func generateReport() {
        isGenerating = true
        let lights = activeLights.filter { includedLightIDs.contains($0.id) }
        let issueEntries: [ReportDocumentView.IssueEntry] = activeIssues.compactMap { issue in
            guard let categories = includedCategoriesByIssue[issue.id], !categories.isEmpty else { return nil }

            let ordered = IssueCategory.allCases.filter { categories.contains($0) }
            return ReportDocumentView.IssueEntry(issue: issue, categories: ordered)
        }

        let document = ReportDocumentView(vehicle: vehicle, lights: lights, issueEntries: issueEntries)

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {
            if let url = ReportPDFGenerator.generate(from: document) {
                shareURL = IdentifiableURL(url: url)
            }
            isGenerating = false
        }
    }

    private var emptyState: some View {
        VStack(spacing: 10) {
            Image(systemName: "doc.text")
                .font(.system(size: 32))
                .foregroundStyle(ClusterTheme.Colors.textSecondary)
            Text("Nothing active to report")
                .font(ClusterTheme.Types.body(15, weight: .semibold))
                .foregroundStyle(ClusterTheme.Colors.textPrimary)
            Text("Resolved items aren't included — log or reopen something first.")
                .font(ClusterTheme.Types.body(13))
                .foregroundStyle(ClusterTheme.Colors.textSecondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 40)
        }
        .frame(maxWidth: .infinity)
        .padding(.top, 80)
    }
}

#Preview {
    ReportBuilderView(vehicle: Vehicle(name: "My Civic"))
}
