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

class ImageDetectionViewModel: ObservableObject {

    @Published var imageRecogResults: CarSymbols = []
    @Published var showResults: Bool = false

    private let bundleLight: [CarSymbol] = Bundle.main.decode([CarSymbol].self, from: "carLights.json")
    private let logger = Logger(subsystem: "com.simplyAmazingMachines.CarWarningLight", category: "ImageDetection")

    func detectAsync(image: CIImage) async {
        // clear previous results
        await MainActor.run {
            self.imageRecogResults = []
        }

        return await withCheckedContinuation { continuation in
            let url = CarLightMLModel.urlOfModelInThisBundle

            Task.detached(priority: .userInitiated) {
                do {
                    let model1 = try CarLightMLModel(contentsOf: url, configuration: MLModelConfiguration())
                    let model2 = try VNCoreMLModel(for: model1.model)

                    let request = VNCoreMLRequest(model: model2) { [weak self] request, error in
                        guard let self = self else {
                            continuation.resume()
                            return
                        }

                        if let error = error {
                            self.logger.error("Request error: \(error.localizedDescription)")
                            continuation.resume()
                            return
                        }

                        // process results
                        guard let results = request.results as? [VNClassificationObservation], !results.isEmpty else {
                            continuation.resume()
                            return
                        }

                        // Filter top results with confidence > 0.2
                        let topResults = results.prefix(10)

                        var foundSymbols: CarSymbols = []

                        for result in topResults {
                            if let match = self.bundleLight.first(where: { $0.name == result.identifier }) {
                                foundSymbols.append(match)
                            }
                        }

                        Task { @MainActor in
                            self.imageRecogResults = foundSymbols
                            continuation.resume()
                        }
                    }

                    request.imageCropAndScaleOption = .centerCrop
                    let handler = VNImageRequestHandler(ciImage: image)

                    try handler.perform([request])
                } catch {
                    self.logger.error("Model loading error: \(error.localizedDescription)")
                    continuation.resume()
                }
            }
        }
    }

}
