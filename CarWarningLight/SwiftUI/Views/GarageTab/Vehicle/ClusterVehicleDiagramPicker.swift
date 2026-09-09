//
//  ClusterVehicleDiagramPicker.swift
//  CarWarningLight
//
//  Created by Sam Greenhill on 8/24/26.
//  Copyright © 2026 simplyAmazingMachines. All rights reserved.
//

import SwiftUI

struct ClusterVehicleDiagramPicker: View {
    let vehicle: Vehicle?
    @Binding var selectedZones: Set<String>

    @State private var activeKind: VehicleDiagramKind = .topDown

    private let inset: CGFloat = 16

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            header

            if let vehicle {
                kindPicker
                diagramCanvas(for: vehicle)
                if !selectedZones.isEmpty { summary }
            } else {
                unavailableState
            }
        }
    }

    private var header: some View {
        VStack(alignment: .leading, spacing: 2){
            Text("MARK THE LOCATION")
                .font(ClusterTheme.Types.mono(11, weight: .bold))
                .tracking(1.2)
                .foregroundStyle(ClusterTheme.Colors.textSecondary)
            Text("Left/right as if sitting in the driver's seat facing forward — same on any car, anywhere.")
                .font(ClusterTheme.Types.body(11))
                .foregroundStyle(ClusterTheme.Colors.textSecondary.opacity(0.8))
        }
    }

    private var kindPicker: some View {
        HStack(spacing: 8) {
            ForEach(VehicleDiagramKind.allCases) { kind in
                let isActive = activeKind == kind
                Button {
                    activeKind = kind
                } label: {
                    Text(kind.title.uppercased())
                        .font(ClusterTheme.Types.mono(10, weight: .bold))
                        .tracking(0.4)
                        .padding(.horizontal, 10)
                        .padding(.vertical, 7)
                        .frame(maxWidth: .infinity)
                        .foregroundStyle(isActive ? ClusterTheme.Colors.background : ClusterTheme.Colors.textSecondary)
                        .background(isActive ? ClusterTheme.Colors.amber : ClusterTheme.Colors.panel)
                        .overlay(
                            RoundedRectangle(cornerRadius: 6)
                                .stroke(isActive ? .clear : ClusterTheme.Colors.bezel, lineWidth: 1)
                        )
                        .clipShape(RoundedRectangle(cornerRadius: 6))
                }
                .buttonStyle(.plain)
            }
        }
    }

    private var canvasHeight: CGFloat { activeKind == .topDown ? 260 : 150 }

    private func diagramCanvas(for vehicle: Vehicle) -> some View {
        VehicleDiagramView(
            imageName: vehicle.imageName(for: activeKind),
            kind: activeKind,
            selectedZones: $selectedZones
        )
        .padding(inset)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .frame(height: canvasHeight)
        .background(ClusterTheme.Colors.panel)
        .clipShape(RoundedRectangle(cornerRadius: 10))
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(ClusterTheme.Colors.bezel, lineWidth: 1)
        )
    }

    private var unavailableState: some View {
        VStack(spacing: 8) {
            Image(systemName: "car.side.slash")
                .font(.system(size: 22))
                .foregroundStyle(ClusterTheme.Colors.textSecondary)
            Text("No vehicle attached to this issue")
                .font(ClusterTheme.Types.body(12, weight: .semibold))
                .foregroundStyle(ClusterTheme.Colors.textSecondary)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 30)
        .background(ClusterTheme.Colors.panel)
        .clipShape(RoundedRectangle(cornerRadius: 10))
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(ClusterTheme.Colors.bezel, lineWidth: 1)
        )
    }

    private var summary: some View {
        FlowChip(items: Array(selectedZones).sorted()) { raw in
            let parts = raw.split(separator: ":", maxSplits: 1)
            let kindLabel = parts.first.flatMap { VehicleDiagramKind(rawValue: String($0))?.title } ?? ""
            let zoneLabel = parts.count > 1 ? (VehicleDiagramKind(rawValue: String(parts[0]))?.zones.first { $0.id == String(parts[1]) }?.label ?? "") : ""

            Button {
                selectedZones.remove(raw)
            } label: {
                HStack(spacing: 4) {
                    Text("\(kindLabel): \(zoneLabel)")
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
}

#Preview {
    ClusterVehicleDiagramPicker(vehicle: Vehicle(name: "My Civic"), selectedZones: .constant(["topDown:frontLeft"]))
        .padding()
        .background(ClusterTheme.Colors.background)
}
