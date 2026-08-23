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

    @State private var name: String                 = ""
    @State private var selectedImageName: String?   = nil

    private let bodyStyles: [(label: String, imageName: String)] = [
        ("Sedan",                                   "vehicleSedan"),
        ("SUV",                                     "vehicleSUV"),
        ("Pickup",                                  "vehiclePickup"),
        ("Hatchback",                               "vehicleHatchback"),
        ("Minivan",                                 "vehicleMinivan"),
        ("Coupe",                                   "vehicleCoupe"),
        ("Sports Car",                              "vehicleSportsCar"),
        ("Wagon",                                   "vehicleWagon")
    ]

    private let columns = [GridItem(.flexible(), spacing: 12), GridItem(.flexible(), spacing: 12)]

    private var isValid: Bool {
        !name.trimmingCharacters(in: .whitespaces).isEmpty && selectedImageName != nil
    }

    var body: some View {
        VStack(spacing: 0) {
            ClusterHeaderBar(title: "Add Vehicle") { dismiss() }

            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    fieldSection

                    VStack(alignment: .leading, spacing: 10) {
                        Text("BODY STYLE")
                            .font(ClusterTheme.Types.mono(11, weight: .bold))
                            .tracking(1.2)
                            .foregroundStyle(ClusterTheme.Colors.textSecondary)
                            .padding(.horizontal)

                        LazyVGrid(columns: columns, spacing: 12) {
                            ForEach(bodyStyles, id: \.imageName) { style in
                                bodyStyleTile(style)
                            }
                        }
                        .padding(.horizontal)
                    }
                    Button {
                        let vehicle = Vehicle(
                            name: name.trimmingCharacters(in: .whitespaces),
                            imageName: selectedImageName ?? bodyStyles[0].imageName
                        )
                        onSave(vehicle)
                        dismiss()
                    } label: {
                        Text("Add Vehicle")
                            .font(ClusterTheme.Types.body(16, weight: .bold))
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 14)
                            .background(isValid ? ClusterTheme.Colors.amber : ClusterTheme.Colors.bezel)
                            .foregroundStyle(isValid ? ClusterTheme.Colors.background : ClusterTheme.Colors.textSecondary)
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                    }
                    .disabled(!isValid)
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
                .font(ClusterTheme.Types.mono(11, weight: .bold))
                .tracking(1.2)
                .foregroundStyle(ClusterTheme.Colors.textSecondary)
            TextField("e.g. My Civic", text: $name)
                .font(ClusterTheme.Types.body(16))
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

    private func bodyStyleTile(_ style: (label: String, imageName: String)) -> some View {
        let isSelected = selectedImageName == style.imageName
        return Button {
            selectedImageName = style.imageName
        } label: {
            VStack(spacing: 8) {
                ClusterVehicleImagePlate(imageName: style.imageName, size: 72)
                    .padding(.top, 14)

                Text(style.label.uppercased())
                    .font(ClusterTheme.Types.mono(10, weight: .semibold))
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
