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
    @Bindable var issue: VehicleIssue

    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext
    @State private var showDeleteConfirm: Bool = false
    @FocusState private var noteFieldFocused: Bool

    private let columns = [GridItem(.flexible(), spacing: 10), GridItem(.flexible(), spacing: 10), GridItem(.flexible(), spacing: 10)]

    private var dateLabel: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter.string(from: issue.dateCreated)
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
                                    isSelected: issue.categories.contains(category)
                                ) {
                                    var updated = issue.categories
                                    if updated.contains(category) { updated.remove(category) } else { updated.insert(category) }
                                    issue.categories = updated
                                }
                            }
                        }
                        .padding(.horizontal)
                    }

                    VStack(alignment: .leading, spacing: 8) {
                        Text("NOTES FOR THE MECHANIC")
                            .font(ClusterTheme.Types.mono(10, weight: .bold))
                            .tracking(1.2)
                            .foregroundStyle(ClusterTheme.Colors.textSecondary)

                        TextEditor(text: $issue.noteText)
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
                        showDeleteConfirm = true
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
                .padding(.bottom, 24)
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
        .alert("Delete this issue?", isPresented: $showDeleteConfirm) {
            Button("Cancel", role: .cancel) { }
            Button("Delete", role: .destructive) {
                modelContext.delete(issue)
                dismiss()
            }
        }
    }

    private var heroRow: some View {
        HStack(spacing: 14) {
            ClusterStackedIcon(
                icons: issue.sortedCategories.map(\.icon),
                tint: ClusterTheme.Colors.amber,
                isDimmed: !issue.isActive
            )

            VStack(alignment: .leading, spacing: 3) {
                Text(issue.title)
                    .font(ClusterTheme.Types.display(18))
                    .foregroundStyle(ClusterTheme.Colors.textPrimary)
                Text("LOGGED \(dateLabel.uppercased())")
                    .font(ClusterTheme.Types.mono(10, weight: .bold))
                    .tracking(1.0)
                    .foregroundStyle(ClusterTheme.Colors.textSecondary)
            }
            Spacer()
        }
        .padding(.horizontal)
    }

    private var resolvedControl: some View {
        ClusterStatusToggle(isActive: issue.isActive) {
            issue.isActive.toggle()
        }
        .padding(.horizontal)
    }
}

#Preview {
    IssueDetailView(issue: VehicleIssue(vehicle: Vehicle(name: "My Civic")))
}
