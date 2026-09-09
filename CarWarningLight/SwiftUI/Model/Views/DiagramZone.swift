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
    case topDown, leftSide, rightSide

    var id: String { rawValue }

    var title: String {
        switch self {
        case .topDown:              return "Top Down"
        case .leftSide:             return "Left Side"
        case .rightSide:            return "Right Side"
        }
    }

    var isFlipped: Bool { self == .rightSide }

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
        case .leftSide, .rightSide:
            let cols: [(name: String, x: CGFloat)] = [("Front", 0), ("Mid", 1.0 / 3), ("Rear", 2.0 / 3)]
            let rows: [(name: String, y: CGFloat)] = [("Upper", 0), ("Lower", 0.5)]
            return cols.flatMap { col in
                rows.map { row in
                    DiagramZone(
                        id: "\(col.name.lowercased())\(row.name)",
                        label: "\(col.name) \(row.name)",
                        rect: CGRect(x: col.x, y: row.y, width: 1.0 / 3, height: 0.5)
                    )
                }
            }
        }
    }
}
