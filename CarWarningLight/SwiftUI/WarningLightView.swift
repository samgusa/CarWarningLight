//
//  WarningLightCell.swift
//  CarWarningLight
//
//  Created by Sam Greenhill on 4/23/25.
//  Copyright © 2025 simplyAmazingMachines. All rights reserved.
//

import SwiftUI

struct WarningLightCell: View {
    let items = Array(1...30)
    let desiredCellWidth: CGFloat = 100
    let spacing: CGFloat = 16

    @Namespace var namespace
    @State var isPressed: Bool = false
    @State var itemPressed: Int = 0

    var body: some View {
        ZStack {
            GeometryReader { geometry in
                let availableWidth = geometry.size.width - spacing
                let columnsCount = max(Int(availableWidth / (desiredCellWidth + spacing)), 1)
                let columns = Array(repeating: GridItem(.flexible(), spacing: spacing), count: columnsCount)

                ScrollView {
                    LazyVGrid(columns: columns, spacing: spacing) {
                        ForEach(items, id: \.self) { item in
                            if !isPressed || item != itemPressed {
                                CellView(item: item, namespace: namespace)
                                    .onTapGesture {
                                        withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
                                            itemPressed = item
                                            isPressed = true
                                        }
                                    }
                            } else {
                                Color.clear.frame(height: 150)
                            }
                        }
                    }
                    .padding(spacing)
                }
                .opacity(isPressed ? 0.5 : 1)

                if isPressed {
                    ExpandedView(item: itemPressed, namespace: namespace) {
                        withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
                            isPressed = false
                        }
                    }
                }
            }
        }
        .background(Color(.systemBackground))
    }
}

struct CellView: View {
    let item: Int
    var namespace: Namespace.ID

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.blue.opacity(0.7))
                .matchedGeometryEffect(id: "item\(item)", in: namespace)

            VStack {
                Circle()
                    .matchedGeometryEffect(id: "circle\(item)", in: namespace)
                    .padding(.horizontal)

                Text("Item \(item)")
                    .matchedGeometryEffect(id: "text\(item)", in: namespace)
                    .foregroundColor(.white)
                    .bold()
            }
        }
        .frame(height: 150)
    }
}

struct ExpandedView: View {
    let item: Int
    var namespace: Namespace.ID
    var onDismiss: () -> Void

    @State private var showText = false
    @State private var textOffset: CGFloat = -150  // Start above the circle

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.blue)
                .matchedGeometryEffect(id: "item\(item)", in: namespace)
                .ignoresSafeArea()

            VStack {
                Circle()
                    .matchedGeometryEffect(id: "circle\(item)", in: namespace)
                    .padding(.top, 40)
                    .padding(.horizontal)

                Spacer()

                Text("Item \(item)")
                    .font(.largeTitle)
                    .foregroundColor(.white)
                    .bold()
                    .opacity(showText ? 1 : 0)
                    .offset(y: textOffset)
                    .animation(.easeOut(duration: 0.6), value: textOffset)
                    .animation(.easeOut(duration: 0.6), value: showText)

                Spacer()
            }
        }
        .onAppear {
            showText = true
            withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
                textOffset = 0  // Animate to natural position
            }
        }
        .onTapGesture {
            onDismiss()
        }
    }
}







#Preview {
    WarningLightCell()
}

//#Preview {
//    WarningLightCell(warningMessage: CarArr(name: "Airbag Malfunction", image: carImg.airBag, description: "This is the air bag malfunction light. This could either say Air Bag, SRS, or a person with a deployed airbag. This light can come in a variety of shapes depending on which air bag is malfunctioning.", symbolType: warning, openBool: false, fixDescr: "If this light is on, a professional mechanic should be contacted. If the air bags don't function as they should, they may not work in the case of an emergency.", drivable: no))
//}

