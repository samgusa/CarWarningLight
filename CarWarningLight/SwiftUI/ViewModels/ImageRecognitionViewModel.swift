//
//  ImageRecognitionViewModel.swift
//  CarWarningLight
//
//  Created by Sam Greenhill on 4/28/25.
//  Copyright © 2025 simplyAmazingMachines. All rights reserved.
//

import SwiftUI
import Vision
import CoreML
import OSLog
import Combine

class ImageDetectionViewModel: ObservableObject {

    @Published var scanMatches: [ScanMatch]         = []
    @Published var imageRecogResults: CarSymbols    = []
    @Published var showResults: Bool                = false
    @Published var errorMessage: String?
    @Published var showError: Bool                  = false
    @Published var isProcessing: Bool               = false

    private let bundleLight: [CarSymbol]            = Bundle.main.decode([CarSymbol].self, from: "carLights.json")
    private let logger = Logger(subsystem: "com.simplyAmazingMachines.CarWarningLight", category: "ImageDetection")

    func processImage(photo: UIImage) async -> TaskStatus {

        await MainActor.run {
            self.isProcessing       = true
            self.scanMatches        = []
            self.imageRecogResults  = []
            self.errorMessage       = nil
            self.showError          = false
        }

        guard let ciImage = CIImage(image: photo) else {
            let message = "Could not process the image"
            await MainActor.run {
                self.errorMessage = message
                self.showError = true
            }
            return .failed(message)
        }

        await detectAsync(image: ciImage)

        if scanMatches.isEmpty {
            let message = "No Symbols detected in the image"
            await MainActor.run {
                self.errorMessage = message
                self.showError = true
                self.isProcessing = false
            }
            logger.warning("\(message)")
            return .failed(message)
        }

        await MainActor.run {
            self.isProcessing = false
        }

        return .success
    }

    func detectAsync(image: CIImage) async {
        // Clear previous results
        await MainActor.run {
            self.scanMatches        = []
            self.imageRecogResults  = []
        }

        // Let's avoid continuations completely and use atomic operations
        do {
            // Load the model
            let url = MainCarLightMLModel.urlOfModelInThisBundle
            let model1 = try MainCarLightMLModel(contentsOf: url, configuration: MLModelConfiguration())
            let model2 = try VNCoreMLModel(for: model1.model)

            // Create and configure request
            let request = VNCoreMLRequest(model: model2)
            request.imageCropAndScaleOption = .centerCrop

            // Create a handler and perform the request
            let handler = VNImageRequestHandler(ciImage: image)
            try handler.perform([request])

            let matches = await processVisionResults(request)

            // Update UI on the main thread with the isolated results
            await MainActor.run {
                self.scanMatches        = matches
                self.imageRecogResults  = matches.map(\.carSymbol)
            }
        } catch {
            logger.error("Error in vision processing: \(error.localizedDescription)")
            // Don't update results if there's an error
        }
    }

    // Helper method to process Vision results in a concurrency-safe way
    private func processVisionResults(_ request: VNCoreMLRequest) async -> [ScanMatch] {
        var matches: [ScanMatch]        = []

        // Safely process the results
        if let results = request.results as? [VNClassificationObservation], !results.isEmpty {
            for result in results.prefix(10) {
                if let symbol = self.bundleLight.first(where: { $0.name == result.identifier }) {
                    matches.append(ScanMatch(carSymbol: symbol, confidence: Double(result.confidence)))
                }
            }
        } else {
            logger.warning("No results found or empty results")
        }

        return matches
    }
}
