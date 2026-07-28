//
//  ClusterTheme.swift
//  CarWarningLight
//
//  Created by Sam Greenhill on 7/25/26.
//  Copyright © 2026 simplyAmazingMachines. All rights reserved.
//

import SwiftUI

enum ClusterTheme {
    enum Colors {
        static let background       = Color(red: 0x0B / 255, green: 0x0D / 255, blue: 0x10 / 255)
        static let panel            = Color(red: 0x15 / 255, green: 0x18 / 255, blue: 0x1D / 255)
        static let bezel            = Color(red: 0x26 / 255, green: 0x2B / 255, blue: 0x33 / 255)

        // Telltale colors — closer to real dash illumination than iOS system colors
        static let red              = Color(red: 0xFF / 255, green: 0x2A / 255, blue: 0x1E / 255)
        static let amber            = Color(red: 0xFF / 255, green: 0xB0 / 255, blue: 0x00 / 255)
        static let green            = Color(red: 0x00 / 255, green: 0xD6 / 255, blue: 0x8F / 255)

        static let textPrimary      = Color(red: 0xF5 / 255, green: 0xF6 / 255, blue: 0xF7 / 255)
        static let textSecondary    = Color(red: 0x8B / 255, green: 0x92 / 255, blue: 0xA0 / 255)

        static func forSymbolType(_ type: SymbolType) -> Color {
            switch type {
            case .warning:          return red
            case .advisory:         return amber
            case .info:             return green
            }
        }

        static func forDrivable(_ drivable: Drivable) -> Color {
            switch drivable {
            case .yes:              return green
            case .no:               return red
            case .uncertain:        return amber
            }
        }
    }

    enum Types {
        static func display(_ size: CGFloat, weight: Font.Weight = .heavy) -> Font {
            .system(size: size, weight: weight, design: .monospaced)
        }

        static func body(_ size: CGFloat = 15, weight: Font.Weight = .regular) -> Font {
            .system(size: size, weight: weight, design: .default)
        }

        static func mono(_ size: CGFloat = 12, weight: Font.Weight = .semibold) -> Font {
            .system(size: size, weight: weight, design: .monospaced)
        }
    }

    struct PanelStyle: ViewModifier {
        var cornerRadius: CGFloat = 8
        func body(content: Content) -> some View {
            content
                .background(Colors.panel)
                .clipShape(RoundedRectangle(cornerRadius: cornerRadius))
                .overlay(
                    RoundedRectangle(cornerRadius: cornerRadius)
                        .stroke(Colors.bezel, lineWidth: 1)
                )
        }
    }
}

extension View {
    func clusterPanel(cornerRadius: CGFloat = 8) -> some View {
        modifier(ClusterTheme.PanelStyle(cornerRadius: cornerRadius))
    }
}
