//
//  ClusterEditVehicleSheet.swift
//  CarWarningLight
//
//  Created by Sam Greenhill on 8/17/26.
//  Copyright © 2026 simplyAmazingMachines. All rights reserved.
//

import SwiftUI

struct ClusterEditVehicleSheet: View {
    @Bindable var vehicle: Vehicle
    @Environment(\.dismiss) private var dismiss

    @State private var name: String = ""
    @State private var selectedImageName: String = ""

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

    private let columns = [GridItem(.flexible(), spacing: 12), GridItem(.flexible(), spacing: 12), GridItem(.flexible(), spacing: 12)]

    private var isValid: Bool {
        !name.trimmingCharacters(in: .whitespaces).isEmpty
    }

    private var hasChanges: Bool {
        name.trimmingCharacters(in: .whitespaces) != vehicle.name || selectedImageName != vehicle.imageName
    }

    var body: some View {
        VStack(spacing: 0) {
            ClusterHeaderBar(title: "Edit Vehicle") { dismiss() }
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("NICKNAME")
                            .font(ClusterTheme.Types.mono(11, weight: .bold))
                            .tracking(1.2)
                            .foregroundStyle(ClusterTheme.Colors.textSecondary)
                        TextField("Vehicle name", text: $vehicle.name)
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
                        vehicle.name = name.trimmingCharacters(in: .whitespaces)
                        vehicle.imageName = selectedImageName
                        dismiss()
                    } label: {
                        Text("Save Changes")
                            .font(ClusterTheme.Types.body(16, weight: .bold))
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 14)
                            .background((isValid && hasChanges) ? ClusterTheme.Colors.amber : ClusterTheme.Colors.bezel)
                            .foregroundStyle((isValid && hasChanges) ? ClusterTheme.Colors.background : ClusterTheme.Colors.textSecondary)
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                    }
                    .disabled(!(isValid && hasChanges))
                    .padding(.horizontal)
                }
                .padding(.top, 16)
                .padding(.bottom, 24)
            }
        }
        .background(ClusterTheme.Colors.background)
        .onAppear {
            name = vehicle.name
            selectedImageName = vehicle.imageName
        }
    }


    private func bodyStyleTile(_ style: (label: String, imageName: String)) -> some View {
        let isSelected = selectedImageName == style.imageName
        return Button {
            selectedImageName = style.imageName
        } label: {
            VStack(spacing: 8) {
                ClusterVehicleImagePlate(imageName: style.imageName, size: 46)
                    .padding(.top, 10)

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
    ClusterGarageView(isScrolledDown: .constant(false))
}
