//
//  ExpandedView2.swift
//  CarWarningLight
//
//  Created by Sam Greenhill on 5/1/25.
//  Copyright © 2025 simplyAmazingMachines. All rights reserved.
//

import SwiftUI

struct ExpandedView2: View {
    let carSymbol: CarSymbol
    var namespace: Namespace.ID
    @Environment(\.dismiss) private var dismiss


    @StateObject var viewModel = ExpandedViewModel()
    @State private var textOffset: CGFloat = -50

    var body: some View {
        GeometryReader { geometry in
            VStack {
                Spacer()
                HStack {
                    Spacer()
                    Image(carSymbol.imageName)
                        .resizable()
                        .renderingMode(.template)
                        .foregroundStyle(carSymbol.symbolType.color)
                        .scaledToFit()
                        .frame(width: geometry.size.width / 2, height: geometry.size.width / 2)
                    Spacer()
                }
                Spacer()
            }
            .overlay(alignment: .topTrailing) {
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "arrow.left.circle.fill")
                        .font(.title)
                        .foregroundStyle(.white)
                        .background(
                            Circle()
                                .fill(Color.black.opacity(0.6))
                                .padding(-4)
                        )
                }
                .padding(.trailing, 30)
                .padding(.top, 30)
            }
//            let isLandscape = geometry.size.width > geometry.size.height
//            ScrollView {
//                ZStack {
//                    RoundedRectangle(cornerRadius: 12)
//                        .fill(Color(.systemBackground))
//                        .frame(maxHeight: .infinity)
//                        .ignoresSafeArea()
//
//                    VStack {
//                        HStack {
//                            Spacer()
//                            Button {
//                                withAnimation(.easeOut(duration: 0.4)) {
//
//                                }
//                            } label: {
//                                Image(systemName: "x.circle.fill")
//                                    .font(.largeTitle)
//                                    .foregroundStyle(.gray.opacity(0.7))
//                            }
//                        }
//                        .padding([.top, .trailing])
//                        .padding(.top, isLandscape ? 10 : 50)
//
//                        if isLandscape {
//                            // Landscape layout
//                            HStack(alignment: .top, spacing: 20) {
//                                // Left side: Image and title
//                                VStack {
//                                    Image(carSymbol.imageName)
//                                        .resizable()
//                                        .renderingMode(.template)
//                                        .foregroundStyle(carSymbol.symbolType.color)
//                                        .scaledToFit()
//                                        .frame(width: geometry.size.width / 3, height: geometry.size.width / 3)
//
//                                    Text(carSymbol.name)
//                                        .font(.title)
//                                        .foregroundColor(.primary)
//                                        .bold()
//                                        .opacity(viewModel.showText ? 1 : 0)
//                                        .offset(y: viewModel.showText ? 0 : textOffset)
//                                        .animation(.easeOut(duration: 0.4), value: viewModel.showText)
//                                        .multilineTextAlignment(.center)
//                                }
//                                .frame(width: geometry.size.width / 3)
//
//                                // Right side: Information cards
//                                VStack(spacing: 10) {
//                                    cardView(title: "Description", description: carSymbol.description)
//                                        .opacity(viewModel.descriptionOpacity ? 1 : 0)
//                                        .offset(y: viewModel.descriptionOpacity ? 0 : textOffset)
//                                        .animation(.easeOut(duration: 0.4).delay(0.1), value: viewModel.descriptionOpacity)
//
//                                    cardView(title: "How to Fix", description: carSymbol.fixDescription)
//                                        .opacity(viewModel.fixDescriptionOpacity ? 1 : 0)
//                                        .offset(y: viewModel.fixDescriptionOpacity ? 0 : textOffset)
//                                        .animation(.easeOut(duration: 0.4).delay(0.2), value: viewModel.fixDescriptionOpacity)
//
//                                    cardView(title: "Safe to drive?", description: "\(carSymbol.drivable.title)! \(carSymbol.drivable.message)")
//                                        .opacity(viewModel.drivableOpacity ? 1 : 0)
//                                        .offset(y: viewModel.drivableOpacity ? 0 : textOffset)
//                                        .animation(.easeOut(duration: 0.4).delay(0.3), value: viewModel.drivableOpacity)
//                                }
//                                .frame(width: geometry.size.width / 1.7)
//                            }
//                            .padding(.horizontal)
//                        } else {
//                            // Portrait layout (original)
//                            VStack(spacing: 10) {
//                                Image(carSymbol.imageName)
//                                    .resizable()
//                                    .renderingMode(.template)
//                                    .foregroundStyle(carSymbol.symbolType.color)
//                                    .scaledToFit()
//                                    .frame(width: geometry.size.width / 1.5, height: geometry.size.width / 1.5)
//
//                                Text(carSymbol.name)
//                                    .font(.largeTitle)
//                                    .foregroundColor(.primary)
//                                    .bold()
//                                    .opacity(viewModel.showText ? 1 : 0)
//                                    .offset(y: viewModel.showText ? 0 : textOffset)
//                                    .animation(.easeOut(duration: 0.4), value: viewModel.showText)
//                                    .multilineTextAlignment(.center)
//
//                                cardView(title: "Description", description: carSymbol.description)
//                                    .padding()
//                                    .opacity(viewModel.descriptionOpacity ? 1 : 0)
//                                    .offset(y: viewModel.descriptionOpacity ? 0 : textOffset)
//                                    .animation(.easeOut(duration: 0.4).delay(0.1), value: viewModel.descriptionOpacity)
//
//                                cardView(title: "How to Fix", description: carSymbol.fixDescription)
//                                    .padding()
//                                    .opacity(viewModel.fixDescriptionOpacity ? 1 : 0)
//                                    .offset(y: viewModel.fixDescriptionOpacity ? 0 : textOffset)
//                                    .animation(.easeOut(duration: 0.4).delay(0.2), value: viewModel.fixDescriptionOpacity)
//
//                                cardView(title: "Safe to drive?", description: "\(carSymbol.drivable.title)! \(carSymbol.drivable.message)")
//                                    .padding()
//                                    .opacity(viewModel.drivableOpacity ? 1 : 0)
//                                    .offset(y: viewModel.drivableOpacity ? 0 : textOffset)
//                                    .animation(.easeOut(duration: 0.4).delay(0.3), value: viewModel.drivableOpacity)
//                            }
//                        }
//                    }
//                }
//            }
//            .onAppear {
//                withAnimation(.easeOut(duration: 0.4)) {
//                    viewModel.showText = true
//                    viewModel.triggerAnimations()
//                }
//            }
        }
        .ignoresSafeArea()
        .navigationTransition(.zoom(sourceID: carSymbol.id, in: namespace))
    }

    @ViewBuilder
    func cardView(title: String, description: String) -> some View {
        ZStack {
            VStack(alignment: .leading, spacing: 10) {
                Text(title)
                    .font(.title)
                    .foregroundColor(.primary)
                    .bold()

                coloredText(description)
                    .font(.body)
                    .foregroundColor(.primary)
                    .multilineTextAlignment(.leading)
                    .lineSpacing(4)
            }
            .padding()
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .background(Color(.systemBackground))
        .cornerRadius(10)
        .overlay {
            RoundedRectangle(cornerRadius: 10)
                .stroke(.primary, lineWidth: 1)
        }
    }
}

#Preview {
    @Previewable @Namespace var namespace

    ExpandedView2(carSymbol: CarSymbol(
        id: 1,
        name: "Airbag Malfunction",
        imageName: "Air Bag Malfunction",
        description: "This is the air bag malfunction light. This could either say Air Bag, SRS, or a person with a deployed airbag. This light can come in a variety of shapes depending on which air bag is malfunctioning.",
        symbolType: .warning,
        fixDescription: "If this light is on, a professional mechanic should be contacted. If the air bags don't function as they should, they may not work in the case of an emergency.",
        drivable: .no
    ),
                  namespace: namespace) //(resultLights: lights)
    .environmentObject(UIStateManager())
                //, dismissToHome: {})
}

