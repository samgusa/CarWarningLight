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
import OSLog

struct PhotoPreviewView: View {
    // MARK: - Properties
    @StateObject private var viewModel = ImageDetectionViewModel()
    @Environment(\.dismiss) private var dismiss

    let capturedPhoto: CapturedPhoto?

    // MARK: - Body
    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()

            if let photo = capturedPhoto {
                VStack(spacing: 16) {
                    HStack {
                        Button {
                            dismiss()
                        } label: {
                            Image(systemName: "xmark")
                                .font(.system(size: 18, weight: .semibold))
                                .foregroundStyle(.white)
                                .frame(width: 36, height: 36)
                                .background(Color.black.opacity(0.5))
                                .clipShape(Circle())
                        }
                        .padding(.leading)
                        Spacer()

                    }
                    .padding(.top, 8)

                    Spacer()

                    Image(uiImage: photo.image)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                        .padding(.horizontal)

                    Spacer()

                    VStack(spacing: 10) {

                        Text("Analyze dashboard warning light")
                            .font(.headline)
                            .foregroundStyle(.white)

                        CustomButton {
                            Text("Identify Light")
                                .fontWeight(.semibold)
                                .foregroundStyle(.black)
                        } action: {
                            try? await Task.sleep(for: .seconds(1))
                            return await viewModel.processImage(photo: photo.image)
                        } onSuccessComplete: {
                            viewModel.showResults = true
                        }
                    }
                    .padding(.bottom, 24)
                    .padding(.horizontal)
                }
            } else {
                VStack(spacing: 16) {
                    Image(systemName: "exclamationmark.triangle")
                        .font(.system(size: 48))
                        .foregroundStyle(.white.opacity(0.8))

                    Text("No photo available")
                        .foregroundStyle(.white)
                        .font(.headline)

                    Button("Go Back") {
                        dismiss()
                    }
                    .padding()
                    .background(Color.white.opacity(0.2))
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    .foregroundStyle(.white)
                }
            }
        }
        .navigationBarBackButtonHidden(true)
        .navigationDestination(isPresented: $viewModel.showResults) {
            ResultsView(detectedLights: viewModel.imageRecogResults)
        }
    }
}

#Preview {
        let dummyImage = UIImage(systemName: "photo.fill")!
            let dummyPhoto = CapturedPhoto(image: dummyImage)

            PhotoPreviewView(capturedPhoto: dummyPhoto)
                .environmentObject(UIStateManager())
}
