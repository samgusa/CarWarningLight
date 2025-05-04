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
    @Namespace private var animation
    let bundleLight: [CarSymbol] = Bundle.main.decode([CarSymbol].self, from: "carLights.json")

    var body: some View {
        GeometryReader { geometry in
            let cardHeight = min(geometry.size.height / 4, 150)
            NavigationStack {
                ScrollView {
                    LazyVStack(spacing: 20) {
                        ForEach(bundleLight.prefix(10), id: \.id) { carLight in
                            NavigationLink(value: carLight) {
                                cardView(carSymbol: carLight, height: cardHeight)
                                    .matchedTransitionSource(id: carLight.id, in: animation) {
                                        $0
                                            .background(.clear)
                                            .clipShape(.rect(cornerRadius: 15))
                                    }
                            }
                            .buttonStyle(CustomButtonStyle())

                        }
                    }
                    .padding(.vertical)
                    .padding(.horizontal)
                    .padding(.bottom, 80)
                }
                .navigationDestination(for: CarSymbol.self) { carSymbol in
                    ExpandedView(carSymbol: carSymbol, namespace: animation)
                        .toolbarVisibility(.hidden, for: .navigationBar)
                }

            }
        }
    }
}

@ViewBuilder
func cardView(carSymbol: CarSymbol, height: CGFloat) -> some View {
    ZStack(alignment: .center) {
        HStack(spacing: 20) {
            Image(carSymbol.imageName)
                .resizable()
                .renderingMode(.template)
                .foregroundStyle(carSymbol.symbolType.color)
                .scaledToFit()
                .frame(width: height * 0.7)
                .padding(.leading, 8)

            Text(carSymbol.name)
                .font(.title2) // More responsive font size
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
    .cornerRadius(10)
    .shadow(color: Color.primary.opacity(0.1), radius: 4, x: 0, y: 2)
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
                    .stroke(.primary, lineWidth: 1)
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
