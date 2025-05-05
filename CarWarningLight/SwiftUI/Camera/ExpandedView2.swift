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

    @Binding var isShowingLarge: Bool
    let bigImageId: Int
    @Binding var index: Int?

    var body: some View {
        GeometryReader { geometry in
            Color.clear
                .overlay {
                    VStack {
                        HStack {
                            Spacer()
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
                                .frame(width: geometry.size.width / 2, height: geometry.size.width / 2)
                            Spacer()
                        }
                        Spacer()
                    }
                    .padding(.top, 100)
                }
                .overlay(alignment: .topTrailing) {
                    Button {
                        withAnimation(.easeInOut) {
                            isShowingLarge = false
                        } completion: {
                            index = nil
                        }

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
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(.black, lineWidth: 1)
                )
        }
        .ignoresSafeArea()
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
                  namespace: namespace,
                  isShowingLarge: .constant(false),
                  bigImageId: -1,
                  index: .constant(1))
    .environmentObject(UIStateManager())
    //, dismissToHome: {})
}

