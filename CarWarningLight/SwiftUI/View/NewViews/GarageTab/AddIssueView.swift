//
//  AddIssueView.swift
//  CarWarningLight
//
//  Created by Sam Greenhill on 8/17/26.
//  Copyright © 2026 simplyAmazingMachines. All rights reserved.
//

import SwiftUI
import SwiftData

struct AddIssueView: View {
    let vehicle: Vehicle

    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext

    @State private var selectedCategories: Set<IssueCategory> = []
    @State private var noteText: String = ""

    private var isValid: Bool { !selectedCategories.isEmpty }

    private let columns = [GridItem(.flexible(), spacing: 10), GridItem(.flexible(), spacing: 10)]

    var body: some View {
        VStack(spacing: 0) {
            ClusterHeaderBar(title: "Log an Issue") { dismiss() }

            ScrollView {
                VStack(alignment: .leading, spacing: 10) {
                    VStack(alignment: .leading, spacing: 10) {
                        Text("WHAT'S GOING ON?")
                            .font(ClusterTheme.Types.mono(11, weight: .bold))
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
                            .font(ClusterTheme.Types.mono(11, weight: .bold))
                            .tracking(1.2)
                            .foregroundStyle(ClusterTheme.Colors.textSecondary)

                        TextEditor(text: $noteText)
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

                    Button {
                        let issue = VehicleIssue(
                            vehicle: vehicle,
                            categories: selectedCategories,
                            noteText: noteText.trimmingCharacters(in: .whitespacesAndNewlines)
                        )
                        modelContext.insert(issue)
                        dismiss()
                    } label: {
                        Text("Save Issue")
                            .font(ClusterTheme.Types.body(16, weight: .bold))
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 14)
                            .background(isValid ? ClusterTheme.Colors.amber : ClusterTheme.Colors.bezel)
                            .foregroundStyle(isValid ? ClusterTheme.Colors.background : ClusterTheme.Colors.textSecondary)
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                    }
                    .disabled(!isValid)
                    .padding(.horizontal)
                }
                .padding(.top, 16)
                .padding(.bottom, 24)
            }
        }
        .background(ClusterTheme.Colors.background)
    }

    private func categoryChip(_ category: IssueCategory) -> some View {
        let isSelected = selectedCategories.contains(category)
        return Button {
            if isSelected {
                selectedCategories.remove(category)
            } else {
                selectedCategories.insert(category)
            }
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
    AddIssueView(vehicle: Vehicle(name: "My Civic"))
}
