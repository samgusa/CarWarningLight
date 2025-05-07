//
//  TestingMainView.swift
//  CarWarningLight
//
//  Created by Sam Greenhill on 5/6/25.
//  Copyright © 2025 simplyAmazingMachines. All rights reserved.
//

import SwiftUI

struct TestingMainView: View {

    let desiredCellAspectRatio: CGFloat = 1.5
    let spacing: CGFloat = 16
    let minimumCellWidth: CGFloat = 100

    let bundleLight: [CarSymbol] = Bundle.main.decode([CarSymbol].self, from: "carLights.json")
    let columns: [GridItem] = [.init(.flexible()), .init(.flexible())]
    let bigImageId = -1

    @Namespace private var nm
    @State private var selectedIndex: Int?
    @State private var isShowingLarge = false
    @State private var shouldFade: Bool = false

    var body: some View {
        ZStack {
            GeometryReader { geometry in
                let availableWidth = geometry.size.width - (spacing * 2)

                let possibleColumns = Int((availableWidth + spacing) / (minimumCellWidth + spacing))
                let actualColumns = max(1, possibleColumns)

                let cellWidth = (availableWidth - (CGFloat(actualColumns - 1) * spacing)) / CGFloat(actualColumns)
                _ = cellWidth * desiredCellAspectRatio // Calculate height based on the new aspect ratio

                let gridItem = GridItem(.fixed(cellWidth), spacing: spacing)
                let columns = Array(repeating: gridItem, count: actualColumns)
                
                ScrollView {
                    LazyVGrid(columns: columns, spacing: spacing) {
                        ForEach(Array(bundleLight.enumerated()), id: \.offset) { index, light
                            in
                            Color.clear
                                .aspectRatio(1.0, contentMode: .fit)
                                .overlay {
                                    WarningLightCell(
                                        carData: light,
                                        index: index,
                                        namespace: nm,
                                        isShowingLarge: $isShowingLarge
                                    )
                                    .border(Color.black, width: 1)
                                }
                                .clipped()
                                .contentShape(Rectangle())
                                .onTapGesture {
                                    selectedIndex = index 
                                    withAnimation(.easeInOut(duration: 0.5)) {
                                            isShowingLarge = true
                                        }
                                }
                        }
                    }
                }
            }

            // The selected image
            if let index = selectedIndex {
                ExpandedView(
                    carSymbol: bundleLight[index],
                    namespace: nm,
                    isShowingLarge: $isShowingLarge,
                    bigImageId: bigImageId,
                    index: $selectedIndex)
                .opacity(isShowingLarge ? 1 : 0)
            }
        }
    }
}

struct OtherExView: View {
    let carLight: CarSymbol
    var namespace: Namespace.ID
    @Binding var isShowingLarge: Bool
    let bigImageId: Int
    @Binding var index: Int?
    @State var descriptionOpacity: Bool = false
    @State var fixDescriptionOpacity: Bool = false
    @State private var textOffset: CGFloat = -50

    var body: some View {
        VStack {
            ZStack {
                Image(carLight.imageName)
                    .resizable()
                    .scaledToFit()
                    .matchedGeometryEffect(
                        id: isShowingLarge ? "\(bigImageId)" : "\(index ?? 0) logo",
                        in: namespace,
                        isSource: false)
                    .frame(width: 150, height: 150)
            }
            RoundedRectangle(cornerRadius: 25)
                .fill(Color.red)
                .opacity(descriptionOpacity ? 1 : 0)
                .offset(y: descriptionOpacity ? 0 : textOffset)
                .animation(.easeOut(duration: 0.4).delay(0.1), value: descriptionOpacity)

            RoundedRectangle(cornerRadius: 25)
                .fill(Color.blue)
                .opacity(fixDescriptionOpacity ? 1 : 0)
                .offset(y: fixDescriptionOpacity ? 0 : textOffset)
                .animation(.easeOut(duration: 0.4).delay(0.1), value: fixDescriptionOpacity)

            Spacer()
        }
        .clipped()
        .contentShape(Rectangle())
        .onAppear {
            withAnimation(.easeOut(duration: 0.4).delay(0.6)) {
                triggerAnimations()
            }
        }
        .onTapGesture {
            withAnimation(.easeInOut(duration: 0.5)) {
                isShowingLarge = false
            } completion: {
                index = nil
            }
        }
    }

    func triggerAnimations() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.descriptionOpacity = true
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
            self.fixDescriptionOpacity = true
        }
    }
}

struct ColorStruct: Identifiable {
    var id: String {
        String(describing: color)
    }
    let color: Color
}
#Preview {
    TestingMainView()
        .environmentObject(UIStateManager())
}

struct TestCell: View {

    let light: CarSymbol
    let index: Int
    var namespace: Namespace.ID
    @Binding var isShowingLarge: Bool

    var body: some View {
        RoundedRectangle(cornerRadius: 25)
            .foregroundStyle(Color.clear)
            .overlay(alignment: .center) {
                VStack {
                    Image(light.imageName)
                        .resizable()
                        .matchedGeometryEffect(id: "\(index) logo", in: namespace, isSource: true)
                        .scaledToFit()
                    Text(light.name)
                        .font(.caption)
                        .multilineTextAlignment(.center)
                }
                .padding()
                
            }
            .overlay {
                RoundedRectangle(cornerRadius: 25)
                    .stroke(Color.black, lineWidth: 4)
            }
            .opacity(isShowingLarge ? 0 : 1)
    }
}
