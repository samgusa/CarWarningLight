//
//  AddMaintenanceView.swift
//  CarWarningLight
//
//  Created by Sam Greenhill on 9/13/26.
//  Copyright © 2026 simplyAmazingMachines. All rights reserved.
//

import SwiftUI
import SwiftData

struct AddMaintenanceView: View {
    let vehicle: Vehicle

    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext

    @State private var viewModel = AddMaintenanceViewModel()
    @State private var showCamera: Bool = false

    private enum Field: Hashable { case note, mileage }
    @FocusState private var focusedField: Field?

    private let columns = [GridItem(.flexible(), spacing: 10), GridItem(.flexible(), spacing: 10), GridItem(.flexible(), spacing: 10)]

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                ClusterHeaderBar(title: "Log Maintenance") { dismiss() }

                ScrollView {
                    VStack(alignment: .leading, spacing: 18) {
                        VStack(alignment: .leading, spacing: 10) {
                            Text("WHAT NEEDS ATTENTION?")
                                .font(ClusterTheme.Fonts.mono(11, weight: .bold))
                                .tracking(1.2)
                                .foregroundStyle(ClusterTheme.Colors.textSecondary)
                                .padding(.horizontal)

                            LazyVGrid(columns: columns, spacing: 10) {
                                ForEach(MaintenanceCategory.allCases) { category in
                                    ClusterCategoryChip(
                                        icon: category.icon,
                                        label: category.label,
                                        isSelected: viewModel.selectedCategory == category) {
                                            viewModel.selectedCategory = category
                                        }
                                }
                            }
                            .padding(.horizontal)
                        }
                        optionalSection

                        VStack(alignment: .leading, spacing: 8) {
                            Text("NOTES FOR THE MECHANIC")
                                .font(ClusterTheme.Fonts.mono(11, weight: .bold))
                                .tracking(1.2)
                                .foregroundStyle(ClusterTheme.Colors.textSecondary)

                            Text("No need to guess a part number or size — your vehicle's year, make, model and VIN can be included in the report.")
                                .font(ClusterTheme.Fonts.body(11))
                                .foregroundStyle(ClusterTheme.Colors.textSecondary.opacity(0.8))

                            ClusterPhotoAttachmentButton(
                                image: viewModel.capturedPhoto,
                                onCapture: { showCamera = true },
                                onRemove: { viewModel.capturedPhoto = nil }
                            )

                            TextEditor(text: $viewModel.noteText)
                                .focused($focusedField, equals: .note)
                                .font(ClusterTheme.Fonts.body(15))
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
                            guard let item = viewModel.buildItem(for: vehicle) else { return }
                            modelContext.insert(item)
                            dismiss()
                        } label: {
                            Text("Save")
                                .font(ClusterTheme.Fonts.body(16, weight: .bold))
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
            .fullScreenCover(isPresented: $showCamera) {
                CameraView(cropsToFocusSquare: false) { image in
                    viewModel.capturedPhoto = image
                    showCamera = false
                }
            }
            .onTapGesture {
                focusedField = nil
            }
            .toolbar {
                ToolbarItemGroup(placement: .keyboard) {
                    Spacer()
                    Button("Done") {
                        focusedField = nil
                    }
                    .font(ClusterTheme.Fonts.body(15, weight: .semibold))
                    .foregroundStyle(ClusterTheme.Colors.amber)
                }
            }
            .toolbar(.hidden, for: .navigationBar)
        }
    }

    private var optionalSection: some View {
        HStack(spacing: 10) {
            Text("MILEAGE")
                .font(ClusterTheme.Fonts.mono(11, weight: .bold))
                .tracking(1.2)
                .foregroundStyle(ClusterTheme.Colors.textSecondary)

            TextField("Optional", text: $viewModel.mileageText)
                .focused($focusedField, equals: .mileage)
                .keyboardType(.numberPad)
                .font(ClusterTheme.Fonts.body(14))
                .foregroundStyle(ClusterTheme.Colors.textPrimary)
                .multilineTextAlignment(.trailing)

            ClusterSegmentedToggle(options: DistanceUnit.allCases, selection: $viewModel.mileageUnit) { $0.abbreviation }
        }
        .padding(12)
        .clusterPanel()
        .padding(.horizontal)
    }
}

#Preview {
    AddMaintenanceView(vehicle: Vehicle(name: "My Civic"))
}
