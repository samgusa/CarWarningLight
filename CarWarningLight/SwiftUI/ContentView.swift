//
//  ContentView.swift
//  CarWarningLight
//
//  Created by Sam Greenhill on 4/23/25.
//  Copyright © 2025 simplyAmazingMachines. All rights reserved.
//

import SwiftUI
import PhotosUI

struct ContentView: View {
    @EnvironmentObject private var uiState: UIStateManager
    @State private var showCamera: Bool = false
    @State private var showImagePicker = false
    @State private var isShowingDetail: Bool = false
    @State private var inputImage: UIImage?
    @State private var showResultsView: Bool = false
    @State private var pickerItem: PhotosPickerItem?


    private let placeholderImage = UIImage(systemName: "photo.fill") ?? UIImage()

    var body: some View {
        NavigationStack {
            WarningLightView()
                .overlay(alignment: .bottomTrailing) {
                    if uiState.shouldShowFAB {
                        FloatingButtonView {
                            FloatingAction(symbol: "photo.fill") {
                                showImagePicker.toggle()
                            }
                            FloatingAction(symbol: "camera.fill") {
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                                    showCamera.toggle()
                                }
                            }
                        } label: { isExpanded in
                            Image(systemName: "plus")
                                .font(.title3)
                                .fontWeight(.semibold)
                                .foregroundStyle(.white)
                                .rotationEffect(.init(degrees: isExpanded ? 45 : 0))
                                .scaleEffect(1.02)
                                .frame(maxWidth: .infinity, maxHeight: .infinity)
                                .background(.black, in: .circle)
                                .scaleEffect(isExpanded ? 0.9 : 1)
                        }
                        .padding(.horizontal)
                        .transition(.move(edge: .bottom).combined(with: .opacity))
                    }
                }
                .animation(.spring(response: 0.1, dampingFraction: 0.7), value: uiState.shouldShowFAB)
                .fullScreenCover(isPresented: $showCamera) {
                    CameraView()
                }
                .navigationDestination(isPresented: $showResultsView) {
                    if let selectedImage = inputImage {
                        PhotoPreviewView(capturedPhoto: CapturedPhoto(image: selectedImage))
                    } else {
                        PhotoPreviewView(capturedPhoto: CapturedPhoto(image: placeholderImage))
                    }

                }
                .photosPicker(isPresented: $showImagePicker, selection: $pickerItem, matching: .images)
                .onChange(of: pickerItem) { oldValue, newValue in
                    Task {
                        if let data = try? await pickerItem?.loadTransferable(type: Data.self), let uiImage = UIImage(data: data) {
                            inputImage = uiImage
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                                showResultsView = true
                            }
                        }
                    }
                }
        }

    }
}

#Preview {
    ContentView()
        .environmentObject(UIStateManager())
}
