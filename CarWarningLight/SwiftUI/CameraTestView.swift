//
//  CameraTestView.swift
//  CarWarningLight
//
//  Created by Sam Greenhill on 4/28/25.
//  Copyright © 2025 simplyAmazingMachines. All rights reserved.
//

import SwiftUI
import Vision
import CoreML

struct CameraTestView: View {
    @StateObject private var viewModel = ImageDetectionViewModel()
    @State private var showImagePicker = false
    @State private var inputImage: UIImage?
    @State private var showResultsView: Bool = false

    var body: some View {
        NavigationStack {
            VStack {
                Button("Pick a Photo") {
                    showImagePicker = true
                }
                .font(.title)
                .padding()
            }
            .sheet(isPresented: $showImagePicker) {
                ImagePicker(image: $inputImage)
                    .onDisappear {
                        if let inputImage = inputImage, let ciImage = CIImage(image: inputImage) {
                            viewModel.detect(image: ciImage)
                            withAnimation(.easeOut.delay(0.3)) {
                                showResultsView = true
                            }
                        }
                    }
            }
            .navigationDestination(isPresented: $showResultsView) {
                ResultsView() //(resultLights: viewModel.imageRecogResults, dismissToHome: { showResultsView = false })
            }
        }
    }
}

import SwiftUI
import UIKit

struct ImagePicker: UIViewControllerRepresentable {
    @Environment(\.dismiss) var dismiss
    @Binding var image: UIImage?

    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator
        return picker
    }

    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        let parent: ImagePicker

        init(_ parent: ImagePicker) {
            self.parent = parent
        }

        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let uiImage = info[.originalImage] as? UIImage {
                parent.image = uiImage
            }
            parent.dismiss()
        }

        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            parent.dismiss()
        }
    }
}


#Preview {
    CameraTestView()
        .environmentObject(UIStateManager())
}



