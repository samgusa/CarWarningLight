//
//  VehicleDiagramView.swift
//  CarWarningLight
//
//  Created by Sam Greenhill on 8/25/26.
//  Copyright © 2026 simplyAmazingMachines. All rights reserved.
//

import SwiftUI

struct VehicleDiagramView: View {
    let imageName: String
    let kind: VehicleDiagramKind
    @Binding var selectedZones: Set<String>
    var tint: Color = ClusterTheme.Colors.textPrimary.opacity(0.85)
    var isInteractive: Bool = true

    private func key(_ zone: DiagramZone) -> String { "\(kind.rawValue):\(zone.id)" }

    var body: some View {
        GeometryReader { geo in
            let rect = fittedRect(for: nativeImageSize(imageName), in: geo.size)

            ZStack {
                Image(imageName)
                    .resizable()
                    .renderingMode(.template)
                    .foregroundStyle(tint)
                    .scaleEffect(x: kind.isFlipped ? -1 : 1, y: 1)
                    .frame(width: rect.width, height: rect.height)
                    .position(x: rect.midX, y: rect.midY)

                ForEach(kind.zones) { zone in
                    zoneMark(zone, in: rect)
                }
            }
        }
    }

    // MARK: - Shared geometry

    private static var imageSizeCache: [String: CGSize] = [:]

    private func nativeImageSize(_ name: String) -> CGSize {
        if let cached = Self.imageSizeCache[name] { return cached }
        let size = UIImage(named: name)?.size ?? CGSize(width: 1, height: 1)
        Self.imageSizeCache[name] = size
        return size
    }

    private func fittedRect(for imageSize: CGSize, in containerSize: CGSize) -> CGRect {
        guard imageSize.width > 0, imageSize.height > 0,
              containerSize.width > 0, containerSize.height > 0 else {
            return CGRect(origin: .zero, size: containerSize)
        }

        let imageAspect = imageSize.width / imageSize.height
        let containerAspect = containerSize.width / containerSize.height

        let fittedSize: CGSize
        if imageAspect > containerAspect {
            fittedSize = CGSize(width: containerSize.width, height: containerSize.width / imageAspect)
        } else {
            fittedSize = CGSize(width: containerSize.height * imageAspect, height: containerSize.height)
        }

        let origin = CGPoint(
            x: (containerSize.width - fittedSize.width) / 2,
            y: (containerSize.height - fittedSize.height) / 2
        )
        return CGRect(origin: origin, size: fittedSize)
    }

    // MARK: - Zones

    private func zoneMark(_ zone: DiagramZone, in imageRect: CGRect) -> some View {
        var x = zone.rect.minX
        if kind.isFlipped { x = 1 - x - zone.rect.width }

        let zoneRect = CGRect(
            x:              imageRect.minX + x * imageRect.width,
            y:              imageRect.minY + zone.rect.minY * imageRect.height,
            width:          zone.rect.width * imageRect.width,
            height:         zone.rect.height * imageRect.height
        )

        let zoneKey         = key(zone)
        let isOn            = selectedZones.contains(key(zone))

        return Group {
            if isInteractive {
                Button {
                    if isOn {
                        selectedZones.remove(zoneKey)
                    } else {
                        selectedZones.insert(zoneKey)
                    }
                } label: {
                    Rectangle()
                        .fill(isOn ? ClusterTheme.Colors.amber.opacity(0.32) : Color.black.opacity(0.001))
                        .overlay(
                            Rectangle()
                                .stroke(
                                    isOn ? ClusterTheme.Colors.amber : ClusterTheme.Colors.bezel.opacity(0.5),
                                    lineWidth: isOn ? 2 : 1
                                )
                        )
                }
                .buttonStyle(.plain)
                .accessibilityLabel(zone.label)
                .accessibilityAddTraits(isOn ? [.isSelected] : [])
            } else {
                Rectangle()
                    .fill(isOn ? ClusterTheme.Colors.amber.opacity(0.32) : Color.clear)
                    .overlay(
                        Rectangle()
                            .stroke(
                                isOn ? ClusterTheme.Colors.amber : ClusterTheme.Colors.bezel.opacity(0.5),
                                lineWidth: isOn ? 2 : 1
                            )
                    )
            }
        }
        .frame(width: zoneRect.width, height: zoneRect.height)
        .position(x: zoneRect.midX, y: zoneRect.midY)
        .id(zoneKey)
    }
}

#Preview {
    ClusterVehicleDiagramPicker(vehicle: Vehicle(name: "My Civic"), selectedZones: .constant([]))
        .padding()
        .background(ClusterTheme.Colors.background)
}

