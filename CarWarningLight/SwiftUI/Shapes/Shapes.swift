//
//  Shapes.swift
//  CarWarningLight
//
//  Created by Sam Greenhill on 5/6/25.
//  Copyright © 2025 simplyAmazingMachines. All rights reserved.
//

import SwiftUI

internal struct Checkmark: Shape {
    func path(in rect: CGRect) -> Path {
        let width = rect.size.width
        let height = rect.size.height

        var path = Path()
        path.move(to: .init(x: 0 * width, y: 0.5 * height))
        path.addLine(to: .init(x: 0.4 * width, y: 1.0 * height))
        path.addLine(to: .init(x: 1.0 * width, y: 0 * height))
        return path
    }
}

internal struct XShape: Shape {
    func path(in rect: CGRect) -> Path {
        Path { path in
            let startX: CGFloat = rect.minX
            let startY: CGFloat = rect.minY
            let endX: CGFloat = rect.maxX
            let endY: CGFloat = rect.maxY

            // Draw the \ (backslash) line of the X
            path.move(to: CGPoint(x: startX, y: startY))
            path.addLine(to: CGPoint(x: endX, y: endY))

            // Draw the / (forward slash) line of the X
            path.move(to: CGPoint(x: startX, y: endY))
            path.addLine(to: CGPoint(x: endX, y: startY))
        }
    }
}
