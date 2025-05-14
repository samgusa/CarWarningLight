//
//  CameraFocusShape.swift
//  CarWarningLight
//
//  Created by Sam Greenhill on 4/30/25.
//  Copyright © 2025 simplyAmazingMachines. All rights reserved.
//

import SwiftUI

struct CameraFocusShape: View {
    // MARK: - Properties
    let size: CGFloat
    let lineWidth: CGFloat
    let color: Color
    let gapSize: CGFloat
    let cornerRadius: CGFloat

    // MARK: - Initialization
    init(
        size: CGFloat = 100,
        lineWidth: CGFloat = 4,
        color: Color = .white,
        gapSize: CGFloat = 20,
        cornerRadius: CGFloat = 0
    ) {
        self.size = size
        self.lineWidth = lineWidth
        self.color = color
        self.gapSize = gapSize
        self.cornerRadius = cornerRadius
    }

    // MARK: - Body
    var body: some View {
        ZStack {
            // Top Left
            EdgeCorner(cornerRadius: cornerRadius, lineWidth: lineWidth)
                .frame(width: cornerLength, height: cornerLength)
                .position(x: cornerRadius, y: cornerRadius)

            // Top Right
            EdgeCorner(cornerRadius: cornerRadius, lineWidth: lineWidth)
                .rotationEffect(Angle(degrees: 90))
                .frame(width: cornerLength, height: cornerLength)
                .position(x: size - cornerRadius, y: cornerRadius)


            // Bottom Right
            EdgeCorner(cornerRadius: cornerRadius, lineWidth: lineWidth)
                .rotationEffect(Angle(degrees: 180))
                .frame(width: cornerLength, height: cornerLength)
                .position(x: size - cornerRadius, y: size - cornerRadius)


            // Bottom Left
            EdgeCorner(cornerRadius: cornerRadius, lineWidth: lineWidth)
                .rotationEffect(Angle(degrees: 270))
                .frame(width: cornerLength, height: cornerLength)
                .position(x: cornerRadius, y: size - cornerRadius)
        }
        .frame(width: size, height: size)
        .foregroundColor(color)
    }

    // MARK: - Helper Methods

    private var cornerLength: CGFloat {
        return min((size - gapSize) / 2, size / 3)
    }
}

struct EdgeCorner: View {
    let cornerRadius: CGFloat
    let lineWidth: CGFloat

    var body: some View {
        Path { path in
            path.move(to: CGPoint(x: 2, y: lineWidth / 2))

            path.addLine(to: CGPoint(x: cornerRadius + lineWidth, y: lineWidth / 2))

            path.move(to: CGPoint(x: lineWidth / 2, y: 2))
            path.addLine(to: CGPoint(x: lineWidth / 2, y: cornerRadius + lineWidth))
        }
        .stroke(style: StrokeStyle(lineWidth: lineWidth, lineCap: .round, lineJoin: .round))
    }
}

#Preview {
    ZStack {
        Color.black.ignoresSafeArea()
        CameraFocusShape(size: 150, cornerRadius: 10)
            .environmentObject(UIStateManager())
    }
}
