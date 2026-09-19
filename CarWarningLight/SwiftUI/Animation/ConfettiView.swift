//
//  ConfettiView.swift
//  CarWarningLight
//
//  Created by Sam Greenhill on 9/7/26.
//  Copyright © 2026 simplyAmazingMachines. All rights reserved.
//

import SwiftUI

struct ConfettiView: UIViewRepresentable {
    @Binding var isAnimating: Bool

    func makeUIView(context: Context) -> ConfettiContainerView {
        ConfettiContainerView()
    }

    func updateUIView(_ uiView: ConfettiContainerView, context: Context) {
        uiView.setAnimating(isAnimating, cells: generateConfettiCells())
    }

    func generateConfettiCells() -> [CAEmitterCell] {
        let colors: [UIColor]               = [.systemRed, .systemGreen, .systemBlue, .systemPurple, .systemYellow]
        let shapes: [ConfettiShape]         = ConfettiShape.allCases
        let position: [ConfettiPosition]    = ConfettiPosition.allCases

        return shapes.flatMap { shape in
            colors.flatMap { color in
                position.map { position in

                    let cell                = CAEmitterCell()
                    let confetti            = ConfettiType(color: color, shape: shape, position: position)
                    cell.contents           = confetti.image.cgImage
                    cell.birthRate          = 20
                    cell.lifetime           = 5
                    cell.velocity           = 100
                    cell.emissionRange      = -.pi / 4
                    cell.emissionLongitude  = -.pi
                    cell.spin               = 2
                    cell.spinRange          = 1
                    cell.scale              = 0.6
                    cell.scaleRange         = 0.3
                    cell.yAcceleration      = 50
                    return cell
                }
            }
        }
    }
}

final class ConfettiContainerView: UIView {
    private let emitterLayer = CAEmitterLayer()

    override init(frame: CGRect) {
        super.init(frame: frame)
        emitterLayer.emitterShape = .line
        emitterLayer.birthRate = 0
        layer.addSublayer(emitterLayer)
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    override func layoutSubviews() {
        super.layoutSubviews()
        emitterLayer.frame              = bounds
        emitterLayer.emitterPosition    = CGPoint(x: bounds.midX, y: -20)
        emitterLayer.emitterSize        = CGSize(width: bounds.width, height: 2)
    }

    func setAnimating(_ animating: Bool, cells: [CAEmitterCell]) {
        if animating {
            emitterLayer.emitterCells = cells
            emitterLayer.birthRate = 1
        } else {
            // used to keep confetti falling when stops/ fades slowly
            emitterLayer.birthRate = 0
        }
    }
}
