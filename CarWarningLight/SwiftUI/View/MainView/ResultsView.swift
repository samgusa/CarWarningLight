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
                .frame(width: 44, height: 44)
                .padding(8)
                .background(
                    Circle()
                        .fill(Color(.systemBackground))
                        .shadow(color: .black.opacity(0.1), radius: 4, x: 0, y: 2)
                )


            VStack(alignment: .leading, spacing: 4) {
                Text(carSymbol.name)
                    .font(.headline)
                    .foregroundColor(.primary)
                    .lineLimit(1)
                    //.minimumScaleFactor(0.9)

                Text(carSymbol.symbolType.title)
                    .font(.subheadline)
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
        .background(
            RoundedRectangle(cornerRadius: cardCornerRadius)
                .fill(Color(.systemBackground))
        )
        .overlay(
            RoundedRectangle(cornerRadius: cardCornerRadius)
                .stroke(Color(.systemGray5), lineWidth: 1)
        )
        .shadow(color: .black.opacity(0.05), radius: 2, x: 0, y: 1)
    }
}

struct AppButtonStyle: ButtonStyle {
    var backgroundColor: Color = .blue
    var foregroundColor: Color = .white
    var isProminent: Bool = true

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .frame(maxWidth: isProminent ? .infinity : nil)
            .background(backgroundColor)
            .font(.headline)
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .scaleEffect(configuration.isPressed ? 0.98 : 1.0)
            .opacity(configuration.isPressed ? 0.9 : 1.0)
            .animation(.easeOut(duration: 0.1), value: configuration.isPressed)
    }
}

struct AppIconButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.92 : 1.0)
            .opacity(configuration.isPressed ? 0.7 : 1.0)
            .animation(.easeOut(duration: 0.1), value: configuration.isPressed)
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
