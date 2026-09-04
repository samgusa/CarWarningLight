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

    @State private var viewModel                    = AddIssueViewModel()
    @State private var showCamera: Bool             = false
    @FocusState private var noteFieldFocused: Bool

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
                                    isSelected: viewModel.selectedCategories.contains(category)) {
                                        viewModel.toggleCategory(category)
                                    }
                            }
                        }
                        .padding(.horizontal)
                    }

                    optionalSection

                    ClusterVehicleDiagramPicker(vehicle: vehicle, selectedZones: $viewModel.markedZones)
                        .padding(.horizontal)

                    VStack(alignment: .leading, spacing: 8) {
                        Text("NOTES FOR THE MECHANIC")
                            .font(ClusterTheme.Types.mono(11, weight: .bold))
                            .tracking(1.2)
                            .foregroundStyle(ClusterTheme.Colors.textSecondary)

                        Spacer()

                        ClusterPhotoAttachmentButton(
                            image: viewModel.capturedPhoto,
                            onCapture: { showCamera = true},
                            onRemove: { viewModel.capturedPhoto = nil }
                        )

                        TextEditor(text: $viewModel.noteText)
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
                        guard let issue = viewModel.buildIssue(for: vehicle) else { return }
                        modelContext.insert(issue)
                        dismiss()
                    } label: {
                        Text("Save Issue")
                            .font(ClusterTheme.Types.body(16, weight: .bold))
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 14)
                            .background(viewModel.isValid ? ClusterTheme.Colors.amber : ClusterTheme.Colors.bezel)
                            .foregroundStyle(viewModel.isValid ? ClusterTheme.Colors.background : ClusterTheme.Colors.textSecondary)
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                    }
                    .disabled(!viewModel.isValid)
                    .padding(.horizontal)
                }
                .padding(.top, 16)
                .padding(.bottom, 24)
            }
            .scrollDismissesKeyboard(.interactively)
        }
        .background(ClusterTheme.Colors.background)
        .contentShape(Rectangle())
        .fullScreenCover(isPresented: $showCamera, content: {
            CameraView { image in
                viewModel.capturedPhoto = image
                showCamera = false
            }
        })
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

    private var optionalSection: some View {
        HStack(spacing: 10) {
            Text("MILEAGE")
                .font(ClusterTheme.Types.mono(11, weight: .bold))
                .tracking(1.2)
                .foregroundStyle(ClusterTheme.Colors.textSecondary)
            TextField("Optional", text: $viewModel.mileageText)
                .keyboardType(.numberPad)
                .font(ClusterTheme.Types.body(14))
                .foregroundStyle(ClusterTheme.Colors.textPrimary)
                .multilineTextAlignment(.trailing)
        }
        .padding(12)
        .clusterPanel()
        .padding(.horizontal)
    }
}

#Preview {
    AddIssueView(vehicle: Vehicle(name: "My Civic"))
}
