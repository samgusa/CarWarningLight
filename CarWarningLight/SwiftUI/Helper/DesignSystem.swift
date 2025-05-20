//
//  DesignSystem.swift
//  CarWarningLight
//
//  Created by Sam Greenhill on 5/20/25.
//  Copyright © 2025 simplyAmazingMachines. All rights reserved.
//

import SwiftUI

enum DesignSystem {
    
    struct Colors {
        static let cardBackground = Color(.secondarySystemGroupedBackground)
        static let cardStroke = Color(.separator)
        static let accent = Color.accentColor
    }
    
    struct Dimensions {
        static let cardCornerRadius: CGFloat = 16
        static let standardPadding: CGFloat = 16
        static let smallPadding: CGFloat = 8
        static let iconSize: CGFloat = 44
        static let gridSpacing: CGFloat = 12
    }
    
    struct Shadows {
        // Light mode shadow
        static func lightShadow() -> some View {
            return Color.black.opacity(0.1)
        }
        
        // Dark mode-friendly shadow
        static func adaptiveShadow() -> some View {
            return Color.primary.opacity(0.05)
        }
        
        // Apply an elevation effect appropriate for both modes
        static func elevationEffect(radius: CGFloat = 8, opacity: Double = 0.1) -> some ViewModifier {
            return ShadowModifier(radius: radius, opacity: opacity)
        }
    }
    
    // MARK: - Typography
    struct Typography {
        static let title = Font.system(.title, design: .rounded).weight(.bold)
        static let title2 = Font.system(.title2, design: .rounded).weight(.bold)
        static let headline = Font.system(.headline, design: .rounded).weight(.semibold)
        static let body = Font.system(.body, design: .rounded)
        static let caption = Font.system(.caption, design: .rounded)
    }
    
    struct FAB {
        // Primary FAB color (adapts to dark mode)
        static var primaryBackground: Color {
            Color.accentColor
        }
        
        // Secondary action colors
        static func actionBackground(for index: Int) -> Color {
            let colors: [Color] = [
                Color(.systemBlue),
                Color(.systemGreen),
                Color(.systemOrange),
                Color(.systemPurple),
                Color(.systemTeal)
            ]
            
            return colors[index % colors.count]
        }
        
        // FAB Icon tint that adapts to background
        static func iconTint(for backgroundColor: Color) -> Color {
            // For most accent colors, white works well in both modes
            return .white
        }
        
        // FAB shadow
        static var shadow: some ViewModifier {
            return ShadowModifier(radius: 10, opacity: 0.2)
        }
        
        // Animation properties
        static let animationDuration: Double = 0.4
        static let animationBounce: Double = 0
    }
    
}

// Shadow modifier that works well in both light and dark mode
struct ShadowModifier: ViewModifier {
    let radius: CGFloat
    let opacity: Double
    
    @Environment(\.colorScheme) private var colorScheme
    
    func body(content: Content) -> some View {
        content
            .shadow(
                color: colorScheme == .dark ?
                Color.white.opacity(opacity/3) :
                    Color.black.opacity(opacity),
                radius: radius,
                x: 0,
                y: colorScheme == .dark ? -1 : 2
            )
    }
}

// Dark mode optimized card style you can apply to any card
struct CardStyle: ViewModifier {
    @Environment(\.colorScheme) private var colorScheme
    
    func body(content: Content) -> some View {
        content
            .background(DesignSystem.Colors.cardBackground)
            .clipShape(RoundedRectangle(cornerRadius: DesignSystem.Dimensions.cardCornerRadius))
            .overlay(
                RoundedRectangle(cornerRadius: DesignSystem.Dimensions.cardCornerRadius)
                    .stroke(
                        colorScheme == .dark ?
                        Color.white.opacity(0.08) :
                            Color.black.opacity(0.05),
                        lineWidth: 0.5
                    )
            )
            .modifier(DesignSystem.Shadows.elevationEffect())
    }
}
