//
//  PhotoPreviewView.swift
//  CarWarningLight
//
//  Created by Sam Greenhill on 4/30/25.
//  Copyright © 2025 simplyAmazingMachines. All rights reserved.
//

import SwiftUI
import AVFoundation
import UIKit

/**
 * A view that displays a captured photo with a black background
 */
struct PhotoPreviewView: View {
    // MARK: - Properties
    let photo: CapturedPhoto?
    var dismissToHome: () -> Void

    @State private var showResults: Bool = false

    // MARK: - Body
    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()

            if let photo = photo {
                VStack {
                    Image(uiImage: photo.image)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .ignoresSafeArea()

                    Button("Continue") {
                        showResults = true
                    }
                    .padding()
                    .background(Color.white)
                    .foregroundStyle(.black)
                }
            } else {
                Text("No photo available")
                    .foregroundColor(.white)
                    .font(.headline)
            }
        }
        .navigationDestination(isPresented: $showResults) {
            //ResultsView(resultLights: [], dismissToHome: dismissToHome)
        }
    }
}


#Preview {
    ContentView()
        .environmentObject(UIStateManager())
}
