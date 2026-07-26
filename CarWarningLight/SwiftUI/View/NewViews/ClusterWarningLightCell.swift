//
//  ClusterWarningLightCell.swift
//  CarWarningLight
//
//  Created by Sam Greenhill on 7/25/26.
//  Copyright © 2026 simplyAmazingMachines. All rights reserved.
//

import SwiftUI

struct ClusterWarningLightCell: View {
    let carData: CarSymbol
    let index: Int
    var namespace: Namespace.ID
    @Binding var isShowingLarger: Bool

    private var telltale: Color { ClusterTheme.Colors.forSymbolType(carData.symbolType) }

    private var shortTypeLabel: String {
        switch carData.symbolType {
        case .advisory: return "ADVISORY"
        case .info: return "INFO"
        case .warning: return "WARNING"
        }
    }
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                glowingIcon
                Spacer()
                Text(shortTypeLabel)
                    .font(ClusterTheme.Types.mono(9, weight: .bold))
                    .tracking(1.0)
                    .foregroundStyle(telltale)
                    .lineLimit(1)
                    .fixedSize()
            }
            Text(carData.name)
                .font(ClusterTheme.Types.body(13, weight: .semibold))
                .foregroundStyle(ClusterTheme.Colors.textPrimary)
                .lineLimit(1)
                .truncationMode(.tail)
                .minimumScaleFactor(0.85)

            Spacer(minLength: 0)
        }
        .padding(12)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        .clusterPanel()
    }

    private var glowingIcon: some View {
        ZStack {
            Circle()
                .fill(telltale)
                .frame(width: 30, height: 30)
                .blur(radius: 10)
                .opacity(0.55)

            Image(carData.imageName)
                .resizable()
                .renderingMode(.template)
                .matchedGeometryEffect(id: "\(index) logo", in: namespace, isSource: true)
                .foregroundStyle(telltale)
                .scaledToFit()
                .frame(width: 22, height: 22)
        }
        .accessibilityHidden(true)
    }
}

#Preview {
    struct PreviewHost: View {
        @Namespace var ns
        @State var isShowingLarger: Bool = false
        let names: [(String, SymbolType)] = [
            ("Automatic Emergency Braking", .warning),
            ("Battery Charging Light", .warning),
            ("Adaptive Front Lighting System", .advisory),
            ("Water in Diesel Filter Warning", .advisory),
            ("Daytime Running Lamp Light", .info),
            ("Child Safety Lock", .info)
        ]
        var body: some View {
            LazyVGrid(
                columns: [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())],
                spacing: 10
            ) {
                ForEach(Array(names.enumerated()), id: \.offset) { i, item in
                    ClusterWarningLightCell(
                        carData: CarSymbol(
                            id: i,
                            name: item.0,
                            imageName: "exclamationmark.triangle.fill",
                            description: "",
                            symbolType: item.1,
                            fixDescription: "",
                            drivable: .yes,
                            categories: nil
                        ),
                        index: i,
                        namespace: ns,
                        isShowingLarger: $isShowingLarger
                    )
                    .frame(height: 92)
                }
            }
            .padding()
            .background(ClusterTheme.Colors.background)
        }
    }
    return PreviewHost()
}
