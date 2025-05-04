//
//  CameraManager.swift
//  CarWarningLight
//
//  Created by Sam Greenhill on 4/30/25.
//  Copyright © 2025 simplyAmazingMachines. All rights reserved.
//

import Foundation
import AVFoundation
import UIKit

class CapturedPhoto: Identifiable, Hashable {
    let id = UUID()
    let image: UIImage

    init(image: UIImage) {
        self.image = image
    }

    static func == (lhs: CapturedPhoto, rhs: CapturedPhoto) -> Bool {
        return lhs.id == rhs.id
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}


class CameraManager: NSObject, ObservableObject {
    let session = AVCaptureSession()
    private let photoOutput = AVCapturePhotoOutput()
    var videoPreviewLayer: AVCaptureVideoPreviewLayer?

    @Published var lastCapturedPhoto: CapturedPhoto?
    @Published var flashMode: AVCaptureDevice.FlashMode = .off
    @Published var isSessionRunning = false // Add a state to track session status

    override init() {
        super.init()
        configureSession()
    }

    private func configureSession() {
        session.beginConfiguration()
        if session.canSetSessionPreset(.photo) {
            session.sessionPreset = .photo
        }

        guard let device = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back) else { return }

        do {
            let input = try AVCaptureDeviceInput(device: device)
            if session.canAddInput(input) { session.addInput(input) }
            if session.canAddOutput(photoOutput) { session.addOutput(photoOutput) }

            if #available(iOS 16.0, *) {
                // Use maxPhotoDimensions instead
                photoOutput.maxPhotoDimensions = CMVideoDimensions(width: 4032, height: 3024)
            } else {
                // Fall back to the deprecated method for iOS 15 and earlier
                photoOutput.isHighResolutionCaptureEnabled = true
            }
        } catch {
            print("Camera setup error: \(error)")
        }

        session.commitConfiguration()
    }

    func setPreviewLayer(_ layer: AVCaptureVideoPreviewLayer) {
        videoPreviewLayer = layer
        //videoPreviewLayer?.connection?.videoOrientation = .portrait
    }

    func startSession() {
        guard !session.isRunning else { return } // Check if session is already running
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            self?.session.startRunning()
            DispatchQueue.main.async {
                self?.isSessionRunning = true // Update session status on main thread
            }
        }
    }

    func stopSession() {
        guard session.isRunning else { return } // Check if session is running
        session.stopRunning()
        isSessionRunning = false // Update session status
    }

    func toggleFlash() {
        flashMode = (flashMode == .on ? .off : .on)
    }

    func capturePhoto() {
        let settings = AVCapturePhotoSettings()
        settings.flashMode = flashMode
        photoOutput.capturePhoto(with: settings, delegate: self)
    }
}

extension CameraManager: AVCapturePhotoCaptureDelegate {
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        if let error = error {
            print("Photo capture error: \(error)")
            return
        }

        guard let data = photo.fileDataRepresentation(),
              let image = UIImage(data: data) else {
            print("Failed to process photo")
            return
        }

        DispatchQueue.main.async { [weak self] in
            guard let self = self,
                  let previewLayer = self.videoPreviewLayer else {
                self?.lastCapturedPhoto = CapturedPhoto(image: image)
                return
            }

            // Get the crop rect in layer coordinates
            let previewSize = previewLayer.bounds.size
            let focusSize: CGFloat = 150 // Your square size in points
            let focusRect = CGRect(
                x: (previewSize.width - focusSize) / 2,
                y: (previewSize.height - focusSize) / 2,
                width: focusSize,
                height: focusSize
            )

            // Convert layer rect to image coordinates
            let metadataOutputRect = previewLayer.metadataOutputRectConverted(fromLayerRect: focusRect)

            // Now crop the image using this normalized rect
            if let cropped = cropImage(image, to: metadataOutputRect) {
                self.lastCapturedPhoto = CapturedPhoto(image: cropped)
            } else {
                self.lastCapturedPhoto = CapturedPhoto(image: image)
            }
        }

    }
}


func cropImage(_ image: UIImage, to rect: CGRect) -> UIImage? {
    let width = CGFloat(image.cgImage!.width)
    let height = CGFloat(image.cgImage!.height)

    let cropRect = CGRect(
        x: rect.origin.x * width,
        y: rect.origin.y * height,
        width: rect.size.width * width,
        height: rect.size.height * height
    )

    guard let cgImage = image.cgImage?.cropping(to: cropRect) else { return nil }
    return UIImage(cgImage: cgImage, scale: image.scale, orientation: image.imageOrientation)
}
