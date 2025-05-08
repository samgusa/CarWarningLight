//
//  CameraView.swift
//  CarWarningLight
//
//  Created by Sam Greenhill on 4/30/25.
//  Copyright © 2025 simplyAmazingMachines. All rights reserved.
//

import SwiftUI
import AVFoundation

struct CameraPreview: UIViewRepresentable {
    @ObservedObject var cameraManager: CameraManager // Observe the CameraManager
    let setPreviewLayer: (AVCaptureVideoPreviewLayer) -> Void

    func makeUIView(context: Context) -> UIView {
        let view = UIView(frame: UIScreen.main.bounds)
        let previewLayer = AVCaptureVideoPreviewLayer(session: cameraManager.session)
        previewLayer.videoGravity = .resizeAspectFill

        previewLayer.frame = view.bounds

        setPreviewLayer(previewLayer)
        view.layer.addSublayer(previewLayer)

        return view
    }

    func updateUIView(_ uiView: UIView, context: Context) {
        if let previewLayer = uiView.layer.sublayers?.first as? AVCaptureVideoPreviewLayer {
            previewLayer.frame = uiView.bounds
        }
    }
}

struct CameraView: View {
    @StateObject private var cameraManager = CameraManager()
    @State private var showPermissionAlert = false
    @State private var navigateToPreview = false
    @State private var showPhotoPreview: Bool = false

    let focusSquareSize: CGFloat = 150

    var body: some View {
        NavigationStack {
            ZStack {
                backgroundView
                cameraPreview
                if !cameraManager.isSessionRunning { loadingOverlay }
                CameraFocusShape(size: focusSquareSize, lineWidth: 4, color: .white, gapSize: 100)
                controls
            }
            .onChange(of: cameraManager.lastCapturedPhoto, { oldValue, newValue in
                if newValue != nil {
                    showPhotoPreview = true
                }
            })
            .navigationDestination(isPresented: $showPhotoPreview, destination: {
                if let image = cameraManager.lastCapturedPhoto {
                    PhotoPreviewView(capturedPhoto: image)
                }
            })
            .onAppear {
                checkPermissionAndStart()
            }
            .onDisappear {
                cameraManager.stopSession()
            }
            .alert(isPresented: $showPermissionAlert) {
                Alert(
                    title: Text("Camera Permission Denied"),
                    message: Text("Please allow camera access in Settings."),
                    primaryButton: .default(Text("Open Settings"), action: openSettings),
                    secondaryButton: .cancel()
                )
            }
        }
    }

    private var backgroundView: some View {
        Color.black.ignoresSafeArea()
    }

    private var loadingOverlay: some View {
            Color.black.ignoresSafeArea()
        }

    private var cameraPreview: some View {
        CameraPreview(cameraManager: cameraManager) { layer in
            cameraManager.setPreviewLayer(layer)
        }
        .opacity(cameraManager.isSessionRunning ? 1 : 0)
    }

    private var controls: some View {
            VStack {
                Spacer()
                Button(action: {
                    cameraManager.capturePhoto()
                }) {
                    ZStack {
                        Circle()
                            .fill(Color.white)
                            .frame(width: 70, height: 70)

                        Circle()
                            .stroke(.white, lineWidth: 3)
                            .frame(width: 75)
                    }
                }
            }
        }

    private func checkPermissionAndStart() {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .authorized:
            cameraManager.startSession()
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { granted in
                DispatchQueue.main.async {
                    if granted {
                        cameraManager.startSession()
                    } else {
                        showPermissionAlert = true
                    }
                }
            }
        default:
            showPermissionAlert = true
        }
    }

    private func openSettings() {
        if let url = URL(string: UIApplication.openSettingsURLString) {
            UIApplication.shared.open(url)
        }
    }
}

#Preview {
    CameraView()
        .environmentObject(UIStateManager())
}
