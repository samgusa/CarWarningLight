//
//  AnimatedShapes.swift
//  CarWarningLight
//
//  Created by Sam Greenhill on 5/6/25.
//  Copyright © 2025 simplyAmazingMachines. All rights reserved.
//

import SwiftUI

internal struct AnimatedCheckmarkView: View {

    var frameSize: CGFloat
    var animationDuration: Double = 0.75
    @State private var outerTrimEnd: CGFloat = 0
    @State private var innerTrimEnd: CGFloat = 0
    @State private var circleOpacity: CGFloat = 0

    var body: some View {
        ZStack {
            Circle()
                .trim(from: 0.0, to: outerTrimEnd)
                .stroke(Color.green, style: StrokeStyle(lineWidth: frameSize / 10, lineCap: .round, lineJoin: .round))
                .rotationEffect(.degrees(-90))

            Circle()
                .fill(.green)
                .frame(width: frameSize * 0.8, height: frameSize * 0.8)

            Checkmark()
                .trim(from: 0, to: innerTrimEnd)
                .stroke(Color.white, style: StrokeStyle(lineWidth: frameSize / 10, lineCap: .round, lineJoin: .round))
                .frame(width: frameSize / 3, height: frameSize / 3)
        }
        .frame(width: frameSize, height: frameSize)
        .onAppear() {
            animate()
        }
    }

    private func animate() {
        withAnimation(.linear(duration: animationDuration)) {
            outerTrimEnd = 1.0
        }
        withAnimation(
            .linear(duration: animationDuration/2)
            .delay(animationDuration)
        ) {
            innerTrimEnd = 1.0
        }
    }
}

internal struct AnimatedXMark: View {
    @State var pathProgress: Double = 0.0
    var frameSize: CGFloat

    var body: some View {
        Circle()
            .fill(.red)
            .overlay {
                XShape()
                    .trim(from: 0.0, to: pathProgress)
                    .stroke(Color.white, style: StrokeStyle(lineWidth: frameSize / 10, lineCap: .round, lineJoin: .round))
                    .animation(.easeInOut(duration: 1), value: pathProgress)
                    .onAppear {
                        self.pathProgress = 1.0
                    }
                    .frame(width: frameSize / 3, height: frameSize / 3, alignment: .center)
            }
            .frame(width: frameSize, height: frameSize)
    }
}
