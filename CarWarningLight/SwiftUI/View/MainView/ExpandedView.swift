//
//  ExpandedView.swift
//  CarWarningLight
//
//  Created by Sam Greenhill on 4/27/25.
//  Copyright © 2025 simplyAmazingMachines. All rights reserved.
//

import SwiftUI

struct ExpandedView: View {
    @EnvironmentObject private var uiState: UIStateManager

    let carSymbol: CarSymbol
    var namespace: Namespace.ID
    @Binding var isShowingLarge: Bool
    let bigImageId: Int
    @Binding var index: Int?

    @StateObject var viewModel = ExpandedViewModel()

    var body: some View {
        GeometryReader { geometry in
            ScrollView {
                ZStack {
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color(.systemBackground))
                        .frame(maxHeight: .infinity)
                        .ignoresSafeArea()

                    VStack {
                        HStack {
                            Spacer()
                            Button {
                                withAnimation(.easeInOut(duration: 0.5)) {
                                    isShowingLarge = false
                                } completion: {
                                    index = nil
                                }
                            } label: {
                                Image(systemName: "x.circle.fill")
                                    .resizable()
                                    .scaledToFit()
                                    .font(.largeTitle)
                                    .foregroundStyle(.gray.opacity(0.7))
                                    .frame(width: 30, height: 30)
                            }
                        }
                        .padding([.top, .trailing])
                        .padding(.top, 50)

                        VStack(spacing: 10) {
                            Image(carSymbol.imageName)
                                .resizable()
                                .renderingMode(.template)
                                .matchedGeometryEffect(
                                    id: isShowingLarge ? "\(bigImageId)" : "\(index ?? 0) logo",
                                    in: namespace,
                                    isSource: false)
                                .foregroundStyle(carSymbol.symbolType.color)
                                .scaledToFit()
                                .frame(width: geometry.size.width / 1.5, height: geometry.size.width / 1.5)

                            Text(carSymbol.name)
                                .padding(.horizontal)
                                .font(.largeTitle)
                                .foregroundColor(.primary)
                                .bold()
                                .opacity(viewModel.showText ? 1 : 0)
                                .offset(y: viewModel.showText ? 0 : viewModel.textOffset)
                                .animation(.easeOut(duration: 0.4), value: viewModel.showText)
                                .multilineTextAlignment(.center)
                                .id("titleAnchor")

                            // First card
                            if viewModel.showContent {
                                cardView(title: "Description", description: carSymbol.description)
                                    .padding(.horizontal)
                                    .offset(y: viewModel.descriptionOffset)
                                    .opacity(viewModel.descriptionOpacity)
                                    .id("card1")

                                // Second card
                                cardView(title: "How to Fix", description: carSymbol.fixDescription)
                                    .padding(.horizontal)
                                    .offset(y: viewModel.fixOffset)
                                    .opacity(viewModel.fixOpacity)
                                    .id("card2")

                                // Third card
                                cardView(title: "Safe to drive?", description: "\(carSymbol.drivable.title)! \(carSymbol.drivable.message)")
                                    .padding(.horizontal)
                                    .offset(y: viewModel.driveOffset)
                                    .opacity(viewModel.driveOpacity)
                                    .id("card3")
                            }
                        }
                        .padding(.bottom)
                    }
                }
            }
            .onAppear {
                uiState.detailViewAppeared(id: carSymbol.imageName)

                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    viewModel.showText = true

                    // Start the cascade animation sequence
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                        viewModel.startCardAnimations()
                    }
                }
            }
            .onDisappear {
                uiState.detailViewDisappeared(id: carSymbol.imageName)
            }
        }
        .ignoresSafeArea()
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

func coloredText(_ text: String) -> Text {
    var output: Text = Text("")
    let words = text.components(separatedBy: " ")

    for (index, word) in words.enumerated() {
        // Extract the base word without punctuation for color checking
        let baseWord = word.lowercased().trimmingCharacters(in: .punctuationCharacters)

        // Find the color if the base word matches
        var color: Color?
        switch baseWord {
        case "yellow":
            color = .yellow
        case "green":
            color = .green
        case "red":
            color = .red
        case "orange":
            color = .orange
        default:
            break
        }

        if let color = color {
            // Find the range of the base word within the original word
            if let range = word.range(of: baseWord, options: .caseInsensitive) {
                // Extract prefix (punctuation before the word)
                let prefix = word[..<range.lowerBound]
                if !prefix.isEmpty {
                    output = output + Text(String(prefix))
                }

                // Add the colored word
                output = output + Text(word[range])
                    .foregroundStyle(color)
                    .bold()
                    .underline()

                // Extract suffix (punctuation after the word)
                let suffix = word[range.upperBound...]
                if !suffix.isEmpty {
                    output = output + Text(String(suffix))
                }
            } else {
                // Fallback if range not found
                output = output + Text(word)
            }
        } else {
            // Add normal word
            output = output + Text(word)
        }

        // Add space between words, but not after the last word
        if index < words.count - 1 {
            output = output + Text(" ")
        }
    }

    return output
}

#Preview {
    @Previewable @Namespace var namespace
    @Previewable @State var toggled = false
    ExpandedView(
        carSymbol: CarSymbol
            .init(
                id: 0,
                name: "Adaptive Front Lighting System Warning",
                imageName: CarWarning.adaptiveOne.rawValue,
                description: "Depending on the make of the vehicle and the color of the light, this could mean a couple things. Green: Directional Headlights. Indicates that the vehicles automatic directional headlights are operational. Yellow: Adaptive Warning Light: Some Vehicles have lights that turn on automatically and adjust brightness depending on how dark and light it is. If the light is Yellow, that means that there is a malfunction with the sensor for that light.",
                symbolType: .warning,
                fixDescription: "If this light is on, a professional mechanic should be contacted. If the air bags don't function as they should, they may not work in the case of an emergency.",
                drivable: .no),
        namespace: namespace,
        isShowingLarge: .constant(false),
        bigImageId: -1,
        index: .constant(1))
    .environmentObject(UIStateManager())
}
