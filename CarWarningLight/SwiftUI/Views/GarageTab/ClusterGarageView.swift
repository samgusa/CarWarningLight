//
//  ClusterGarageView.swift
//  CarWarningLight
//

import SwiftUI
import SwiftData

struct ClusterGarageView: View {

    @Binding var isScrolledDown: Bool
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \Vehicle.dateCreated) private var vehicles: [Vehicle]
    @Environment(\.allLights) private var allLights

    @State private var viewModel                        = ClusterGarageViewModel()

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
                                    viewModel.beginEditing(vehicle)
                                } label: {
                                    Label("Edit", systemImage: "pencil")
                                }

                                Button(role: .destructive) {
                                    viewModel.requestDelete(vehicle)
                                } label: {
                                    Label("Delete", systemImage: "trash")
                                }
                            }
                        }
                        ClusterDashedActionTile(icon: "plus", label: "Add vehicle") {
                            viewModel.showAddVehicle = true
                        }
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
        .sheet(isPresented: $viewModel.showAddVehicle) {
            ClusterAddVehicleView { newVehicle in
                modelContext.insert(newVehicle)
            }
        }
        .sheet(item: $viewModel.editingVehicle) { vehicle in
            ClusterEditVehicleSheet(vehicle: vehicle)
        }
        .clusterConfirmation(
            isPresented: Binding(
            get: { viewModel.vehicleToDelete != nil },
            set: { if !$0 { viewModel.cancelDelete() } }
        ),
            title: "Delete this vehicle?",
            message: "This removes all its logged issues and warning lights too. This can't be undone.",
            onConfirm: {
                if let vehicle = viewModel.confirmDelete() {
                    modelContext.delete(vehicle)
                }
            })
    }

    private var header: some View {
        HStack(alignment: .top) {
            VStack(alignment: .leading, spacing: 2) {
                Text("Garage")
                    .font(ClusterTheme.Fonts.display(24))
                    .foregroundStyle(ClusterTheme.Colors.textPrimary)
                Text(vehicles.isEmpty ? "Everything your mechanic needs to know" : "Pick a vehicle to see its history")
                    .font(ClusterTheme.Fonts.body(13))
                    .foregroundStyle(ClusterTheme.Colors.textSecondary)
            }
            Spacer()

            ClusterSquareIconButton(icon: "plus") {
                viewModel.showAddVehicle = true
            }
            .accessibilityLabel("Add a vehicle")
        }
        .padding(.horizontal)
        .padding(.top, 20)
    }

    private var emptyState: some View {
        VStack(spacing: 14) {
            Image(systemName: "car.side")
                .font(.system(size: 40))
                .foregroundStyle(ClusterTheme.Colors.textSecondary)
            Text("No vehicles yet")
                .font(ClusterTheme.Fonts.body(17, weight: .semibold))
                .foregroundStyle(ClusterTheme.Colors.textPrimary)
            Text("Add a vehicle to start tracking issues and warning lights you can hand straight to your mechanic.")
                .font(ClusterTheme.Fonts.body(13))
                .foregroundStyle(ClusterTheme.Colors.textSecondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 40)

            ClusterDashedActionTile(icon: "plus", label: "Add Vehicle", height: 110) {
                viewModel.showAddVehicle = true
            }
            .padding(.horizontal, 40)
            .padding(.top, 6)
        }
        .frame(maxWidth: .infinity)
        .padding(.top, 60)
    }
}

#Preview {
    NavigationStack {
        ClusterGarageView(isScrolledDown: .constant(false))
    }
}
