//
//  Home.swift
//  CarWarningLight
//
//  Created by Sam Greenhill on 4/26/25.
//  Copyright © 2025 simplyAmazingMachines. All rights reserved.
//

import SwiftUI

struct Home: View {
    @State var show: Bool = false
    var body: some View {
        WarningLightView()
            .overlay(alignment: .bottomTrailing) {
                FloatingButtonView {
                    FloatingAction(symbol: "photo.fill") {
                        print("tray")
                    }
                    FloatingAction(symbol: "camera.fill") {
                        print("tray")
                    }
                } label: { isExpanded in
                    Image(systemName: "plus")
                        .font(.title3)
                        .fontWeight(.semibold)
                        .foregroundStyle(.white)
                        .rotationEffect(.init(degrees: isExpanded ? 45 : 0))
                        .scaleEffect(1.02)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .background(.black, in: .circle)
                    // Scaling Effect when expanded
                        .scaleEffect(isExpanded ? 0.9 : 1)
                }
                .padding(.horizontal)
            }
    }
}

#Preview {
    Home()
}
