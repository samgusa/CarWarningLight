//
//  ClusterScanResultsView.swift
//  CarWarningLight
//
//  Created by Sam Greenhill on 7/27/26.
//  Copyright © 2026 simplyAmazingMachines. All rights reserved.
//

import SwiftUI

struct ClusterScanResultsView: View {
    @Environment(\.dismiss) private var dismiss
    let matches: [ScanMatch]
    var onSelect: (CarSymbol) -> Void = { _ in }

    private var top: ScanMatch? { matches.first }
    private var alternates: [ScanMatch] { Array(matches.dropFirst()) }

    var body: some View {
        ZStack {
            ClusterTheme.Colors.background
                .ignoresSafeArea()

            ScrollView {
                VStack(spacing: 20) {
                    ClusterHeaderBar(title: "Scan") { dismiss() }
                    if let top {
                        confidenceGauge(for: top)
                    } else {
                        noMatchState
                    }
                    if !alternates.isEmpty { alternatesSection }
                }
                .padding(.bottom, 24)
            }
            .safeAreaPadding(.top)
        }
    }

    private var header: some View {
        HStack {
            Text("SCAN RESULT")
                .font(ClusterTheme.Types.mono(11, weight: .bold))
                .tracking(1.5)
                .foregroundStyle(ClusterTheme.Colors.textSecondary)
            Spacer()
            Button { dismiss() } label: {
                Image(systemName: "xmark")
                    .font(.system(size: 13, weight: .bold))
                    .foregroundStyle(ClusterTheme.Colors.textPrimary)
                    .frame(width: 28, height: 28)
                    .background(ClusterTheme.Colors.panel)
                    .overlay(
                        RoundedRectangle(cornerRadius: 6)
                            .stroke(ClusterTheme.Colors.bezel, lineWidth: 1)
                    )
                    .clipShape(RoundedRectangle(cornerRadius: 6))
            }
        }
        .padding()
        .background(ClusterTheme.Colors.panel)
    }

    private func confidenceGauge(for match: ScanMatch) -> some View {
        let telltale = ClusterTheme.Colors.forSymbolType(match.carSymbol.symbolType)
        return Button {
            onSelect(match.carSymbol)
            dismiss()
        } label: {
            VStack(spacing: 16) {
                ZStack {
                    Circle()
                        .trim(from: 0.12, to: 0.88)
                        .stroke(ClusterTheme.Colors.bezel, style: StrokeStyle(lineWidth: 9, lineCap: .round))
                        .rotationEffect(.degrees(90))

                    Circle()
                        .trim(from: 0.12, to: 0.12 + 0.76 * match.confidence)
                        .stroke(telltale, style: StrokeStyle(lineWidth: 9, lineCap: .round))
                        .rotationEffect(.degrees(90))
                        .shadow(color: telltale.opacity(0.6), radius: 8)

                    VStack(spacing: 2) {
                        Text("\(Int(match.confidence * 100))%")
                            .font(ClusterTheme.Types.display(30))
                            .foregroundStyle(ClusterTheme.Colors.textPrimary)
                        Text("MATCH")
                            .font(ClusterTheme.Types.mono(9, weight: .bold))
                            .tracking(1.2)
                            .foregroundStyle(ClusterTheme.Colors.textSecondary)
                    }
                }
                .frame(width: 160, height: 160)
                .padding(.top, 8)

                HStack(spacing: 10) {
                    Image(match.carSymbol.imageName)
                        .resizable()
                        .renderingMode(.template)
                        .scaledToFit()
                        .frame(width: 22, height: 22)
                        .foregroundStyle(telltale)
                        .frame(width: 40, height: 40)
                        .background(Circle().fill(telltale.opacity(0.15)))

                    VStack(alignment: .leading, spacing: 2) {
                        Text(match.carSymbol.name)
                            .font(ClusterTheme.Types.display(16))
                            .foregroundStyle(ClusterTheme.Colors.textPrimary)
                        Text(match.carSymbol.symbolType.title.uppercased())
                            .font(ClusterTheme.Types.mono(9, weight: .bold))
                            .tracking(1.0)
                            .foregroundStyle(telltale)
                    }
                    Spacer()
                    Image(systemName: "chevron.right")
                        .font(.system(size: 13, weight: .semibold))
                        .foregroundStyle(ClusterTheme.Colors.textSecondary)
                }
            }
            .padding(16)
            .frame(maxWidth: .infinity)
            .clusterPanel()
            .padding(.horizontal)
        }
        .buttonStyle(.plain)
    }

    private var alternatesSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("OTHER POSSIBLE MATCHES")
                .font(ClusterTheme.Types.mono(10, weight: .bold))
                .tracking(1.0)
                .foregroundStyle(ClusterTheme.Colors.textSecondary)
                .padding(.horizontal)

            ForEach(Array(alternates.enumerated()), id: \.offset) { _, alt in
                Button {
                    onSelect(alt.carSymbol)
                    dismiss()
                } label: {
                    HStack(spacing: 10) {
                        Image(alt.carSymbol.imageName)
                            .resizable()
                            .renderingMode(.template)
                            .scaledToFit()
                            .frame(width: 18, height: 18)
                            .foregroundStyle(ClusterTheme.Colors.textSecondary)
                        Text(alt.carSymbol.name)
                            .font(ClusterTheme.Types.body(13, weight: .medium))
                            .foregroundStyle(ClusterTheme.Colors.textPrimary.opacity(0.85))
                        Spacer()
                        Text("\(Int(alt.confidence * 100))%")
                            .font(ClusterTheme.Types.mono(11, weight: .semibold))
                            .foregroundStyle(ClusterTheme.Colors.textSecondary)
                    }
                    .padding(12)
                    .clusterPanel()
                    .padding(.horizontal)
                    .opacity(0.75)
                }
                .buttonStyle(.plain)
            }
        }
    }

    private var noMatchState: some View {
        VStack(spacing: 10) {
            Image(systemName: "questionmark.circle")
                .font(.system(size: 32))
                .foregroundStyle(ClusterTheme.Colors.textSecondary)
            Text("No confident match")
                .font(ClusterTheme.Types.body(15, weight: .semibold))
                .foregroundStyle(ClusterTheme.Colors.textPrimary)
            Text("Try again with the light centered and well lit.")
                .font(ClusterTheme.Types.body(13))
                .foregroundStyle(ClusterTheme.Colors.textSecondary)
                .multilineTextAlignment(.center)
        }
        .padding(.vertical, 60)
        .padding(.horizontal, 40)
    }
}
