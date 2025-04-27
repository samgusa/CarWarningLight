//
//  WarningLightCell.swift
//  CarWarningLight
//
//  Created by Sam Greenhill on 4/24/25.
//  Copyright © 2025 simplyAmazingMachines. All rights reserved.
//

import SwiftUI

struct WarningLightCell: View {
    let carData: CarSymbol
    var namespace: Namespace.ID

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 12)
                .fill(Color(.systemBackground))
                .matchedGeometryEffect(id: "\(carData.id)", in: namespace)

            VStack(alignment: .center, spacing: 8) {
                GeometryReader { geometry in
                    Image(carData.imageName)
                        .resizable()
                        //.renderingMode(.template)
                        .matchedGeometryEffect(id: "\(carData.imageName)", in: namespace)
                        //.foregroundStyle(carData.symbolType.color)
                        .scaledToFit()
                        .frame(width: min(geometry.size.width, 100), height: min(geometry.size.width, 100))
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                }
                .aspectRatio(1 / 1.5, contentMode: .fit)

                Text(carData.name)
                    .font(.caption)
                    .multilineTextAlignment(.center)
            }
            .padding()
        }
    }
}

#Preview {
    ContentView()
}

#Preview {
    @Previewable @Namespace var namespace
    WarningLightCell(
        carData: CarSymbol.init(id: 1, name: "Adaptive Front Lighting System Warning", imageName: CarWarning.airBag.rawValue, description: "Depending on the make of the vehicle and the color of the light, this could mean a couple things. Green: Directional Headlights. Indicates that the vehicles automatic directional headlights are operational. Yellow: Adaptive Warning Light: Some Vehicles have lights that turn on automatically and adjust brightness depending on how dark and light it is. If the light is Yellow, that means that there is a malfunction with the sensor for that light.", symbolType: .warning, fixDescription: "If this light is on, a professional mechanic should be contacted. If the air bags don't function as they should, they may not work in the case of an emergency.", drivable: .no),
        namespace: namespace)
}
/*
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

 name: "Adaptive Front Lighting System Warning", image: carImg.adaptiveOne, description: "Depending on the make of the vehicle and the color of the light, this could mean a couple things. Green: Directional Headlights. Indicates that the vehicles automatic directional headlights are operational. Yellow: Adaptive Warning Light: Some Vehicles have lights that turn on automatically and adjust brightness depending on how dark and light it is. If the light is Yellow, that means that there is a malfunction with the sensor for that light.", symbolType: advisory, openBool: false, fixDescr: "If the light is yellow, a professional mechanic should be contacted to fix the problem. The headlights should still be able to function even thought the Adaptive Lighting System is not.", drivable: yes
 */
