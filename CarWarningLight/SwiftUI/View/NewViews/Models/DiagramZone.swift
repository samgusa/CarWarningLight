//
//  DiagramZone.swift
//  CarWarningLight
//
//  Created by Sam Greenhill on 8/24/26.
//  Copyright © 2026 simplyAmazingMachines. All rights reserved.
//

import SwiftUI

struct DiagramZone: Identifiable, Hashable {
    let id: String
    let label: String
    let rect: CGRect // normalized 0...1 within the image's own bounds
}

enum VehicleDiagramKind: String, CaseIterable, Identifiable {
    case topDown, driverSide, passengerSide

    var id: String { rawValue }

    var title: String {
        switch self {
        case .topDown:              return "Top Down"
        case .driverSide:           return "Driver Side"
        case .passengerSide:        return "Passenger Side"
        }
    }

    var isFlipped: Bool { self == .passengerSide }

    var zones: [DiagramZone] {
        switch self {
        case .topDown:
            let rows: [(name: String, y: CGFloat)] = [("Front", 0), ("Mid", 1.0 / 3), ("Rear", 2.0 / 3)]
            let cols: [(name: String, x: CGFloat)] = [("Left", 0), ("Right", 0.5)]
            return rows.flatMap { row in
                cols.map { col in
                    DiagramZone(
                        id: "\(row.name.lowercased())\(col.name)",
                        label: "\(row.name) \(col.name)",
                        rect: CGRect(x: col.x, y: row.y, width: 0.5, height: 1.0 / 3)
                    )
                }
            }
        case .driverSide, .passengerSide:
            let cols: [(name: String, x: CGFloat)] = [("Front", 0), ("Mid", 1.0 / 3), ("Rear", 2.0 / 3)]
            return cols.map { col in
                DiagramZone(
                    id: col.name.lowercased(),
                    label: col.name,
                    rect: CGRect(x: col.x, y: 0, width: 1.0 / 3, height: 1)
                )
            }
        }
    }
}
