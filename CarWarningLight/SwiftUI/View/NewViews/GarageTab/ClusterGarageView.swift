//
//  ClusterGarageView.swift
//  CarWarningLight
//
//  Created by Sam Greenhill on 8/17/26.
//  Copyright © 2026 simplyAmazingMachines. All rights reserved.
//

import SwiftUI
import SwiftData

struct ClusterGarageView: View {

    @Binding var isScrolledDown: Bool
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \Vehicle.dateCreated) private var vehicles: [Vehicle]

    @State private var showAddVehicle: Bool = false
    @State private var editingVehicle: Vehicle?
    @State private var vehicleToDelete: Vehicle?

    private let columns = [GridItem(.flexible(), spacing: 14), GridItem(.flexible(), spacing: 14)]

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                header

                if vehicles.isEmpty {
                    emptyState
                } else {
                    LazyVGrid(columns: columns, spacing: 14) {
                        ForEach(vehicles) { vehicle in
                            NavigationLink(value: vehicle) {
                                GarageVehicleCard(vehicle: vehicle)
                            }
                            .buttonStyle(.plain)
                            .contextMenu {
                                Button {
                                    editingVehicle = vehicle
                                } label: {
                                    Label("Edit", systemImage: "pencil")
                                }

                                Button(role: .destructive) {
                                    vehicleToDelete = vehicle
                                } label: {
                                    Label("Delete", systemImage: "trash")
                                }
                            }
                        }
                        addVehicleTile
                    }
                    .padding(.horizontal)
                }
            }
            .padding(.bottom, 24)
        }
        .trackScrollOffset(isScrolledDown: $isScrolledDown)
        .background(ClusterTheme.Colors.background)
        .navigationDestination(for: Vehicle.self) { vehicle in
            GarageVehicleDetailView(vehicle: vehicle)
        }
        .sheet(isPresented: $showAddVehicle) {
            ClusterAddVehicleView { newVehicle in
                modelContext.insert(newVehicle)
            }
        }
        .sheet(item: $editingVehicle) { vehicle in
            ClusterEditVehicleSheet(vehicle: vehicle)
        }
        .alert("Delete this vehicle?", isPresented: Binding(
            get: { vehicleToDelete != nil },
            set: { if $0 { vehicleToDelete = nil } }
        )) {
            Button("Cancel", role: .cancel) { vehicleToDelete = nil }
            Button("Delete", role: .destructive) {
                if let vehicle = vehicleToDelete {
                    modelContext.delete(vehicle)
                }
                vehicleToDelete = nil
            }
        } message: {
            Text("This removes all its logged issues and warning lights too. This can't be undone.")
        }
    }

    private var header: some View {
        HStack(alignment: .top) {
            VStack(alignment: .leading, spacing: 2) {
                Text("Garage")
                    .font(ClusterTheme.Types.display(24))
                    .foregroundStyle(ClusterTheme.Colors.textPrimary)
                Text(vehicles.isEmpty ? "Everything your mechanic needs to know" : "Pick a vehicle to see its history")
                    .font(ClusterTheme.Types.body(13))
                    .foregroundStyle(ClusterTheme.Colors.textSecondary)
            }
            Spacer()

            Button {
                showAddVehicle = true
            } label: {
                Image(systemName: "plus")
                    .font(.system(size: 14, weight: .bold))
                    .foregroundStyle(ClusterTheme.Colors.background)
                    .frame(width: 32, height: 32)
                    .background(ClusterTheme.Colors.amber)
                    .clipShape(Circle())
            }
            .accessibilityLabel("Add a vehicle")
        }
        .padding(.horizontal)
        .padding(.top, 20)
    }

    private var addVehicleTile: some View {
        Button {
            showAddVehicle = true
        } label: {
            VStack(spacing: 10) {
                Image(systemName: "plus")
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundStyle(ClusterTheme.Colors.textSecondary)
                Text("Add vehicle")
                    .font(ClusterTheme.Types.body(13, weight: .semibold))
                    .foregroundStyle(ClusterTheme.Colors.textSecondary)
            }
            .frame(maxWidth: .infinity)
            .frame(height: 150)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(style: StrokeStyle(lineWidth: 1.25, dash: [5, 5]))
                    .foregroundStyle(ClusterTheme.Colors.bezel)
            )
        }
        .buttonStyle(.plain)
    }

    private var emptyState: some View {
        VStack(spacing: 14) {
            Image(systemName: "car.side")
                .font(.system(size: 40))
                .foregroundStyle(ClusterTheme.Colors.textSecondary)
            Text("No vehicles yet")
                .font(ClusterTheme.Types.body(17, weight: .semibold))
                .foregroundStyle(ClusterTheme.Colors.textPrimary)
            Text("Add a vehicle to start tracking issues and warning lights you can hand straight to your mechanic.")
                .font(ClusterTheme.Types.body(13))
                .foregroundStyle(ClusterTheme.Colors.textSecondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 40)

            Button {
                showAddVehicle = true
            } label: {
                Text("Add Vehicle")
                    .font(ClusterTheme.Types.body(15, weight: .bold))
                    .foregroundStyle(ClusterTheme.Colors.background)
                    .padding(.horizontal, 24)
                    .padding(.vertical, 12)
                    .background(ClusterTheme.Colors.amber)
                    .clipShape(Capsule())
            }
            .padding(.top, 6)
        }
        .frame(maxWidth: .infinity)
        .padding(.top, 60)
    }
}

#Preview {
    ClusterGarageView(isScrolledDown: .constant(false))
}
