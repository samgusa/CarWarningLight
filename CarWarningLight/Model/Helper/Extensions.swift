//
//  Extensions.swift
//  CarWarningLight
//
//  Created by Sam Greenhill on 10/19/20.
//  Copyright © 2020 simplyAmazingMachines. All rights reserved.
//

import Foundation
import UIKit
import Vision
import CoreML

//extensions for the TestingViewController
//DetectImages, PresentCameraView
extension UIViewController {
    
    func detectImages(image: CIImage, btn: UIButton) {
        //load mlmodel throught its generated class
        let url = MainCarImg4.urlOfModelInThisBundle
        let model1 = try! MainCarImg4(contentsOf: url, configuration: MLModelConfiguration())
        let model2 = try! VNCoreMLModel(for: model1.model)
        
        //create request for vision coreML modal loaded
        let request = VNCoreMLRequest(model: model2) { [weak self] request, error in
            guard let results = request.results as? [VNClassificationObservation], let _ = results.first else {
                fatalError("Unexpected result from VNCoreMLRequest")
            }
            if results.isEmpty {
                print("Nothing Recognized")
            } else {
                let topClassification = results.prefix(10)
                
                let descriptions = topClassification.map {
                    results in
                    return String(format: "%@", results.identifier)
                }
                dump(descriptions)
                DispatchQueue.main.async {
                }
            }
        }
   
        let handler = VNImageRequestHandler(ciImage: image)
        DispatchQueue.global(qos: .userInteractive).async {
            do {
                try handler.perform([request])
            } catch {
                print("error")
            }
        }
    }
    
    func presentCameraView(btn: UIButton) {
        let vc = ImageCollectionViewController()
        vc.modalPresentationStyle = .fullScreen
        self.navigationController?.present(vc, animated: true, completion: nil)
        
    }
}
