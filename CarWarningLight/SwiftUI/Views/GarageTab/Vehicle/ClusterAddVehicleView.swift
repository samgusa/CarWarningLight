//
//  ClusterAddVehicleView.swift
//  CarWarningLight
//
//  Created by Sam Greenhill on 7/27/26.
//  Copyright © 2026 simplyAmazingMachines. All rights reserved.
//

import SwiftUI

struct ClusterAddVehicleView: View {
    @Environment(\.dismiss) private var dismiss
    var onSave: (Vehicle) -> Void

    @State private var viewModel = VehicleFormViewModel()
    @State private var showBodyStyleHint: Bool = false

    private let columns = [GridItem(.flexible(), spacing: 12), GridItem(.flexible(), spacing: 12)]

    var body: some View {
        VStack(spacing: 0) {
            ClusterHeaderBar(title: "Add Vehicle") { dismiss() }

            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    detailsSection
                    fieldSection

                    VStack(alignment: .leading, spacing: 10) {
                        HStack {
                            Text("BODY STYLE")
                                .font(ClusterTheme.Fonts.mono(11, weight: .bold))
                                .tracking(1.2)
                                .foregroundStyle(ClusterTheme.Colors.textSecondary)
                            Spacer()
                            Button {
                                withAnimation(.easeInOut(duration: 0.2)) { showBodyStyleHint.toggle() }
                            } label: {
                                HStack(spacing: 4) {
                                    Image(systemName: "questionmark.circle")
                                        .font(.system(size: 11, weight: .semibold))
                                    Text("NOT SURE")
                                        .font(ClusterTheme.Fonts.mono(10, weight: .bold))
                                        .tracking(0.6)
                                }
                                .foregroundStyle(showBodyStyleHint ? ClusterTheme.Colors.amber : ClusterTheme.Colors.textSecondary)
                            }
                            .buttonStyle(.plain)
                        }
                        .padding(.horizontal)

                        if showBodyStyleHint {
                            ClusterAccentBanner(
                                icon: "lightbulb.fill",
                                title: "Just pick what looks closest",
                                subtitle: "This only controls the icon shown in your Garage - it doesn't affect anything else, and you can change it anytime from Edit Vehicle.",
                                tint: ClusterTheme.Colors.amber
                            )
                            .padding(.horizontal)
                            .transition(.opacity.combined(with: .move(edge: .top)))
                        }

                        LazyVGrid(columns: columns, spacing: 12) {
                            ForEach(viewModel.bodyStyles, id: \.imageName) { style in
                                bodyStyleTile(style)
                            }
                        }
                        .padding(.horizontal)
                    }
                    Button {
                        guard let vehicle = viewModel.buildNewVehicle() else { return }
                        onSave(vehicle)
                        dismiss()
                    } label: {
                        Text("Add Vehicle")
                            .font(ClusterTheme.Fonts.body(16, weight: .bold))
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 14)
                            .background(viewModel.isValid ? ClusterTheme.Colors.amber : ClusterTheme.Colors.bezel)
                            .foregroundStyle(viewModel.isValid ? ClusterTheme.Colors.background : ClusterTheme.Colors.textSecondary)
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                    }
                    .disabled(!viewModel.isValid)
                    .padding(.horizontal)
                    .padding(.top, 4)
                }
                .padding(.top, 16)
                .padding(.bottom, 24)
            }
        }
        .background(ClusterTheme.Colors.background)
    }

    private var fieldSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("NICKNAME")
                .font(ClusterTheme.Fonts.mono(11, weight: .bold))
                .tracking(1.2)
                .foregroundStyle(ClusterTheme.Colors.textSecondary)
            TextField("e.g. My Civic", text: $viewModel.name)
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
                    .padding(.bottom, 10)
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
    ClusterAddVehicleView(onSave: { _ in })
}
