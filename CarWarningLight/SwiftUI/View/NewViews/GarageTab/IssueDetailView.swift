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

    private let columns = [GridItem(.flexible(), spacing: 10), GridItem(.flexible(), spacing: 10)]


    private var dateLabel: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter.string(from: issue.dateCreated)
    }

    var body: some View {
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
                            categoryChip(category)
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
        .background(ClusterTheme.Colors.background)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar(.hidden, for: .navigationBar)
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
            ZStack {
                Circle()
                    .fill(ClusterTheme.Colors.amber)
                    .frame(width: 60, height: 60)
                    .blur(radius: 18)
                    .opacity(0.5)

                Image(systemName: issue.sortedCategories.first?.icon ?? "exclamationmark.circle")
                    .font(.system(size: 26, weight: .semibold))
                    .foregroundStyle(ClusterTheme.Colors.amber)
            }

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
        Button {
            issue.isActive.toggle()
        } label: {
            HStack {
                Image(systemName: issue.isActive ? "checkmark.circle.fill" : "arrow.uturn.backward.circle.fill")

                Text(issue.isActive ? "Mark as Resolved" : "Mark Active Again")
                    .font(ClusterTheme.Types.body(14, weight: .bold))
                Spacer()
                Text(issue.isActive ? "ACTIVE" : "RESOLVED")
                    .font(ClusterTheme.Types.mono(10, weight: .bold))
                    .tracking(1)
            }
            .foregroundStyle(issue.isActive ? ClusterTheme.Colors.background : ClusterTheme.Colors.textPrimary)
            .padding(14)
            .background(issue.isActive ? ClusterTheme.Colors.green : ClusterTheme.Colors.panel)
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(issue.isActive ? .clear : ClusterTheme.Colors.bezel, lineWidth: 1)
            )
            .clipShape(RoundedRectangle(cornerRadius: 10))
        }
        .buttonStyle(.plain)
        .padding(.horizontal)
    }

    private func categoryChip(_ category: IssueCategory) -> some View {
        let isSelected = issue.categories.contains(category)
        return Button {
            var updated = issue.categories
            if isSelected { updated.remove(category) } else { updated.insert(category) }
            issue.categories = updated
        } label: {
            HStack(spacing: 8) {
                Image(systemName: category.icon)
                    .font(.system(size: 13, weight: .semibold))
                Text(category.label)
                    .font(ClusterTheme.Types.body(13, weight: .semibold))
                Spacer(minLength: 0)
            }
            .foregroundStyle(isSelected ? ClusterTheme.Colors.background : ClusterTheme.Colors.textPrimary)
            .padding(.horizontal, 12)
            .padding(.vertical, 12)
            .frame(maxWidth: .infinity)
            .background(isSelected ? ClusterTheme.Colors.amber : ClusterTheme.Colors.panel)
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(isSelected ? .clear : ClusterTheme.Colors.bezel, lineWidth: 1)
            )
            .clipShape(RoundedRectangle(cornerRadius: 10))
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    IssueDetailView(issue: VehicleIssue(vehicle: Vehicle(name: "My Civic")))
}
