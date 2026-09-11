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

@Observable
@MainActor
class ImageDetectionViewModel {

    var scanMatches: [ScanMatch]         = []
    var imageRecogResults: CarSymbols    = []
    var showResults: Bool                = false
    var errorMessage: String?
    var showError: Bool                  = false
    var isProcessing: Bool               = false

    private static let notAWarningLightLabel: String = "Not a Warning Light"

    private let bundleLight: [CarSymbol]            = CarSymbol.bundledLibrary
    private let logger = Logger(subsystem: "com.simplyAmazingMachines.CarWarningLight", category: "ImageDetection")

    func processImage(photo: UIImage) async -> TaskStatus {
        isProcessing       = true
        scanMatches        = []
        imageRecogResults  = []
        errorMessage       = nil
        showError          = false

        guard let ciImage = CIImage(image: photo) else {
            let message = "Could not process the image"
            await MainActor.run {
                self.errorMessage   = message
                self.showError      = true
            }
            return .failed(message)
        }

        await detectAsync(image: ciImage)

        if scanMatches.isEmpty {
            let message         = "No warning light detected in the image"
            self.errorMessage   = message
            self.showError      = true
            self.isProcessing   = false
            logger.warning("\(message)")
            return .failed(message)
        }

        self.isProcessing       = false
        return .success
    }

    func detectAsync(image: CIImage) async {
        // Clear previous results
        scanMatches        = []
        imageRecogResults  = []

        do {
            // Load the model
            let url = CarImgMLModel.urlOfModelInThisBundle
            let model1 = try CarImgMLModel(contentsOf: url, configuration: MLModelConfiguration())
            let model2 = try VNCoreMLModel(for: model1.model)

            // Create and configure request
            let request = VNCoreMLRequest(model: model2)
            request.imageCropAndScaleOption = .centerCrop

            // Create a handler and perform the request
            let handler = VNImageRequestHandler(ciImage: image)
            try handler.perform([request])

            let matches = processVisionResults(request)

            // Update UI on the main thread with the isolated results
            scanMatches        = matches
            imageRecogResults  = matches.map(\.carSymbol)
        } catch {
            logger.error("Error in vision processing: \(error.localizedDescription)")
            // Don't update results if there's an error
        }
    }

    // Helper method to process Vision results in a concurrency-safe way
    private func processVisionResults(_ request: VNCoreMLRequest) -> [ScanMatch] {
        guard let results = request.results as? [VNClassificationObservation], let top = results.first else {
            logger.warning("No results found or empty results")
            return []
        }

        guard top.identifier != Self.notAWarningLightLabel else {
            logger.info("Top guess was '\(Self.notAWarningLightLabel)' at \(top.confidence) — reporting no match")
            return []
        }

        var matches: [ScanMatch]        = []
        for result in results.prefix(10) {
            guard result.identifier != Self.notAWarningLightLabel else { continue }
            if let symbol = self.bundleLight.first(where: { $0.name == result.identifier }) {
                matches.append(ScanMatch(carSymbol: symbol, confidence: Double(result.confidence)))
            }
        }
        return matches
    }
}
