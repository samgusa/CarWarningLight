//
//  ClusterUIComponents.swift
//  CarWarningLight
//
//  Created by Sam Greenhill on 8/18/26.
//  Copyright © 2026 simplyAmazingMachines. All rights reserved.
//

import SwiftUI


struct ClusterSquareIconButton: View {
    var icon: String
    var tint: Color = ClusterTheme.Colors.amber
    var size: CGFloat = 32
    var action: () -> Void


    var body: some View {
        Button(action: action) {
            Image(systemName: icon)
                .font(.system(size: size * 0.42, weight: .bold))
                .foregroundStyle(ClusterTheme.Colors.background)
                .frame(width: size, height: size)
                .background(tint)
                .clipShape(RoundedRectangle(cornerRadius: 8))
        }
        .buttonStyle(PressedButtonStyle())
    }
}

struct ClusterTagButton: View {
    var icon: String
    var label: String
    var tint: Color = ClusterTheme.Colors.amber
    var action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 6) {
                Image(systemName: icon)
                    .font(.system(size: 12, weight: .bold))
                Text(label.uppercased())
                    .font(ClusterTheme.Types.mono(11, weight: .bold))
                    .tracking(0.8)
            }
            .foregroundStyle(ClusterTheme.Colors.background)
            .padding(.horizontal, 12)
            .padding(.vertical, 9)
            .background(tint)
            .clipShape(RoundedRectangle(cornerRadius: 8))
        }
        .buttonStyle(PressedButtonStyle())
    }
}

struct ClusterDashedActionTile: View {
    var icon: String
    var label: String
    var height: CGFloat = 150
    var action: () -> Void

    var body: some View {
        Button(action: action) {
            VStack(spacing: 10) {
                Image(systemName: icon)
                    .font(.system(size: 22, weight: .semibold))
                    .foregroundStyle(ClusterTheme.Colors.amber)
                Text(label)
                    .font(ClusterTheme.Types.body(14, weight: .bold))
                    .foregroundStyle(ClusterTheme.Colors.textPrimary)
            }
            .frame(maxWidth: .infinity)
            .frame(height: height)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(style: StrokeStyle(lineWidth: 1.5, dash: [6, 5]))
                    .foregroundStyle(ClusterTheme.Colors.amber.opacity(0.6))
            )
        }
        .buttonStyle(PressedButtonStyle())
    }
}

struct ClusterAccentBanner: View {
    var icon: String
    var title: String
    var subtitle: String
    var tint: Color = ClusterTheme.Colors.amber

    var body: some View {
        HStack(spacing: 0) {
            Rectangle()
                .fill(tint)
                .frame(width: 5)

            HStack(alignment: .top, spacing: 10) {
                Image(systemName: icon)
                    .font(.system(size: 15, weight: .bold))
                    .foregroundStyle(tint)
                    .padding(.top, 1)
                VStack(alignment: .leading, spacing: 2) {
                    Text(title)
                        .font(ClusterTheme.Types.body(14, weight: .bold))
                        .foregroundStyle(ClusterTheme.Colors.textPrimary)
                    Text(subtitle)
                        .font(ClusterTheme.Types.body(12))
                        .foregroundStyle(ClusterTheme.Colors.textSecondary)
                }
                Spacer(minLength: 0)
            }
            .padding(14)
        }
        .background(ClusterTheme.Colors.panel)
        .clipShape(RoundedRectangle(cornerRadius: 8))
        .overlay(
            RoundedRectangle(cornerRadius: 8)
                .stroke(ClusterTheme.Colors.bezel, lineWidth: 1)
        )
    }
}

struct ClusterVehicleImagePlate: View {
    var imageName: String
    var size: CGFloat = 54

    var body: some View {
        Image(imageName)
            .resizable()
            .renderingMode(.template)
            .foregroundStyle(.white)
            .scaledToFit()
            .frame(width: size, height: size)
            .padding(6)
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(Color(white: 0.92), lineWidth: 1)
            )
//            .background(
//                RoundedRectangle(cornerRadius: 8)
//                    .fill(Color(white: 0.92))
//            )
    }
}

struct ClusterCategoryChip: View {
    var icon: String
    var label: String
    var isSelected: Bool
    var action: () -> Void

    var body: some View {
        Button(action: action) {
            VStack(spacing: 6) {
                Image(systemName: icon)
                    .font(.system(size: 16, weight: .semibold))
                Text(label.uppercased())
                    .font(ClusterTheme.Types.mono(9, weight: .bold))
                    .tracking(0.4)
                    .multilineTextAlignment(.center)
                    .lineLimit(2)
                    .minimumScaleFactor(0.85)
            }
            .foregroundStyle(isSelected ? ClusterTheme.Colors.background : ClusterTheme.Colors.textPrimary)
            .frame(maxWidth: .infinity)
            .frame(height: 72)
            .background(isSelected ? ClusterTheme.Colors.amber : ClusterTheme.Colors.panel)
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(isSelected ? .clear : ClusterTheme.Colors.bezel, lineWidth: 1)
            )
            .clipShape(RoundedRectangle(cornerRadius: 10))
        }
        .buttonStyle(.plain)
    }
}

struct ClusterStackedIcon: View {
    var icons: [String]
    var tint: Color
    var isDimmed: Bool = false

    private var effectiveIcons: [String] {
        icons.isEmpty ? ["exclamationmark.circle"] : Array(icons.prefix(3))
    }

    var body: some View {
        let count = effectiveIcons.count
        let step: CGFloat = 4
        let centering = CGFloat(count - 1) * step / 2

        ZStack {
            ForEach(Array(effectiveIcons.enumerated().reversed()), id: \.offset) { index, icon in
                RoundedRectangle(cornerRadius: 8)
                    .fill(ClusterTheme.Colors.panel)
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(ClusterTheme.Colors.bezel, lineWidth: 1)
                    )
                    .overlay(
                        Image(systemName: icon)
                            .font(.system(size: 15, weight: .semibold))
                            .foregroundStyle(isDimmed ? ClusterTheme.Colors.textSecondary : tint)
                    )
                    .frame(width: 34, height: 34)
                    .offset(x: CGFloat(index) * step - centering, y: CGFloat(index) * -step + centering)
            }
        }
        .frame(width: 44, height: 44)
    }
}

struct ClusterCornerCutShape: Shape {
    var cut: CGFloat = 10

    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: cut, y: 0))
        path.addLine(to: CGPoint(x: rect.width, y: 0))
        path.addLine(to: CGPoint(x: rect.width, y: rect.height))
        path.addLine(to: CGPoint(x: 0, y: rect.height))
        path.addLine(to: CGPoint(x: 0, y: cut))
        path.closeSubpath()
        return path
    }
}

struct ClusterCautionLabel: View {
    var icon: String
    var title: String
    var subtitle: String
    var tint: Color = ClusterTheme.Colors.amber

    var body: some View {
        HStack(alignment: .top, spacing: 10) {
            Image(systemName: icon)
                .font(.system(size: 15, weight: .heavy))
                .foregroundStyle(ClusterTheme.Colors.background)
                .frame(width: 28, height: 28)
                .background(ClusterTheme.Colors.background.opacity(0.15))
                .clipShape(RoundedRectangle(cornerRadius: 6))

            VStack(alignment: .leading, spacing: 2) {
                Text(title.uppercased())
                    .font(ClusterTheme.Types.mono(12, weight: .heavy))
                    .tracking(0.6)
                    .foregroundStyle(ClusterTheme.Colors.background)
                Text(subtitle)
                    .font(ClusterTheme.Types.body(12, weight: .semibold))
                    .foregroundStyle(ClusterTheme.Colors.background.opacity(0.8))
            }
            Spacer(minLength: 0)
        }
        .padding(12)
        .background(tint)
        .clipShape(ClusterCornerCutShape(cut: 10))
    }
}

struct ClusterParallelogramShape: Shape {
    var skew: CGFloat = 8

    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: skew, y: 0))
        path.addLine(to: CGPoint(x: rect.width, y: 0))
        path.addLine(to: CGPoint(x: rect.width - skew, y: rect.height))
        path.addLine(to: CGPoint(x: 0, y: rect.height))
        path.closeSubpath()
        return path
    }
}

struct ClusterAngledButton: View {
    var icon: String
    var label: String
    var tint: Color = ClusterTheme.Colors.amber
    var action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 6) {
                Image(systemName: icon)
                    .font(.system(size: 12, weight: .bold))
                Text(label.uppercased())
                    .font(ClusterTheme.Types.mono(11, weight: .bold))
                    .tracking(0.8)
            }
            .foregroundStyle(ClusterTheme.Colors.background)
            .padding(.horizontal, 18)
            .padding(.vertical, 9)
            .background(tint)
            .clipShape(ClusterParallelogramShape(skew: 8))
        }
        .buttonStyle(PressedButtonStyle())
    }

}

struct ClusterStatusToggle: View {
    var isActive: Bool
    var activeTint: Color = ClusterTheme.Colors.amber
    var resolvedTint: Color = ClusterTheme.Colors.green
    var action: () -> Void

    private var tint: Color { isActive ? activeTint : resolvedTint }

    var body: some View {
        Button(action: action) {
            HStack(spacing: 12) {
                ZStack {
                    Circle()
                        .fill(tint)
                        .frame(width: 22, height: 22)
                        .blur(radius: 10)
                        .opacity(0.7)
                    Circle()
                        .fill(tint)
                        .frame(width: 10, height: 10)
                    Circle()
                        .stroke(tint.opacity(0.5), lineWidth: 1)
                        .frame(width: 22, height: 22)
                }
                .frame(width: 28, height: 28)

                VStack(alignment: .leading, spacing: 1) {
                    Text(isActive ? "ACTIVE" : "RESOLVED")
                        .font(ClusterTheme.Types.mono(12, weight: .bold))
                        .tracking(1.0)
                        .foregroundStyle(tint)
                    Text(isActive ? "Tap to mark resolved" : "Tap to mark active again")
                        .font(ClusterTheme.Types.body(12))
                        .foregroundStyle(ClusterTheme.Colors.textSecondary)
                }

                Spacer(minLength: 0)

                Image(systemName: isActive ? "checkmark" : "arrow.uturn.backward")
                    .font(.system(size: 13, weight: .bold))
                    .foregroundStyle(ClusterTheme.Colors.textSecondary)
            }
            .padding(14)
            .background(ClusterTheme.Colors.panel)
            .overlay(
                ClusterCornerCutShape(cut: 10)
                    .stroke(ClusterTheme.Colors.bezel, lineWidth: 1)
            )
            .clipShape(ClusterCornerCutShape(cut: 10))
        }
        .buttonStyle(PressedButtonStyle())
    }
}

struct ClusterConsoleActionButton: View {
    var icon: String
    var label: String
    var tint: Color = ClusterTheme.Colors.amber
    var isEnabled: Bool = true
    var action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 10) {
                Image(systemName: icon)
                    .font(.system(size: 15, weight: .bold))
                Text(label.uppercased())
                    .font(ClusterTheme.Types.mono(13, weight: .bold))
                    .tracking(0.6)
                Spacer(minLength: 0)
            }
            .foregroundStyle(isEnabled ? ClusterTheme.Colors.background : ClusterTheme.Colors.textSecondary)
            .padding(14)
            .frame(maxWidth: .infinity)
            .background(isEnabled ? tint : ClusterTheme.Colors.bezel)
            .clipShape(ClusterCornerCutShape(cut: 10))
        }
        .buttonStyle(PressedButtonStyle())
        .disabled(!isEnabled)
    }
}
