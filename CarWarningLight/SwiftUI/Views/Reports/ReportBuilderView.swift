//
//  ReportBuilderView.swift
//  CarWarningLight
//
//  Created by Sam Greenhill on 8/22/26.
//  Copyright © 2026 simplyAmazingMachines. All rights reserved.
//

import SwiftUI

struct ReportBuilderView: View {
    @State private var viewModel: ReportBuilderViewModel
    @State private var showContactFields: Bool           = false
    @Environment(\.dismiss) private var dismiss
    @Environment(\.allLights) private var allLights

    init(vehicle: Vehicle) {
        _viewModel = State(initialValue: ReportBuilderViewModel(vehicle: vehicle))
    }

    var body: some View {
        VStack(spacing: 0) {
            ClusterHeaderBar(title: "Build Report", icon: "chevron.left") { dismiss() }

            if viewModel.hasAnythingToReport {
                ScrollView {
                    VStack(alignment: .leading, spacing: 24) {
                        Text("Everything active is included by default. Tap anything to leave it out.")
                            .font(ClusterTheme.Fonts.body(12))
                            .foregroundStyle(ClusterTheme.Colors.textSecondary)
                            .padding(.horizontal)

                        contactSection
                        if !viewModel.activeLights.isEmpty { lightsSection }
                        if !viewModel.activeIssues.isEmpty { issuesSection }
                        if !viewModel.activeMaintenanceItems.isEmpty { maintenanceSection }
                    }
                    .padding(.top, 16)
                    .padding(.bottom, 110)
                }
                generateBar
            } else {
                emptyState
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        .background(ClusterTheme.Colors.background)
        .onAppear {
            viewModel.preselectAll()
        }
        .sheet(item: $viewModel.shareURL) { wrapped in
            QuickLookPreview(url: wrapped.url, title: wrapped.title)
                .ignoresSafeArea()
        }
    }

    private var lightsSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("WARNING LIGHTS")
                .font(ClusterTheme.Fonts.mono(11, weight: .bold))
                .tracking(1.2)
                .foregroundStyle(ClusterTheme.Colors.textSecondary)
                .padding(.horizontal)

            ForEach(viewModel.activeLights) { entry in
                lightRow(entry)
                    .padding(.horizontal)
            }
        }
    }

    private var contactSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Button {
                withAnimation(.easeInOut(duration: 0.2)) { showContactFields.toggle() }
            } label: {
                HStack(spacing: 6) {
                    Image(systemName: "person.text.rectangle")
                        .font(.system(size: 11, weight: .semibold))
                    Text(viewModel.contactName.isEmpty ? "ADD YOUR CONTACT INFO (OPTIONAL)" : "CONTACT INFO ADDED")
                        .font(ClusterTheme.Fonts.mono(10, weight: .bold))
                        .tracking(0.6)
                    Spacer()
                    Image(systemName: showContactFields ? "chevron.up" : "chevron.down")
                        .font(.system(size: 10, weight: .bold))
                }
                .foregroundStyle(viewModel.contactName.isEmpty ? ClusterTheme.Colors.textSecondary : ClusterTheme.Colors.amber)
            }
            .buttonStyle(.plain)

            if showContactFields {
                VStack(spacing: 8) {
                    TextField("Your name", text: $viewModel.contactName)
                    TextField("Phone or email", text: $viewModel.contactPhone)
                }
                .font(ClusterTheme.Fonts.body(14))
                .foregroundStyle(ClusterTheme.Colors.textPrimary)
                .padding(10)
                .background(ClusterTheme.Colors.panel)
                .clipShape(RoundedRectangle(cornerRadius: 8))
                Text("Only appears on the report if filled in — never shared otherwise.")
                    .font(ClusterTheme.Fonts.body(10))
                    .foregroundStyle(ClusterTheme.Colors.textSecondary)
            }
        }
        .padding(.horizontal)
    }

    private func lightRow(_ entry: LightLogEntry) -> some View {
        let isIncluded = viewModel.isLightIncluded(entry)
        let telltale = ClusterTheme.Colors.forSymbolType(entry.carSymbol.symbolType)

        return Button {
            viewModel.toggleLight(entry)
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
                    .font(ClusterTheme.Fonts.body(14, weight: .semibold))
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

    private var maintenanceSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("MAINTENANCE")
                .font(ClusterTheme.Fonts.mono(11, weight: .bold))
                .tracking(1.2)
                .foregroundStyle(ClusterTheme.Colors.textSecondary)
                .padding(.horizontal)

            ForEach(viewModel.activeMaintenanceItems) { item in
                maintenanceRow(item)
                    .padding(.horizontal)
            }
        }
    }

    private func maintenanceRow(_ item: MaintenanceItem) -> some View {
        let isIncluded = viewModel.isMaintenanceIncluded(item)

        return Button {
            viewModel.toggleMaintenance(item)
        } label: {
            HStack(spacing: 12) {
                Image(systemName: item.category.icon)
                    .font(.system(size: 15, weight: .semibold))
                    .foregroundStyle(isIncluded ? ClusterTheme.Colors.amber : ClusterTheme.Colors.textSecondary)
                    .frame(width: 36, height: 36)
                    .background(ClusterTheme.Colors.panel)
                    .clipShape(RoundedRectangle(cornerRadius: 8))

                Text(item.title)
                    .font(ClusterTheme.Fonts.body(14, weight: .semibold))
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
    }

    private var issuesSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("ISSUES")
                .font(ClusterTheme.Fonts.mono(11, weight: .bold))
                .tracking(1.2)
                .foregroundStyle(ClusterTheme.Colors.textSecondary)
                .padding(.horizontal)

            ForEach(viewModel.activeIssues) { issue in
                issueCard(issue)
                    .padding(.horizontal)
            }
        }
    }

    private func issueCard(_ issue: VehicleIssue) -> some View {
        let included = viewModel.includedCategories(for: issue)
        let isIncluded = viewModel.isIssueIncluded(issue)

        return VStack(alignment: .leading, spacing: 10) {
            Button {
                viewModel.toggleIssueIncluded(issue)
            } label: {
                HStack(spacing: 10) {
                    ClusterStackedIcon(icons: issue.sortedCategories.map(\.icon), tint: ClusterTheme.Colors.amber)
                        .opacity(isIncluded ? 1 : 0.4)
                    VStack(alignment: .leading, spacing: 2) {
                        Text(issue.displayTitle(allLights: allLights))
                            .font(ClusterTheme.Fonts.body(14, weight: .semibold))
                            .foregroundStyle(ClusterTheme.Colors.textPrimary)
                        Text(issue.dateCreated, style: .date)
                            .font(ClusterTheme.Fonts.mono(10, weight: .semibold))
                            .foregroundStyle(ClusterTheme.Colors.textSecondary)
                    }
                    Spacer()
                    Image(systemName: isIncluded ? "checkmark.square.fill" : "square")
                        .font(.system(size: 18))
                        .foregroundStyle(isIncluded ? ClusterTheme.Colors.amber : ClusterTheme.Colors.textSecondary)
                }
            }
            .buttonStyle(.plain)


            if !issue.sortedCategories.isEmpty {
                FlowChip(items: issue.sortedCategories) { category in
                    let isOn = included.contains(category)
                    Button {
                        viewModel.toggleCategory(category, for: issue)
                    } label: {
                        HStack(spacing: 4) {
                            Image(systemName: category.icon)
                                .font(.system(size: 10, weight: .semibold))
                            Text(category.label)
                                .font(ClusterTheme.Fonts.mono(10, weight: .semibold))
                        }
                        .padding(.horizontal, 9)
                        .padding(.vertical, 6)
                        .foregroundStyle(isOn ? ClusterTheme.Colors.background : ClusterTheme.Colors.textSecondary)
                        .background(isOn ? ClusterTheme.Colors.amber : ClusterTheme.Colors.bezel.opacity(0.5))
                        .clipShape(RoundedRectangle(cornerRadius: 6))
                    }
                    .buttonStyle(.plain)
                }
            }

            if !issue.noteText.isEmpty {
                Text(issue.noteText)
                    .font(ClusterTheme.Fonts.body(12))
                    .foregroundStyle(ClusterTheme.Colors.textSecondary)
                    .opacity(isIncluded ? 1 : 0.4)
            }
        }
        .padding(12)
        .clusterPanel()
        .opacity(isIncluded ? 1 : 0.6)
    }

    private var generateBar: some View {
        VStack {
            Button {
                viewModel.generateReport(allLights: allLights)
            } label: {
                HStack {
                    if viewModel.isGenerating {
                        ClusterGaugeLoader(color: ClusterTheme.Colors.background, size: 18)
                    } else {
                        Image(systemName: "doc.text.fill")
                    }
                    Text(viewModel.isGenerating ? "Building…" : "Generate Report (\(viewModel.selectedCount))")
                        .font(ClusterTheme.Fonts.body(16, weight: .bold))
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 14)
                .background(viewModel.selectedCount > 0 ? ClusterTheme.Colors.amber : ClusterTheme.Colors.bezel)
                .foregroundStyle(viewModel.selectedCount > 0 ? ClusterTheme.Colors.background : ClusterTheme.Colors.textSecondary)
                .clipShape(RoundedRectangle(cornerRadius: 10))
            }
            .disabled(viewModel.selectedCount == 0 || viewModel.isGenerating)
            .padding()
        }
        .background(ClusterTheme.Colors.panel)
    }

    private var emptyState: some View {
        VStack(spacing: 10) {
            Image(systemName: "doc.text")
                .font(.system(size: 32))
                .foregroundStyle(ClusterTheme.Colors.textSecondary)
            Text("Nothing active to report")
                .font(ClusterTheme.Fonts.body(15, weight: .semibold))
                .foregroundStyle(ClusterTheme.Colors.textPrimary)
            Text("Resolved items aren't included — log or reopen something first.")
                .font(ClusterTheme.Fonts.body(13))
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
