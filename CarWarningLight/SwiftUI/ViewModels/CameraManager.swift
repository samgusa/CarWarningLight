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
import OSLog

class CapturedPhoto: Identifiable, Hashable {
    let id = UUID()
    let image: UIImage
    let timestamp: Date

    init(image: UIImage, timestamp: Date = Date()) {
        self.image = image
        self.timestamp = timestamp
    }

    static func == (lhs: CapturedPhoto, rhs: CapturedPhoto) -> Bool {
        return lhs.id == rhs.id
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

// Custom camera Errors for better error handling
enum CameraError: Error, LocalizedError {
    case deviceNotAvailable
    case inputSetupFailed
    case outputSetupFailed
    case sessionConfigurationFailed
    case photoProcessingFailed
    case cropFailed

    var errorDescription: String? {
            switch self {
            case .deviceNotAvailable:
                return "Camera device is not available"
            case .inputSetupFailed:
                return "Failed to setup camera input"
            case .outputSetupFailed:
                return "Failed to setup camera output"
            case .sessionConfigurationFailed:
                return "Failed to configure camera session"
            case .photoProcessingFailed:
                return "Failed to process captured photo"
            case .cropFailed:
                return "Failed to crop captured photo"
            }
        }
}

class CameraManager: NSObject, ObservableObject {
    let session = AVCaptureSession()
    private let photoOutput = AVCapturePhotoOutput()
    private let logger = Logger(subsystem: "com.simplyAmazingMachines.CarWarningLight", category: "CameraManager")

    var videoPreviewLayer: AVCaptureVideoPreviewLayer?

    @Published var lastCapturedPhoto: CapturedPhoto?
    @Published var isSessionRunning: Bool = false
    @Published var error: CameraError?

    private let focusSize: CGFloat = 150

    override init() {
        super.init()
        Task {
            await configureSession()
        }
    }

    private func configureSession() async {
        do {
            session.beginConfiguration()

            if session.canSetSessionPreset(.photo) {
                session.sessionPreset = .photo
            }

            try setupCameraInput()
            try setupPhotoOutput()

            session.commitConfiguration()
        } catch let cameraError as CameraError {
            logger.error("Camera configuration error: \(cameraError.localizedDescription)")
            await MainActor.run {
                self.error = cameraError
            }
        } catch {
            logger.error("Unexpected camera error: \(error.localizedDescription)")
            await MainActor.run {
                self.error = .sessionConfigurationFailed
            }
        }
    }

    private func setupCameraInput() throws {
        guard let device = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back) else {
            throw CameraError.deviceNotAvailable
        }
        do {
            let input = try AVCaptureDeviceInput(device: device)
            if session.canAddInput(input) {
                session.addInput(input)
            } else {
                throw CameraError.inputSetupFailed
            }
        } catch {
            logger.error("Failed to create camera input: \(error.localizedDescription)")
            throw CameraError.inputSetupFailed
        }
    }

    private func setupPhotoOutput() throws {
        if session.canAddOutput(photoOutput) {
            session.addOutput(photoOutput)

            if #available(iOS 16.0, *) {
                photoOutput.maxPhotoDimensions = CMVideoDimensions(width: 4032, height: 3024)
            } else {
                photoOutput.isHighResolutionCaptureEnabled = true
            }

            // Configure other photo output settings if needed
            photoOutput.isLivePhotoCaptureEnabled = false
            photoOutput.isDepthDataDeliveryEnabled = false
        } else {
            throw CameraError.outputSetupFailed
        }
    }

    func setPreviewLayer(_ layer: AVCaptureVideoPreviewLayer) {
        videoPreviewLayer = layer
    }

    func startSession() {
        guard !session.isRunning else { return } // Check if session is already running
        Task {
            await startSessionAsync()
        }
    }


    private func startSessionAsync() async {
        await MainActor.run {
            self.error = nil
        }

        await withTaskGroup(of: Void.self) { group in
            group.addTask {
                await self.runCaptureSession()
            }
        }
    }

    private func runCaptureSession() async {
        do {
            session.startRunning()
            await MainActor.run {
                self.isSessionRunning = self.session.isRunning
            }
        }
    }

    func stopSession() {
        guard session.isRunning else { return }

        Task {
            session.stopRunning()
            await MainActor.run {
                self.isSessionRunning = false
            }
        }
    }

    func capturePhoto() {
        let settings = AVCapturePhotoSettings()
        photoOutput.capturePhoto(with: settings, delegate: self)
    }

    private func cropImage(_ image: UIImage, to normalizedRect: CGRect) -> UIImage? {
           let imageWidth = CGFloat(image.cgImage?.width ?? 0)
           let imageHeight = CGFloat(image.cgImage?.height ?? 0)

           guard imageWidth > 0, imageHeight > 0 else {
               logger.error("Invalid image dimensions for cropping")
               return nil
           }

           // Convert normalized rect to image coordinates
           let cropRect = CGRect(
               x: normalizedRect.origin.x * imageWidth,
               y: normalizedRect.origin.y * imageHeight,
               width: normalizedRect.size.width * imageWidth,
               height: normalizedRect.size.height * imageHeight
           )

           // Ensure crop rect is valid
           guard cropRect.size.width > 0, cropRect.size.height > 0,
                 cropRect.origin.x >= 0, cropRect.origin.y >= 0,
                 cropRect.maxX <= imageWidth, cropRect.maxY <= imageHeight,
                 let cgImage = image.cgImage?.cropping(to: cropRect) else {
               logger.error("Invalid crop rectangle or cropping failed")
               return nil
           }
           return UIImage(cgImage: cgImage, scale: image.scale, orientation: image.imageOrientation)
       }
}

extension CameraManager: AVCapturePhotoCaptureDelegate {
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        if let error = error {
            logger.error("Photo capture error: \(error.localizedDescription)")
            Task { @MainActor in
                self.error = .photoProcessingFailed
            }
            return
        }

        guard let data = photo.fileDataRepresentation(),
              let image = UIImage(data: data) else {
            logger.error("Failed to process photo data")
            Task { @MainActor in
                self.error = .photoProcessingFailed
            }
            return
        }

        Task { @MainActor in
            processAndStoreCapturedImage(image)
        }

    }


    private func processAndStoreCapturedImage(_ image: UIImage) {
        guard let previewLayer = self.videoPreviewLayer else {
            let resizedImage = image.resized(toMax: 1024)
            self.lastCapturedPhoto = CapturedPhoto(image: resizedImage)
            return
        }

        let previewSize = previewLayer.bounds.size
        let focusRect = CGRect(
            x: (previewSize.width - focusSize) / 2,
            y: (previewSize.height - focusSize) / 2,
            width: focusSize,
            height: focusSize
        )

        let metadataOutputRect = previewLayer.metadataOutputRectConverted(fromLayerRect: focusRect)

        // Crop image to the focus area
        if let croppedImage = cropImage(image, to: metadataOutputRect) {
            self.lastCapturedPhoto = CapturedPhoto(image: croppedImage)
        } else {
            logger.warning("Cropping failed, using full image")
            self.lastCapturedPhoto = CapturedPhoto(image: image)
        }
    }
}

extension UIImage {
    func resized(toMax dimension: CGFloat) -> UIImage {
        let aspectRatio = size.width / size.height
        var newSize: CGSize

        if aspectRatio > 1 {
            newSize = CGSize(width: dimension, height: dimension / aspectRatio)
        } else {
            newSize = CGSize(width: dimension * aspectRatio, height: dimension)
        }

        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        draw(in: CGRect(origin: .zero, size: newSize))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return newImage ?? self
    }
}
