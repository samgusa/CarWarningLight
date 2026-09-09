//
//  ClusterWarningLightCell.swift
//  Changes from your version: icon enlarged from 22x22 to 38x38 (matches the
//  detail screen's hero icon size exactly — this also smooths out the
//  matchedGeometryEffect transition, since it no longer has to scale the
//  icon up mid-flight) and title lineLimit raised from 1 to 3 so the
//  card's empty space gets used for the full name instead of sitting blank.

import SwiftUI

struct ClusterWarningLightCell: View {
    let carData: CarSymbol
    let index: Int
    var namespace: Namespace.ID
    @Binding var isShowingLarger: Bool

    private var telltale: Color { ClusterTheme.Colors.forSymbolType(carData.symbolType) }

    private var typeLetter: String {
        switch carData.symbolType {
        case .advisory: return "A"
        case .info: return "I"
        case .warning: return "W"
        }
    }

    var body: some View {
        VStack(alignment: .center, spacing: 10) {
            glowingIcon
            Spacer()
            Text(carData.name)
                .font(ClusterTheme.Types.body(13, weight: .semibold))
                .foregroundStyle(ClusterTheme.Colors.textPrimary)
                .lineLimit(3)
                .minimumScaleFactor(0.9)

//            Spacer(minLength: 0)
        }
        .padding(12)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        .clusterPanel()
        .matchedGeometryEffect(id: "\(index) card", in: namespace, isSource: true)
    }

    private var typeBadge: some View {
        Text(typeLetter)
            .font(ClusterTheme.Types.mono(10, weight: .bold))
            .foregroundStyle(telltale)
            .frame(width: 20, height: 20)
            .background(
                Circle()
                    .stroke(telltale, lineWidth: 1)
            )
            .opacity(0.5)
            .accessibilityLabel(carData.symbolType.title)
    }

    private var glowingIcon: some View {
        ZStack {
            Circle()
                .fill(telltale)
                .frame(width: 46, height: 46)
                .blur(radius: 14)
                .opacity(0.55)

            Image(carData.imageName)
                .resizable()
                .renderingMode(.template)
                .foregroundStyle(telltale)
                .scaledToFit()
                .frame(width: 38, height: 38)
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
                            imageName: item.0,
                            description: "",
                            symbolType: item.1,
                            fixDescription: "",
                            drivable: .yes
                        ),
                        index: i,
                        namespace: ns,
                        isShowingLarger: $isShowingLarger
                    )
                    .frame(height: 130)
                }
            }
            .padding()
            .background(ClusterTheme.Colors.background)
        }
    }
    return PreviewHost()
}
