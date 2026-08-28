//
//  ClusterVehicleDiagramPicker.swift
//  CarWarningLight
//
//  Created by Sam Greenhill on 8/24/26.
//  Copyright © 2026 simplyAmazingMachines. All rights reserved.
//

import SwiftUI

struct ClusterVehicleDiagramPicker: View {
    let vehicle: Vehicle
    @Binding var selectedZones: Set<String>

    @State private var activeKind: VehicleDiagramKind = .topDown

    private let inset: CGFloat = 16

    private func imageName(for kind: VehicleDiagramKind) -> String {
        switch kind {
        case .topDown:                          return vehicle.imageName
        case .leftSide, .rightSide:       return vehicle.imageName.replacingOccurrences(of: "vehicle", with: "side")
        }
    }

    private func nativeImageSize(_ name: String) -> CGSize {
        guard let size = UIImage(named: name)?.size, size.width > 0, size.height > 0 else {
            return CGSize(width: 1, height: 1)
        }
        return size
    }

    private func fittedRect(for imageSize: CGSize, in containerSize: CGSize) -> CGRect {
        let available = CGSize(
            width: max(containerSize.width - inset * 2, 1),
            height: max(containerSize.height - inset * 2, 1)
        )
        let imageAspect = imageSize.width / imageSize.height
        let availableAspect = available.width / available.height

        let fittedSize: CGSize
        if imageAspect > availableAspect {
            fittedSize = CGSize(width: available.width, height: available.width / imageAspect)
        } else {
            fittedSize = CGSize(width: available.height * imageAspect, height: available.height)
        }

        let origin = CGPoint(
            x: (containerSize.width - fittedSize.width) / 2,
            y: (containerSize.height - fittedSize.height) / 2
        )
        return CGRect(origin: origin, size: fittedSize)
    }

    private func key(_ zone: DiagramZone) -> String { "\(activeKind.rawValue):\(zone.id)" }

    private var canvasHeight: CGFloat { activeKind == .topDown ? 260 : 150 }

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            VStack(alignment: .leading, spacing: 2){
                Text("MARK THE LOCATION")
                    .font(ClusterTheme.Types.mono(11, weight: .bold))
                    .tracking(1.2)
                    .foregroundStyle(ClusterTheme.Colors.textSecondary)
                Text("Left/right as if sitting in the driver's seat facing forward — same on any car, anywhere.")
                    .font(ClusterTheme.Types.body(11))
                    .foregroundStyle(ClusterTheme.Colors.textSecondary.opacity(0.8))
            }

            kindPicker
            diagramCanvas

            if !selectedZones.isEmpty {
                summary
            }
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

    private var diagramCanvas: some View {
        GeometryReader { geo in
            let name = imageName(for: activeKind)
            let rect = fittedRect(for: nativeImageSize(name), in: geo.size)

            ZStack {
                Image(imageName(for: activeKind))
                    .resizable()
                    .renderingMode(.template)
                    .foregroundStyle(ClusterTheme.Colors.textPrimary.opacity(0.8))
//                    .scaledToFit()
                    .scaleEffect(x: activeKind.isFlipped ? -1 : 1, y: 1)
                    .frame(width: geo.size.width, height: rect.height)
                    .position(x: rect.midX, y: rect.midY)

                ForEach(activeKind.zones) { zone in
                    zoneButton(zone, in: rect)
                }
            }
        }
        .frame(height: canvasHeight)
        .background(ClusterTheme.Colors.panel)
        .clipShape(RoundedRectangle(cornerRadius: 10))
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(ClusterTheme.Colors.bezel, lineWidth: 1)
        )
    }

    private func zoneButton(_ zone: DiagramZone, in imageRect: CGRect) -> some View {
        var x = zone.rect.minX
        if activeKind.isFlipped { x = 1 - x - zone.rect.width }

        let zoneRect = CGRect(
            x: imageRect.minX + x * imageRect.width,
            y: imageRect.minY + zone.rect.minY * imageRect.height,
            width: zone.rect.width * imageRect.width,
            height: zone.rect.height * imageRect.height
        )

        let isOn = selectedZones.contains(key(zone))

        return Button {
            let k = key(zone)
            if isOn { selectedZones.remove(k) } else { selectedZones.insert(k) }
        } label: {
            Rectangle()
                .fill(isOn ? ClusterTheme.Colors.amber.opacity(0.32) : Color.clear)
                .overlay(
                    Rectangle()
                        .stroke(isOn ? ClusterTheme.Colors.amber : ClusterTheme.Colors.bezel.opacity(0.5), lineWidth: isOn ? 2 : 1)
                )
        }
        .buttonStyle(.plain)
        .frame(width: zoneRect.width, height: zoneRect.height)
        .position(x: zoneRect.midX, y: zoneRect.midY)
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
