//
//  ResultsView.swift
//  CarWarningLight
//
//  Created by Sam Greenhill on 4/27/25.
//  Copyright © 2025 simplyAmazingMachines. All rights reserved.
//

import SwiftUI

struct ResultsView: View {
    @StateObject var viewModel = ResultsViewModel()
    let bundleLight: [CarSymbol] = Bundle.main.decode([CarSymbol].self, from: "carLights.json")
    @Namespace private var animation
    @State private var selectedIndex: Int? = nil
    @State private var isShowingLarge: Bool = false
    let bigImageId: Int = -1

    var body: some View {
        ZStack {
            GeometryReader { geometry in
                let cardHeight = min(geometry.size.height / 4, 150)
                ScrollView {
                    LazyVStack(spacing: 20) {
                        ForEach(Array(bundleLight.enumerated().prefix(10)), id: \.offset) { index, carLight in
                            cardView(carSymbol: carLight, height: cardHeight, index: index)
                                .matchedGeometryEffect(
                                    id: index,
                                    in: animation,
                                    isSource: true
                                )
                                .onTapGesture {
                                    selectedIndex = index
                                    withAnimation(.easeInOut) {
                                        isShowingLarge = true
                                    }
                                }
                        }
                    }
                    .padding(.vertical)
                    .padding(.horizontal)
                    .padding(.bottom, 80)
                }
                .opacity(isShowingLarge ? 0 : 1)
            }

            if let index = selectedIndex {
                ExpandedView(
                    carSymbol: bundleLight[index],
                    namespace: animation,
                    isShowingLarge: $isShowingLarge,
                    bigImageId: bigImageId,
                    index: $selectedIndex
                )
                .matchedGeometryEffect(
                    id: isShowingLarge ? bigImageId : index,
                    in: animation,
                    isSource: false
                )
                .opacity(isShowingLarge ? 1 : 0)
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
                    .matchedGeometryEffect(
                        id: "\(index) logo",
                        in: animation,
                        isSource: true
                    )
                    .foregroundStyle(carSymbol.symbolType.color)
                    .scaledToFit()
                    .frame(width: height * 0.7)
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
    ResultsView()
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
