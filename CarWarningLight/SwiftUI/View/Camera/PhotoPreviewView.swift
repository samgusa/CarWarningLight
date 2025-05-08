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
    @StateObject private var viewModel = ImageDetectionViewModel()
    let capturedPhoto: CapturedPhoto?

    // MARK: - Body
    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()

            if let photo = capturedPhoto {
                VStack {
                    Image(uiImage: photo.image)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .ignoresSafeArea()

                    CustomButton2 {
                        Text("Submit")
                    } action: {
                        // Mark as submitting
                        try? await Task.sleep(for: .seconds(5))
                        if let ciImage = CIImage(image: photo.image) {
                            await viewModel.detectAsync(image: ciImage)

                            // check results
                            if viewModel.imageRecogResults.isEmpty {
                                return .failed("No Symbols detected in the image")
                            } else {
                                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                                    viewModel.showResults = true
                                }
                                return .success
                            }
                        } else {
                            return .failed("Could not process the image")
                        }
                    }
                    .padding(.bottom, 20)
                }
            } else {
                Text("No photo available")
                    .foregroundColor(.white)
                    .font(.headline)
            }
        }
        .navigationDestination(isPresented: $viewModel.showResults) {
            ResultsView(detectedLights: viewModel.imageRecogResults)
        }
    }
}


#Preview {
//    ContentView()
        let dummyImage = UIImage(systemName: "photo.fill")!
            let dummyPhoto = CapturedPhoto(image: dummyImage)

            // Provide the dummy photo and a placeholder for the dismiss action
            PhotoPreviewView(capturedPhoto: dummyPhoto)
                //.previewDisplayName("With Photo")

//    PhotoPreviewView(capturedPhoto: nil, dismissToHome: {})
//                .previewDisplayName("No Photo")
                .environmentObject(UIStateManager())
}

