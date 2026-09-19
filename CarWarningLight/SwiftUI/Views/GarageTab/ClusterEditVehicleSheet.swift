//
//  ClusterEditVehicleSheet.swift
//  CarWarningLight
//
//  Created by Sam Greenhill on 8/17/26.
//  Copyright © 2026 simplyAmazingMachines. All rights reserved.
//

import SwiftUI

struct ClusterEditVehicleSheet: View {
    @Environment(\.dismiss) private var dismiss

    @State private var viewModel: VehicleFormViewModel

    private let columns = [GridItem(.flexible(), spacing: 12), GridItem(.flexible(), spacing: 12)]

    init(vehicle: Vehicle) {
        _viewModel = State(initialValue: VehicleFormViewModel(existingVehicle: vehicle))
    }

    var body: some View {
        VStack(spacing: 0) {
            ClusterHeaderBar(title: "Edit Vehicle") { dismiss() }

            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    VStack(alignment: .leading, spacing: 8) {
                        detailsSection
                        Text("NICKNAME")
                            .font(ClusterTheme.Fonts.mono(11, weight: .bold))
                            .tracking(1.2)
                            .foregroundStyle(ClusterTheme.Colors.textSecondary)
                        TextField("Vehicle name", text: $viewModel.name)
                            .font(ClusterTheme.Fonts.body(16))
                            .foregroundStyle(ClusterTheme.Colors.textPrimary)
                            .padding(14)
                            .background(ClusterTheme.Colors.panel)
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(ClusterTheme.Colors.bezel, lineWidth: 1)
                            )
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                    }
                    .padding(.horizontal)

                    VStack(alignment: .leading, spacing: 10) {
                        Text("BODY STYLE")
                            .font(ClusterTheme.Fonts.mono(11, weight: .bold))
                            .tracking(1.2)
                            .foregroundStyle(ClusterTheme.Colors.textSecondary)
                            .padding(.horizontal)

                        LazyVGrid(columns: columns, spacing: 12) {
                            ForEach(viewModel.bodyStyles, id: \.imageName) { style in
                                bodyStyleTile(style)
                            }
                        }
                        .padding(.horizontal)
                    }

                    Button {
                        viewModel.applyChanges()
                        dismiss()
                    } label: {
                        Text("Save Changes")
                            .font(ClusterTheme.Fonts.body(16, weight: .bold))
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 14)
                            .background((viewModel.isValid && viewModel.hasChanges) ? ClusterTheme.Colors.amber : ClusterTheme.Colors.bezel)
                            .foregroundStyle((viewModel.isValid && viewModel.hasChanges) ? ClusterTheme.Colors.background : ClusterTheme.Colors.textSecondary)
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                    }
                    .disabled(!(viewModel.isValid && viewModel.hasChanges))
                    .padding(.horizontal)
                }
                .padding(.top, 16)
                .padding(.bottom, 24)
            }
        }
        .background(ClusterTheme.Colors.background)
    }

    private var detailsSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("VEHICLE DETAILS (OPTIONAL)")
                .font(ClusterTheme.Fonts.mono(11, weight: .bold))
                .tracking(1.2)
                .foregroundStyle(ClusterTheme.Colors.textSecondary)

            HStack(spacing: 10) {
                styledField("Year", text: $viewModel.year, keyboard: .numberPad)
                styledField("Make", text: $viewModel.make)
                styledField("Model", text: $viewModel.model)
            }
            styledField("VIN", text: $viewModel.vin)
                .textInputAutocapitalization(.characters)
        }
        .padding(.horizontal)
    }

    private func styledField(_ placeholder: String, text: Binding<String>, keyboard: UIKeyboardType = .default) -> some View {
        TextField(placeholder, text: text)
            .keyboardType(keyboard)
            .font(ClusterTheme.Fonts.body(15))
            .foregroundStyle(ClusterTheme.Colors.textPrimary)
            .padding(12)
            .background(ClusterTheme.Colors.panel)
            .overlay(RoundedRectangle(cornerRadius: 10).stroke(ClusterTheme.Colors.bezel, lineWidth: 1))
            .clipShape(RoundedRectangle(cornerRadius: 10))
    }

    private func sideImageName(for topDownName: String) -> String {
        topDownName.replacingOccurrences(of: "vehicle", with: "side")
    }

    private func bodyStyleTile(_ style: (label: String, imageName: String)) -> some View {
        let isSelected = viewModel.selectedImageName == style.imageName
        return Button {
            viewModel.selectedImageName = style.imageName
        } label: {
            VStack(spacing: 8) {
                ClusterVehicleImagePlate(imageName: sideImageName(for: style.imageName), size: 108)
                    .padding(.top, 14)

                Text(style.label.uppercased())
                    .font(ClusterTheme.Fonts.mono(10, weight: .semibold))
                    .foregroundStyle(isSelected ? ClusterTheme.Colors.amber : ClusterTheme.Colors.textSecondary)
                    .padding(.bottom, 14)
            }
            .frame(maxWidth: .infinity)
            .clusterPanel()
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(isSelected ? ClusterTheme.Colors.amber : .clear, lineWidth: 2)
            )
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    ClusterEditVehicleSheet(vehicle: Vehicle(name: "My Civic"))
}
