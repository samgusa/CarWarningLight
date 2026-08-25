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
    @State private var markedZones: Set<String> = []
    @FocusState private var noteFieldFocused: Bool

    private var isValid: Bool { !selectedCategories.isEmpty }

    private let columns = [GridItem(.flexible(), spacing: 10), GridItem(.flexible(), spacing: 10), GridItem(.flexible(), spacing: 10)]

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
                                ClusterCategoryChip(
                                    icon: category.icon,
                                    label: category.label,
                                    isSelected: selectedCategories.contains(category)) {

                                        if selectedCategories.contains(category) {
                                            selectedCategories.remove(category)
                                        } else {
                                            selectedCategories.insert(category)
                                        }
                                    }
                            }
                        }
                        .padding(.horizontal)
                    }

                    ClusterVehicleDiagramPicker(vehicle: vehicle, selectedZones: $markedZones)
                        .padding(.horizontal)

                    VStack(alignment: .leading, spacing: 8) {
                        Text("NOTES FOR THE MECHANIC")
                            .font(ClusterTheme.Types.mono(11, weight: .bold))
                            .tracking(1.2)
                            .foregroundStyle(ClusterTheme.Colors.textSecondary)

                        TextEditor(text: $noteText)
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

                    Button {
                        let issue = VehicleIssue(
                            vehicle: vehicle,
                            categories: selectedCategories,
                            noteText: noteText.trimmingCharacters(in: .whitespacesAndNewlines)
                        )
                        issue.markedZones = markedZones
                        modelContext.insert(issue)
                        dismiss()
                    } label: {
                        Text("Save Issue")
                            .font(ClusterTheme.Types.body(16, weight: .bold))
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 14)
                            .background(isValid ? ClusterTheme.Colors.amber : ClusterTheme.Colors.bezel)
                            .foregroundStyle(isValid ? ClusterTheme.Colors.background : ClusterTheme.Colors.textSecondary)
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                    }
                    .disabled(!isValid)
                    .padding(.horizontal)
                }
                .padding(.top, 16)
                .padding(.bottom, 24)
            }
            .scrollDismissesKeyboard(.interactively)
        }
        .background(ClusterTheme.Colors.background)
        .contentShape(Rectangle())
        .onTapGesture {
            noteFieldFocused = false
        }
        .toolbar {
            ToolbarItemGroup(placement: .keyboard) {
                Spacer()
                Button("Done") { noteFieldFocused = false }
                    .font(ClusterTheme.Types.body(15, weight: .semibold))
                    .foregroundStyle(ClusterTheme.Colors.amber)
            }
        }
    }
}

#Preview {
    AddIssueView(vehicle: Vehicle(name: "My Civic"))
}
