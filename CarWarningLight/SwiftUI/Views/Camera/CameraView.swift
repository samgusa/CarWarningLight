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
    let cameraManager: CameraManager // Observe the CameraManager
    let setPreviewLayer: (AVCaptureVideoPreviewLayer) -> Void

    func makeUIView(context: Context) -> UIView {
        let view = UIView()
        let previewLayer = AVCaptureVideoPreviewLayer(session: cameraManager.session)
        previewLayer.videoGravity = .resizeAspectFill
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
    @State private var cameraManager        = CameraManager()
    @State private var showPermissionAlert: Bool = false
    @State private var isAnimating: Bool    = false

    var cropsToFocusSquare: Bool            = true
    var onPhotoCaptured: (UIImage) -> Void  = { _ in }

    private let focusSquareSize: CGFloat    = 150

    var body: some View {
        NavigationStack {
            ZStack {
                Color.black.ignoresSafeArea()

                cameraPreview
                    .opacity(cameraManager.isSessionRunning ? 1: 0)

                VStack {
                    headerToolBar
                    Spacer()

                    if cropsToFocusSquare {
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
                    } else {
                        Text("Frame the issue, then capture")
                            .font(.system(size: 13, weight: .semibold))
                            .foregroundStyle(.white.opacity(0.85))
                            .padding(.horizontal, 14)
                            .padding(.vertical, 8)
                            .background(Color.black.opacity(0.25))
                            .clipShape(Capsule())
                    }

                    Spacer()
                    controlsBar
                }
                .padding(.vertical)

            }
            .onChange(of: cameraManager.lastCapturedPhoto) { _, newPhoto in
                guard let photo = newPhoto else { return }
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                    onPhotoCaptured(photo.image)
                }
            }
            .onAppear {
                cameraManager.cropsToFocusSquare = cropsToFocusSquare
                checkPermissionAndStart()
                self.isAnimating = true
            }
            .onDisappear {
                self.isAnimating = false
                cameraManager.stopSession()
            }
            .clusterConfirmation(
                isPresented: $showPermissionAlert,
                title: "Camera Permission Denied",
                message: "Please allow camera access in Settings.",
                confirmLabel: "Open Settings",
                cancelLabel: "Cancel",
                isDestructive: false,
                onConfirm: openSettings
            )
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
