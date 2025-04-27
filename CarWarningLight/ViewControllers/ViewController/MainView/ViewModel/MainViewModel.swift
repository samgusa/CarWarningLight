//
//  MainViewModel.swift
//  CarWarningLight
//
//  Created by Sam Greenhill on 9/19/23.
//  Copyright © 2023 simplyAmazingMachines. All rights reserved.
//

import Foundation
import UIKit
import Combine
import Vision
import CoreML

struct MainViewModel {

  var carPressedSubject = PassthroughSubject<CarDatum, Never>()
  var infoPressedSubject = PassthroughSubject<CarData, Never>()

  func fetchData() -> Future<CarData, Never> {
    return Future { promise in
      let bundleLight: [CarDatum] = Bundle.main.decode([CarDatum].self, from: "carLights.json")
      promise(.success(bundleLight))
    }
  }

  func detectWarningImages(img: CIImage) {
    SwiftSpinner.show("DOESN'T REPLACE A VISIT TO A MECHANIC")

    guard let model = try? VNCoreMLModel(for: MainCarImg4(configuration: MLModelConfiguration()).model) else { return }

    let request = VNCoreMLRequest(model: model)
    request.usesCPUOnly = true

    let handler = VNImageRequestHandler(ciImage: img, options: [:])

    try? handler.perform([request])

    guard let results = request.results as? [VNClassificationObservation] else { return }

    let topClassifications = results.prefix(10)

    let descriptions = topClassifications.map { results in
      return String(format: "%@", results.identifier)
    }
    dump(descriptions)
    SwiftSpinner.hide()

  }

}

