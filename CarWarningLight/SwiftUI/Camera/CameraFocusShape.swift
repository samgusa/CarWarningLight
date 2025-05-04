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

    // MARK: - Initialization
    init(
        size: CGFloat = 100,
        lineWidth: CGFloat = 4,
        color: Color = .white,
        gapSize: CGFloat = 20
    ) {
        self.size = size
        self.lineWidth = lineWidth
        self.color = color
        self.gapSize = gapSize
    }

    // MARK: - Body
    var body: some View {
        ZStack {
            // Each edge component (top, right, bottom, left)
            createEdge(isHorizontal: true, position: .top)
            createEdge(isHorizontal: false, position: .right)
            createEdge(isHorizontal: true, position: .bottom)
            createEdge(isHorizontal: false, position: .left)
        }
        .frame(width: size, height: size)
        .foregroundColor(color)
    }

    // MARK: - Helper Methods

    /// Edge positions enum for semantic positioning
    private enum EdgePosition {
        case top, right, bottom, left
    }

    /**
     * Creates an edge of the focus shape with a gap in the middle
     * @param isHorizontal - Whether the edge is horizontal (top/bottom) or vertical (left/right)
     * @param position - The position of the edge
     */
    private func createEdge(isHorizontal: Bool, position: EdgePosition) -> some View {
        Group {
            if isHorizontal {
                HStack(spacing: 0) {
                    Rectangle()
                        .frame(width: (size - gapSize) / 2, height: lineWidth)

                    Spacer()
                        .frame(width: gapSize)

                    Rectangle()
                        .frame(width: (size - gapSize) / 2, height: lineWidth)
                }
                .frame(width: size)
                .position(
                    x: size/2,
                    y: position == .top ? lineWidth/2 : size - lineWidth/2
                )
            } else {
                VStack(spacing: 0) {
                    Rectangle()
                        .frame(width: lineWidth, height: (size - gapSize) / 2)

                    Spacer()
                        .frame(height: gapSize)

                    Rectangle()
                        .frame(width: lineWidth, height: (size - gapSize) / 2)
                }
                .frame(height: size)
                .position(
                    x: position == .left ? lineWidth/2 : size - lineWidth/2,
                    y: size/2
                )
            }
        }
    }
}

#Preview {
    ContentView()
        .environmentObject(UIStateManager())
}
