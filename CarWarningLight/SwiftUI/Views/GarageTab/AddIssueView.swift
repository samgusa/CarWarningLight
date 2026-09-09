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
    @State private var showLightPicker: Bool        = false
    @Environment(\.allLights) private var allLights
    @FocusState private var noteFieldFocused: Bool
    @FocusState private var mileageFieldFocused: Bool

    private let columns = [GridItem(.flexible(), spacing: 10), GridItem(.flexible(), spacing: 10), GridItem(.flexible(), spacing: 10)]

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                ClusterHeaderBar(title: "Log an Issue") { dismiss() }

                ScrollView {
                    VStack(alignment: .leading, spacing: 18) {
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

                        relatedLightsSection

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
            .sheet(isPresented: $showLightPicker, content: {
                ClusterLightTagPicker(selectedIDs: $viewModel.linkedLightSymbolIDs)
            })
            .fullScreenCover(isPresented: $showCamera, content: {
                CameraView { image in
                    viewModel.capturedPhoto = image
                    showCamera = false
                }
            })
            .onTapGesture {
                noteFieldFocused        = false
                mileageFieldFocused     = false
            }
            .toolbar {
                ToolbarItemGroup(placement: .keyboard) {
                    Spacer()
                    Button("Done") {
                        noteFieldFocused        = false
                        mileageFieldFocused     = false
                    }
                        .font(ClusterTheme.Types.body(15, weight: .semibold))
                        .foregroundStyle(ClusterTheme.Colors.amber)
                }
            }
            .toolbar(.hidden, for: .navigationBar)
        }
    }

    private var optionalSection: some View {
        HStack(spacing: 10) {
            Text("MILEAGE")
                .font(ClusterTheme.Types.mono(11, weight: .bold))
                .tracking(1.2)
                .foregroundStyle(ClusterTheme.Colors.textSecondary)

            TextField("Optional", text: $viewModel.mileageText)
                .focused($mileageFieldFocused)
                .keyboardType(.numberPad)
                .font(ClusterTheme.Types.body(14))
                .foregroundStyle(ClusterTheme.Colors.textPrimary)
                .multilineTextAlignment(.trailing)

            ClusterSegmentedToggle(options: DistanceUnit.allCases, selection: $viewModel.mileageUnit) { $0.abbreviation }
        }
        .padding(12)
        .clusterPanel()
        .padding(.horizontal)
    }

    private var relatedLightsSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Text("RELATED WARNING LIGHTS")
                    .font(ClusterTheme.Types.mono(11, weight: .bold))
                    .tracking(1.2)
                    .foregroundStyle(ClusterTheme.Colors.textSecondary)
                Spacer()

                Button {
                    showLightPicker = true
                } label: {
                    HStack(spacing: 4) {
                        Image(systemName: "plus")
                            .font(.system(size: 10, weight: .bold))
                        Text("ADD")
                            .font(ClusterTheme.Types.mono(10, weight: .bold))
                    }
                    .foregroundStyle(ClusterTheme.Colors.amber)
                }
                .buttonStyle(.plain)
            }

            if !viewModel.linkedLightSymbolIDs.isEmpty {
                FlowChip(items: Array(viewModel.linkedLightSymbolIDs).sorted()) { id in
                    if let light = allLights.first(where: { $0.id == id }) {
                        Button {
                            viewModel.linkedLightSymbolIDs.remove(id)
                        } label: {
                            HStack(spacing: 4) {
                                Image(light.imageName)
                                    .resizable()
                                    .renderingMode(.template)
                                    .scaledToFit()
                                    .frame(width: 12, height: 12)
                                Text(light.name)
                                    .font(ClusterTheme.Types.mono(10, weight: .semibold))
                                Image(systemName: "xmark")
                                    .font(.system(size: 8, weight: .bold))
                            }
                            .padding(.horizontal, 9)
                            .padding(.vertical, 6)
                            .foregroundStyle(ClusterTheme.Colors.background)
                            .background(ClusterTheme.Colors.amber)
                            .clipShape(RoundedRectangle(cornerRadius: 6))
                        }
                        .buttonStyle(.plain)
                    }
                }
            } else {
                Text("None added yet")
                    .font(ClusterTheme.Types.body(12))
                    .foregroundStyle(ClusterTheme.Colors.textSecondary.opacity(0.6))
            }
        }
        .padding(.horizontal)
    }
}

#Preview {
    AddIssueView(
        vehicle: Vehicle(name: "My Civic")
    )
}
