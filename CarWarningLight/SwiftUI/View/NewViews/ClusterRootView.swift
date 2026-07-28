//
//  ClusterRootView.swift
//  CarWarningLight
//
//  Created by Sam Greenhill on 7/27/26.
//  Copyright © 2026 simplyAmazingMachines. All rights reserved.
//

import SwiftUI
import PhotosUI

struct ClusterRootView: View {
    enum AppTab { case encyclopedia, dashboard, tripLog }

    let allLights: [CarSymbol]
    @EnvironmentObject private var uiState: UIStateManager

    @State private var activeTab: AppTab?           = .encyclopedia
    @State private var isFABExpanded: Bool          = false
    @State private var tabBar: UITabBar?

    @State private var vehicles: [Vehicle]          = [Vehicle(name: "My Vehicle", systemStatuses: VehicleSystem.allCases.map { SystemStatus(system: $0) })]
    @State private var selectedVehicleID: UUID      = UUID()
    @State private var logEntries: [LightLogEntry]  = []

    @State private var showCamera: Bool             = false
    @State private var showImagePicker: Bool        = false
    @State private var pickerItem: PhotosPickerItem?
    @State private var inputImage: UIImage?
    @State private var showPhotoPreview: Bool       = false

    private let placeholderImage                    = UIImage(systemName: "photo.fill") ?? UIImage()

    var body: some View {
        TabView(selection: $activeTab) {
            Tab("Encyclopedia", systemImage: "book.closed.fill", value: AppTab.encyclopedia) {
                NavigationStack {
                    ClusterEncyclopediaView(allLights: allLights)
                }
                .tabOverlay(isPresented: isFABExpanded) { fabMenu } onDismiss: { isFABExpanded = false }
            }

            Tab("Dashboard", systemImage: "gauge.with.dots.needle.67percent", value: AppTab.dashboard) {
                ClusterDashboardView(vehicles: $vehicles, selectedVehicleID: $selectedVehicleID)
                    .tabOverlay(isPresented: isFABExpanded) { fabMenu } onDismiss: { isFABExpanded = false }
            }

            Tab("Trip Log", systemImage: "clock.arrow.circlepath", value: AppTab.tripLog) {
                ClusterTripLogView(entries: logEntries)
                    .tabOverlay(isPresented: isFABExpanded) { fabMenu } onDismiss: { isFABExpanded = false }
            }

            Tab(value: AppTab?.none, role: .search) {
                Color.clear
            } label: {
                Image(systemName: "plus")
            }
        }
        .tint(ClusterTheme.Colors.amber)
        .tabBarMinimizeBehavior(.onScrollDown)
        .toolbar(uiState.shouldShowFAB ? .visible : .hidden, for: .tabBar)
        .tabViewBottomAccessory {
            AccessoryView { _, _ in isFABExpanded = false }
        }
        .onChange(of: activeTab) { oldValue, newValue in
            if newValue == nil {
                UITabBar.setAnimationsEnabled(false)
                activeTab = oldValue
                DispatchQueue.main.async {
                    UITabBar.setAnimationsEnabled(true)
                    isFABExpanded.toggle()
                }
            }
        }
        .background(TabBarExtractor { tabBar = $0 })
        .compositingGroup()
        .onChange(of: isFABExpanded) { _, _ in animateFABIcon() }
        .onAppear {
            if let first = vehicles.first { selectedVehicleID = first.id }
        }
        .fullScreenCover(isPresented: $showCamera) {
            CameraView()
        }
        .fullScreenCover(isPresented: $showPhotoPreview) {
            ClusterPhotoPreviewView(
                capturedPhoto: CapturedPhoto(image: inputImage ?? placeholderImage),
                onScanLogged: { symbol in
                    logEntries.append(LightLogEntry(carSymbol: symbol, dateLogged: Date()))
                }
            )
        }
        .photosPicker(isPresented: $showImagePicker, selection: $pickerItem, matching: .images)
        .onChange(of: pickerItem) { _, _ in
            Task {
                if let data = try? await pickerItem?.loadTransferable(type: Data.self), let uiImage = UIImage(data: data) {
                    inputImage = uiImage
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { showPhotoPreview = true }
                }
            }
        }
    }

    var fabMenu: some View {
        HStack(spacing: 24) {
            fabAction(symbol: "camera.fill", label: "Camera", color: ClusterTheme.Colors.amber) {
                isFABExpanded = false
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { showCamera = true }
            }
            fabAction(symbol: "photo.fill", label: "Library", color: ClusterTheme.Colors.green) {
                isFABExpanded = false
                showImagePicker = true
            }
        }
        .padding(.vertical, 24)
        .frame(maxWidth: .infinity)
    }

    func fabAction(symbol: String, label: String, color: Color, action: @escaping() -> Void) -> some View {
        Button(action: action) {
            VStack(spacing: 8) {
                Image(systemName: symbol)
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundStyle(color)
                    .frame(width: 52, height: 52)
                    .background(
                        Circle()
                            .fill(color.opacity(0.15))
                    )
                Text(label)
                    .font(ClusterTheme.Types.mono(11, weight: .semibold))
                    .foregroundStyle(ClusterTheme.Colors.textPrimary)
            }
        }
        .buttonStyle(.plain)
    }

    func animateFABIcon() {
        let fabImageViews = (tabBar?.subviews(type: UIImageView.self) ?? [])
            .filter { $0.description.contains("plus") }
        for imageView in fabImageViews {
            let transform: CGAffineTransform = isFABExpanded ? .init(rotationAngle: 45 * .pi / 180) : .identity
            UIView.animate(withDuration: 0.2) {
                imageView.layer.setAffineTransform(transform)
            }
        }
    }
}

#Preview {
    ClusterRootView(allLights: [
        CarSymbol(id: 1, name: "Check Engine Light", imageName: "Check Engine Light", description: "Sample description.", symbolType: .warning, fixDescription: "Sample fix.", drivable: .no, categories: nil),
        CarSymbol(id: 2, name: "Battery Charging Light", imageName: "Battery Charging Light", description: "Sample description.", symbolType: .warning, fixDescription: "Sample fix.", drivable: .uncertain, categories: nil),
        CarSymbol(id: 3, name: "Tire Pressure Warning Light", imageName: "Tire Pressure Warning Light", description: "Sample description.", symbolType: .advisory, fixDescription: "Sample fix.", drivable: .yes, categories: nil),
    ])
    .environmentObject(UIStateManager())
    .preferredColorScheme(.dark)
}
