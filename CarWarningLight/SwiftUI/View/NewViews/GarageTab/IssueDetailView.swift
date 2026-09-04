//
//  IssueDetailView.swift
//  CarWarningLight
//
//  Created by Sam Greenhill on 8/17/26.
//  Copyright © 2026 simplyAmazingMachines. All rights reserved.
//

import SwiftUI
import SwiftData

struct IssueDetailView: View {
    @State private var viewModel: IssueDetailViewModel

    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext
    @FocusState private var noteFieldFocused: Bool

    private let columns = [GridItem(.flexible(), spacing: 10), GridItem(.flexible(), spacing: 10), GridItem(.flexible(), spacing: 10)]

    init(issue: VehicleIssue) {
        _viewModel = State(initialValue: IssueDetailViewModel(issue: issue))
    }

    var body: some View {
        VStack(spacing: 0) {
            ClusterHeaderBar(title: "Issue", icon: "chevron.left") { dismiss() }

            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    heroRow
                    resolvedControl

                    VStack(alignment: .leading, spacing: 10) {
                        Text("CATEGORIES")
                            .font(ClusterTheme.Types.mono(10, weight: .bold))
                            .tracking(1.2)
                            .foregroundStyle(ClusterTheme.Colors.textSecondary)
                            .padding(.horizontal)

                        LazyVGrid(columns: columns, spacing: 10) {
                            ForEach(IssueCategory.allCases) { category in
                                ClusterCategoryChip(
                                    icon: category.icon,
                                    label: category.label,
                                    isSelected: viewModel.issue.categories.contains(category)
                                ) {
                                    viewModel.toggleCategory(category)
                                }
                            }
                        }
                        .padding(.horizontal)
                    }

                    ClusterVehicleDiagramPicker(
                        vehicle: viewModel.issue.vehicle,
                        selectedZones: viewModel.markedZonesBinding
                    )
                    .padding(.horizontal)

                    VStack(alignment: .leading, spacing: 8) {
                        Text("NOTES FOR THE MECHANIC")
                            .font(ClusterTheme.Types.mono(10, weight: .bold))
                            .tracking(1.2)
                            .foregroundStyle(ClusterTheme.Colors.textSecondary)

                        TextEditor(text: Bindable(viewModel.issue).noteText)
                            .focused($noteFieldFocused)
                            .font(ClusterTheme.Types.body(15))
                            .foregroundStyle(ClusterTheme.Colors.textPrimary)
                            .scrollContentBackground(.hidden)
                            .frame(height: 120)
                            .padding(10)
                            .background(ClusterTheme.Colors.panel)
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(ClusterTheme.Colors.bezel, lineWidth: 1)
                            )
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                    }
                    .padding(.horizontal)

                    Button(role: .destructive) {
                        viewModel.requestDelete()
                    } label: {
                        Text("Delete Issue")
                            .font(ClusterTheme.Types.body(14, weight: .semibold))
                            .foregroundStyle(ClusterTheme.Colors.red)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 12)
                    }
                    .padding(.horizontal)
                }
                .padding(.top, 16)
                .padding(.bottom, 50)
            }
            .scrollDismissesKeyboard(.interactively)
        }
        .background(ClusterTheme.Colors.background)
        .contentShape(Rectangle())
        .onTapGesture { noteFieldFocused = false }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar(.hidden, for: .navigationBar)
        .toolbar {
            ToolbarItemGroup(placement: .keyboard) {
                Spacer()
                Button("Done") { noteFieldFocused = false }
                    .font(ClusterTheme.Types.body(15, weight: .semibold))
                    .foregroundStyle(ClusterTheme.Colors.amber)
            }
        }
        .alert("Delete this issue?", isPresented: $viewModel.showDeleteConfirm) {
            Button("Cancel", role: .cancel) { }
            Button("Delete", role: .destructive) {
                modelContext.delete(viewModel.issue)
                dismiss()
            }
        }
    }

    private var heroRow: some View {
        HStack(spacing: 14) {
            ClusterStackedIcon(
                icons: viewModel.issue.sortedCategories.map(\.icon),
                tint: ClusterTheme.Colors.amber,
                isDimmed: !viewModel.issue.isActive
            )

            VStack(alignment: .leading, spacing: 3) {
                Text(viewModel.issue.title)
                    .font(ClusterTheme.Types.display(18))
                    .foregroundStyle(ClusterTheme.Colors.textPrimary)
                Text("LOGGED \(viewModel.dateLabel.uppercased())")
                    .font(ClusterTheme.Types.mono(10, weight: .bold))
                    .tracking(1.0)
                    .foregroundStyle(ClusterTheme.Colors.textSecondary)
            }
            Spacer()
        }
        .padding(.horizontal)
    }

    private var resolvedControl: some View {
        ClusterStatusToggle(isActive: viewModel.issue.isActive) {
            viewModel.toggleResolved()
        }
        .padding(.horizontal)
    }
}

#Preview {
    IssueDetailView(issue: VehicleIssue(vehicle: Vehicle(name: "My Civic")))
}
