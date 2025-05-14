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

    // Track when the view is being dismissed to prevent animation conflicts
    @State private var isDismissing: Bool = false
    @State private var hasAppeared: Bool = false

    var body: some View {
        GeometryReader { geometry in
            ScrollView {
                VStack(spacing: 0) {
                    // Header with close button
                    headerView()

                    // mainContent:
                    contentView(geometry: geometry)
                }
                .frame(maxWidth: .infinity)
                .background(Color(.systemBackground))
                .onAppear {
                    uiState.detailViewAppeared(id: carSymbol.imageName)

                    viewModel.resetAnimations()

                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                        viewModel.startAnimations()
                        hasAppeared = true
                    }
                }
                .onDisappear {
                    viewModel.cancelAnimations()
                    uiState.detailViewDisappeared(id: carSymbol.imageName)

                    if !isDismissing {
                        hasAppeared = false
                    }
                }
            }
            .ignoresSafeArea()
        }
    }

    @ViewBuilder
    private func headerView() -> some View {
        HStack {
            Spacer()
            Button {
                withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
                    if !isDismissing {
                        isDismissing = true
                        withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
                            isShowingLarge = false
                        } completion: {
                            index = nil
                            isDismissing = false
                            hasAppeared = false
                        }
                    }

                }
            } label: {
                Image(systemName: "xmark.circle.fill")
                    .resizable()
                    .scaledToFit()
                    .foregroundStyle(.gray.opacity(0.7))
                    .frame(width: 30, height: 30)
                    .contentShape(Circle())
                    .accessibilityLabel("Close")
            }
            .buttonStyle(ScaleButtonStyle())
        }
        .padding([.top, .trailing])
        .padding(.top, 50)
    }

    @ViewBuilder
    private func contentView(geometry: GeometryProxy) -> some View {
        VStack(spacing: 24) {
            // Symbol Image
            Image(carSymbol.imageName)
                .resizable()
                .renderingMode(.template)
                .matchedGeometryEffect(
                    id: isShowingLarge ? "\(bigImageId)" : "\(index ?? 0) logo",
                    in: namespace,
                    isSource: false
                )
                .foregroundStyle(carSymbol.symbolType.color)
                .scaledToFit()
                .frame(width: geometry.size.width / 1.8, height: geometry.size.width / 1.8)
                .padding(.vertical)
                .accessibilityLabel(carSymbol.name)

            // Title
            Text(carSymbol.name)
                .font(.system(.title, design: .rounded).weight(.bold))
                .foregroundColor(.primary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 24)
                .opacity(viewModel.titleOpacity)
                .offset(y: viewModel.titleOffset)
                .animation(.easeOut(duration: 0.4), value: viewModel.showText)

            // Information Cards
            cardsView()
                .padding(.horizontal)
                .padding(.bottom, 24)
        }
    }

    @ViewBuilder
    func cardsView() -> some View {
        VStack(spacing: 16) {
            // Description Card
            InfoCard(
                title: "Description",
                description: carSymbol.description,
                opacity: viewModel.card1Opacity,
                offset: viewModel.card1Offset
            )

            // Fix Card
            InfoCard(
                title: "How to Fix",
                description: carSymbol.fixDescription,
                opacity: viewModel.card2Opacity,
                offset: viewModel.card2Offset
            )

            // Drivability Card
            InfoCard(
                title: "Safe to drive?",
                description: "\(carSymbol.drivable.title)! \(carSymbol.drivable.message)",
                opacity: viewModel.card3Opacity,
                offset: viewModel.card3Offset,
                accentColor: drivableColor(carSymbol.drivable.title)
            )
        }
    }

    private func drivableColor(_ status: String) -> Color? {
        switch status.lowercased() {
        case "yes" : return .green
        case "no" : return .red
        case "caution" : return .orange
        default: return nil
        }
    }

}

func coloredText(_ text: String) -> Text {
    // Pre-define the color mapping
    let colorMap: [String: Color] = [
        "yellow": .yellow,
        "green": .green,
        "red": .red,
        "orange": .orange
    ]

    // Use AttributedString for better performance
    var attributedString = AttributedString(text)

    // Process the string once for all color words
    for (colorWord, color) in colorMap {
        // Use regex to find the word boundaries correctly
        if let regex = try? NSRegularExpression(pattern: "\\b\(colorWord)\\b", options: [.caseInsensitive]) {
            let nsString = text as NSString
            let matches = regex.matches(in: text, options: [], range: NSRange(location: 0, length: nsString.length))

            // Apply attributes for each match
            for match in matches {
                let range = match.range
                if let stringRange = Range(range, in: attributedString) {
                    attributedString[stringRange].foregroundColor = color
                    attributedString[stringRange].font = .headline.bold()
                    attributedString[stringRange].underlineStyle = .single
                }
            }
        }
    }

    // Return a single Text view with the attributed string
    return Text(attributedString)
}


struct InfoCard: View {
    let title: String
    let description: String
    let opacity: Double
    let offset: CGFloat
    var accentColor: Color? = nil

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(title)
                .font(.system(.title2, design: .rounded).weight(.bold))
                .foregroundColor(accentColor ?? .primary)

            coloredText(description)
                .font(.body)
                .foregroundColor(.primary)
                .lineSpacing(5)
                .fixedSize(horizontal: false, vertical: true)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(16)
        .background {
            RoundedRectangle(cornerRadius: 16)
                .stroke(accentColor ?? Color.primary.opacity(0.1), lineWidth: accentColor != nil ? 2 : 1)
        }
        .opacity(opacity)
        .offset(y: offset)
    }
}

struct ScaleButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.92 : 1)
            .animation(.spring(response: 0.3, dampingFraction: 0.7), value: configuration.isPressed)
    }
}

#Preview {
    ContentView()
        .environmentObject(UIStateManager())
}

//#Preview {
//    @Previewable @Namespace var namespace
//    @Previewable @State var toggled = false
//    ExpandedView(
//        carSymbol: CarSymbol
//            .init(
//                id: 0,
//                name: "Adaptive Front Lighting System Warning",
//                imageName: CarWarning.adaptiveOne.rawValue,
//                description: "Depending on the make of the vehicle and the color of the light, this could mean a couple things. Green: Directional Headlights. Indicates that the vehicles automatic directional headlights are operational. Yellow: Adaptive Warning Light: Some Vehicles have lights that turn on automatically and adjust brightness depending on how dark and light it is. If the light is Yellow, that means that there is a malfunction with the sensor for that light.",
//                symbolType: .warning,
//                fixDescription: "If this light is on, a professional mechanic should be contacted. If the air bags don't function as they should, they may not work in the case of an emergency.",
//                drivable: .no,
//                categories: []),
//        namespace: namespace,
//        isShowingLarge: .constant(false),
//        bigImageId: -1,
//        index: .constant(1))
//    .environmentObject(UIStateManager())
//}
