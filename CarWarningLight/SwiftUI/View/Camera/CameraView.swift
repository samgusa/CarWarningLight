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
    @Environment(\.dismiss) var dismiss
    @StateObject private var cameraManager = CameraManager()
    @State private var showPermissionAlert: Bool = false
    @State private var showPhotoPreview: Bool = false

    @State private var isAnimating: Bool = false

    private let focusSquareSize: CGFloat = 150

    var body: some View {
        NavigationStack {
            ZStack {
                Color.black.ignoresSafeArea()

                cameraPreview
                    .opacity(cameraManager.isSessionRunning ? 1: 0)

                VStack {
                    headerToolBar
                    Spacer()

                    ZStack {
                        CameraFocusShape(
                            size: focusSquareSize,
                            lineWidth: 3,
                            color: .white,
                            gapSize: focusSquareSize / 3,
                            cornerRadius: 10
                        )

                        RoundedRectangle(cornerRadius: 10)
                            .strokeBorder(.white.opacity(0.5), lineWidth: 3 / 2)
                            .frame(width: focusSquareSize - 3, height: focusSquareSize - 3)
                            .scaleEffect(isAnimating ? 1.1 : 1.0)
                            .opacity(isAnimating ? 0.0 : 0.3)
                            .animation(
                                Animation.easeInOut(duration: 1.5)
                                    .repeatForever(autoreverses: false),
                                value: isAnimating
                            )
                    }

                    Spacer()
                    controlsBar
                }
                .padding(.vertical)

            }
            .onChange(of: cameraManager.lastCapturedPhoto) { _, newPhoto in
                if newPhoto != nil {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                        showPhotoPreview = true
                    }
                }
            }
            .navigationDestination(isPresented: $showPhotoPreview, destination: {
                if let image = cameraManager.lastCapturedPhoto {
                    PhotoPreviewView(capturedPhoto: image)
                }
            })
            .onAppear {
                checkPermissionAndStart()
                self.isAnimating = true
            }
            .onDisappear {
                self.isAnimating = false
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
        .ignoresSafeArea(.all, edges: .all)
    }

    private var headerToolBar: some View {
        HStack {
            Button {
                dismiss()
            } label: {
                Image(systemName: "chevron.left")
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundStyle(.white)
                    .frame(width: 44, height: 44)
                    .background(Color.black.opacity(0.25))
                    .clipShape(Circle())
            }

            Spacer()
        }
        .padding(.horizontal)
    }

    private var loadingOverlay: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            VStack(spacing: 20) {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle())
                    .tint(.white)
                    .scaleEffect(1.5)
                Text("Initializing camera...")
                    .font(.headline)
                    .foregroundStyle(.white)
            }
        }
        .transition(.opacity)
    }

    private var cameraPreview: some View {
        CameraPreview(cameraManager: cameraManager) { layer in
            cameraManager.setPreviewLayer(layer)
        }
    }

    private var controlsBar: some View {
            HStack {
                Spacer()
                Button(action: {
                    cameraManager.capturePhoto()
                }) {
                    ZStack {
                        Circle()
                            .fill(Color.white)
                            .frame(width: 70, height: 70)
                            .shadow(color: .black.opacity(0.3), radius: 4, x: 0, y: 2)

                        Circle()
                            .stroke(.white.opacity(0.8), lineWidth: 4)
                            .frame(width: 82, height: 82)
                    }
                }
                Spacer()
            }
            .padding(.bottom)
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
