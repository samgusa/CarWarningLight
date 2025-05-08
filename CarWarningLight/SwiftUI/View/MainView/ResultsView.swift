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

    var body: some View {
        ZStack {
            GeometryReader { geometry in
                let cardHeight = min(geometry.size.height / 4, 150)
                ScrollView {
                    LazyVStack(spacing: 20) {
                        ForEach(Array(detectedLights.enumerated()), id: \.offset) { index, carLight in
                            cardView(carSymbol: carLight, height: cardHeight, index: index)
                                .onTapGesture {
                                    viewModel.selectedIndex = index
                                    withAnimation(.easeInOut) {
                                        viewModel.isShowingLarge = true
                                    }
                                }
                        }
                    }
                    .padding(.vertical)
                    .padding(.horizontal)
                    .padding(.bottom, 80)
                }
                .opacity(viewModel.isShowingLarge ? 0 : 1)
            }
            .toolbar {
                ToolbarItemGroup(placement: .topBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }

            if let index = viewModel.selectedIndex {
                ExpandedView(
                    carSymbol: detectedLights[index],
                    namespace: animation,
                    isShowingLarge: $viewModel.isShowingLarge,
                    bigImageId: viewModel.bigImageId,
                    index: $viewModel.selectedIndex
                )
                .toolbar(.hidden)
                .opacity(viewModel.isShowingLarge ? 1 : 0)
            }
        }
    }

    @ViewBuilder
    func cardView(carSymbol: CarSymbol, height: CGFloat, index: Int) -> some View {
        ZStack(alignment: .center) {
            HStack(spacing: 20) {
                Image(carSymbol.imageName)
                    .resizable()
                    .renderingMode(.template)
                    .foregroundStyle(carSymbol.symbolType.color)
                    .scaledToFit()
                    .frame(width: height * 0.7)
                    .matchedGeometryEffect(
                        id: "\(index) logo",
                        in: animation,
                        isSource: true
                    )
                    .padding(.leading, 8)

                Text(carSymbol.name)
                    .font(.title2)
                    .foregroundColor(.primary)
                    .bold()
                    .lineLimit(2)
                    .minimumScaleFactor(0.8)

                Spacer()
           }
        }
        .frame(height: height)
        .frame(maxWidth: .infinity)
        .background(Color(.systemBackground))
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(.black, lineWidth: 1)
        )
    }
}




#Preview {
    let bundleLight: [CarSymbol] = Bundle.main.decode([CarSymbol].self, from: "carLights.json")

    lazy var lights: [CarSymbol] = {
        Array(bundleLight.prefix(10))
    }()
    ResultsView(detectedLights: lights)
        .environmentObject(UIStateManager())//(resultLights: lights)
    //, dismissToHome: {})
}

struct CustomButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .overlay {
                RoundedRectangle(cornerRadius: 10)

            }
    }
}

struct CustomButtonStyleNoBorder: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .overlay {
                RoundedRectangle(cornerRadius: 10)
                    .foregroundStyle(.clear)
            }
    }
}
