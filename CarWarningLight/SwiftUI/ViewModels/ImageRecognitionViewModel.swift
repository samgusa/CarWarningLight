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

class ImageDetectionViewModel: ObservableObject {

    @Published var imageRecogResults: CarSymbols = []

    private let bundleLight: [CarSymbol] = Bundle.main.decode([CarSymbol].self, from: "carLights.json")

    func detect(image: CIImage) {
        let url = MainCarImg4.urlOfModelInThisBundle

        guard let model1 = try? MainCarImg4(contentsOf: url, configuration: MLModelConfiguration()),
              let model2 = try? VNCoreMLModel(for: model1.model) else {
            print("Failed to load model")
            return
        }

        let request = VNCoreMLRequest(model: model2) { request, error in
            if let error = error {
                print("Request error: \(error.localizedDescription)")
                return
            }

            guard let results = request.results as? [VNClassificationObservation], !results.isEmpty else {
                print("No results")
                return
            }

            let topResults = results.prefix(10)
            let detectedNames = topResults.map { $0.identifier }

            for i in detectedNames {
                for car in self.bundleLight {
                    if i == car.name {
                        DispatchQueue.main.async {
                            self.imageRecogResults.append(car)
                        }
                    }
                }
            }
        }

        let handler = VNImageRequestHandler(ciImage: image)

        DispatchQueue.global(qos: .userInitiated).async {
            do {
                try handler.perform([request])
            } catch {
                print("Failed to perform request: \(error)")
            }
        }
    }

    func detectAsync(image: CIImage) async {
        // clear previous results
        await MainActor.run {
            self.imageRecogResults = []
        }

        return await withCheckedContinuation { continuation in
            let url = MainCarImg4.urlOfModelInThisBundle

            guard let model1 = try? MainCarImg4(contentsOf: url, configuration: MLModelConfiguration()),
                  let model2 = try? VNCoreMLModel(for: model1.model) else {
                print("Failed to load model")
                continuation.resume()
                return
            }

            let request = VNCoreMLRequest(model: model2) { request, error in
                if let error = error {
                    print("Request Error: \(error.localizedDescription)")
                    continuation.resume()
                    return
                }

                guard let results = request.results as? [VNClassificationObservation], !results.isEmpty else {
                    print("No results")
                    continuation.resume()
                    return
                }

                let topResults = results.prefix(10)
                let detectedNames = topResults.map { $0.identifier }
                var detectedCars: CarSymbols = []

                for i in detectedNames {
                    for car in self.bundleLight {
                        if i == car.name {
                            detectedCars.append(car)
                        }
                    }
                }

                Task { @MainActor in
                    self.imageRecogResults = detectedCars
                    continuation.resume()
                }
            }

            let handler = VNImageRequestHandler(ciImage: image)

            DispatchQueue.global(qos: .userInitiated).async {
                do {
                    try handler.perform([request])
                } catch {
                    print("Failed to perform request: \(error)")
                    Task { @MainActor in
                        continuation.resume()
                    }
                }
            }
        }
    }

}



/*
 set this up to work with the new classification style,
 Try and make it look nice,
 set up errors so that can be put in the message.

*/
