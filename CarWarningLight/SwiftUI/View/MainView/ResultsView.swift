//
//  ResultsView.swift
//  CarWarningLight
//
//  Created by Sam Greenhill on 4/27/25.
//  Copyright © 2025 simplyAmazingMachines. All rights reserved.
//

import SwiftUI

struct ResultsView: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject var viewModel = ResultsViewModel()
    let detectedLights: [CarSymbol]
    @Namespace private var animation

    // Layout Constraints
    private let gridColumns = [

        GridItem(.adaptive(minimum: 300, maximum: 300), spacing: 16)
    ]

    private let cardCornerRadius: CGFloat = 16

    var body: some View {
        ZStack {

            Color(.systemGroupedBackground)
                .ignoresSafeArea()

            content
                .opacity(viewModel.isShowingLarge ? 0 : 1)


            if let index = viewModel.selectedIndex {
                ExpandedView(
                    carSymbol: detectedLights[index],
                    namespace: animation,
                    isShowingLarge: $viewModel.isShowingLarge,
                    bigImageId: viewModel.bigImageId,
                    index: $viewModel.selectedIndex
                )
                .transition(.opacity.combined(with: .scale))
                .toolbar(.hidden)
                .opacity(viewModel.isShowingLarge ? 1 : 0)
                .zIndex(2)
            }

        }
        .navigationTitle("Results")
        .navigationBarTitleDisplayMode(.inline)
    }

    private var content: some View {
        ScrollView {
            LazyVStack(spacing: 12) {
                ForEach(Array(detectedLights.enumerated()), id: \.offset) { index, carLight in
                    cardView(carSymbol: carLight, index: index)
                        .onTapGesture {
                            viewModel.selectedIndex = index
                            withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
                                viewModel.isShowingLarge = true
                            }
                        }
                }
            }
            .padding()
            .padding(.bottom, 80)
        }
        .scrollIndicators(.hidden)
    }

    @ViewBuilder
    func cardView(carSymbol: CarSymbol, index: Int) -> some View {
        HStack(spacing: 16) {
            Image(carSymbol.imageName)
                .resizable()
                .renderingMode(.template)
                .matchedGeometryEffect(
                    id: "\(index) logo",
                    in: animation,
                    isSource: true
                )
                .foregroundStyle(carSymbol.symbolType.color)
                .scaledToFit()
                .frame(
                    width: DesignSystem.Dimensions.iconSize,
                    height: DesignSystem.Dimensions.iconSize
                )
                .padding(DesignSystem.Dimensions.smallPadding)
                .background(
                    Circle()
                        .fill(Color(.tertiarySystemBackground))
                        .modifier(DesignSystem.Shadows.elevationEffect(radius: 4))
                )


            VStack(alignment: .leading, spacing: 4) {
                Text(carSymbol.name)
                    .font(DesignSystem.Typography.headline)
                    .foregroundColor(.primary)
                    .lineLimit(1)

                Text(carSymbol.symbolType.title)
                    .font(DesignSystem.Typography.caption)
                    .foregroundStyle(.secondary)
            }
            Spacer()
            Image(systemName: "chevron.right")
                .foregroundStyle(.secondary)
                .font(.system(size: 14, weight: .semibold))
        }
        .padding(.vertical, 12)
        .padding(.horizontal, 16)
        .frame(maxWidth: .infinity)
        .modifier(CardStyle())
    }
}



#Preview {
    let bundleLight: [CarSymbol] = Bundle.main.decode([CarSymbol].self, from: "carLights.json")

    lazy var lights: [CarSymbol] = {
        Array(bundleLight.prefix(10))
    }()
    ResultsView(detectedLights: lights)
        .environmentObject(UIStateManager())
}
