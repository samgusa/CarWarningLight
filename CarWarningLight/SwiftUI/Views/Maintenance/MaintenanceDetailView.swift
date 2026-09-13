//
//  MaintenanceDetailView.swift
//  CarWarningLight
//
//  Created by Sam Greenhill on 9/13/26.
//  Copyright © 2026 simplyAmazingMachines. All rights reserved.
//

import SwiftUI
import SwiftData

struct MaintenanceDetailView: View {
    @State private var viewModel: MaintenanceDetailViewModel

    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext
    @FocusState private var noteFieldFocused: Bool

    @State private var showCamera: Bool = false

    init(item: MaintenanceItem) {
        _viewModel = State(initialValue: MaintenanceDetailViewModel(item: item))
    }

    var body: some View {
        VStack(spacing: 0) {
            ClusterHeaderBar(title: "Maintenance", icon: "chevron.left") { dismiss() }

            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    heroRow
                    resolvedControl

                    VStack(alignment: .leading, spacing: 8) {
                        Text("NOTES FOR THE MECHANIC")
                            .font(ClusterTheme.Fonts.mono(10, weight: .bold))
                            .tracking(1.2)
                            .foregroundStyle(ClusterTheme.Colors.textSecondary)

                        ClusterPhotoAttachmentButton(
                            image: viewModel.photo,
                            onCapture: { showCamera = true },
                            onRemove: { viewModel.photo = nil }
                        )

                        TextEditor(text: Bindable(viewModel.item).noteText)
                            .focused($noteFieldFocused)
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

                    Button(role: .destructive) {
                        viewModel.requestDelete()
                    } label: {
                        Text("Delete Maintenance Item")
                            .font(ClusterTheme.Fonts.body(14, weight: .semibold))
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
                    .font(ClusterTheme.Fonts.body(15, weight: .semibold))
                    .foregroundStyle(ClusterTheme.Colors.amber)
            }
        }
        .fullScreenCover(isPresented: $showCamera) {
            CameraView(cropsToFocusSquare: false) { image in
                viewModel.photo = image
                showCamera = false
            }
        }
        .clusterConfirmation(
            isPresented: $viewModel.showDeleteConfirm,
            title: "Delete this maintenance item?",
            message: "This can't be undone",
            onConfirm: {
                modelContext.delete(viewModel.item)
                dismiss()
            }
        )
    }


    private var heroRow: some View {
        HStack(spacing: 14) {
            ZStack {
                RoundedRectangle(cornerRadius: 12)
                    .fill(ClusterTheme.Colors.panel)
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(ClusterTheme.Colors.bezel, lineWidth: 1)
                    )
                Image(systemName: viewModel.item.category.icon)
                    .font(.system(size: 22, weight: .semibold))
                    .foregroundStyle(viewModel.item.isActive ? ClusterTheme.Colors.amber : ClusterTheme.Colors.textSecondary)
            }
            .frame(width: 54, height: 54)

            VStack(alignment: .leading, spacing: 3) {
                Text(viewModel.item.title)
                    .font(ClusterTheme.Fonts.display(18))
                    .foregroundStyle(ClusterTheme.Colors.textPrimary)
                Text("LOGGED \(viewModel.dateLabel.uppercased())")
                    .font(ClusterTheme.Fonts.mono(10, weight: .bold))
                    .tracking(1.0)
                    .foregroundStyle(ClusterTheme.Colors.textSecondary)
            }
            Spacer()
        }
        .padding(.horizontal)
    }

    private var resolvedControl: some View {
        ClusterStatusToggle(
            isActive: viewModel.item.isActive,
            activeLabel: "NEEDED",
            resolvedLabel: "DONE",
            activeSubtitle: "Tap once it's been taken care of",
            resolvedSubtitle: "Tap to mark as still needed") {
                viewModel.toggleResolved()
            }
            .padding(.horizontal)
    }
}

#Preview {
    MaintenanceDetailView(item: MaintenanceItem(vehicle: Vehicle(name: "My Civic"), category: .wiperBlades))
}
