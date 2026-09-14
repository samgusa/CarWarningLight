//
//  ClusterRootView.swift

import SwiftUI
import PhotosUI
import AVFoundation
import SwiftData


enum AppTab: String, CaseIterable {
    case encyclopedia           = "ENCYCLOPEDIA"
    case garage                 = "Garage"
    case settings               = "Settings"

    var icon: String {
        switch self {
        case .encyclopedia:      return "book.closed.fill"
        case .garage:            return "wrench.and.screwdriver.fill"
        case .settings:          return "gearshape.fill"
        }
    }
}

struct ClusterRootView: View {

    @Environment(\.allLights) private var allLights
    @EnvironmentObject private var uiState: UIStateManager
    @Environment(\.modelContext) private var modelContext

    @Query(sort: \Vehicle.dateCreated) private var vehicles: [Vehicle]

    @State private var activeTab: AppTab            = .encyclopedia

    @State private var isScrolledDown: Bool         = false

    @State private var showCamera: Bool                   = false
    @State private var showImagePicker: Bool              = false
    @State private var pickerItem: PhotosPickerItem?

    @State private var isDetailActive: Bool               = false

    @State private var photoForPreview: CapturedPhoto?

    @State private var detailSymbol: CarSymbol?
    @State private var detailLogEntry: LightLogEntry?

    @State private var pendingCapturedImage: UIImage?
    @State private var pendingPostPreviewAction: (() -> Void)?

    @State private var showNoVehicleAlert: Bool     = false
    @State private var pendingLightLog: PendingLightLog?

    @Namespace private var standaloneNamespace
    @Namespace private var tabAnimation

    var body: some View {
        ZStack(alignment: .bottom) {
            GeometryReader { geo in
                let tabs = AppTab.allCases
                let currentIndex = tabs.firstIndex(of: activeTab) ?? 0

                HStack(spacing: 0) {
                    ClusterEncyclopediaView(
                        isScrolledDown: $isScrolledDown,
                        onLogEntry: { symbol in
                            requestLogLight(symbol) { vehicle in
                                let entry = LightLogEntry(carSymbol: symbol, dateLogged: Date(), vehicle: vehicle)
                                modelContext.insert(entry)
                            }
                        },
                        isDetailActive: $isDetailActive
                    )
                        .frame(width: geo.size.width)

                    NavigationStack {
                        ClusterGarageView(
                            isScrolledDown: $isScrolledDown
                        )
                    }
                    .frame(width: geo.size.width)

                    NavigationStack {
                        ClusterSettingsView()
                    }
                    .frame(width: geo.size.width)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .offset(x: -CGFloat(currentIndex) * geo.size.width)
                .animation(.spring(response: 0.42, dampingFraction: 0.88, blendDuration: 0), value: currentIndex)
            }

            customTabBar
                .padding(.horizontal, 20)
                .padding(.bottom, 24)
                .opacity(isDetailActive ? 0 : 1)
                .scaleEffect(isDetailActive ? 0.9 : 1, anchor: .bottom)
                .allowsHitTesting(!isDetailActive)
                .animation(.easeInOut(duration: 0.25), value: isDetailActive)
        }
        .preferredColorScheme(.dark)
        .ignoresSafeArea(edges: .bottom)
        .fullScreenCover(isPresented: $showCamera, onDismiss: {
            guard let image = pendingCapturedImage else { return }
            pendingCapturedImage = nil
            photoForPreview = CapturedPhoto(image: image, source: .camera)
        }) {
            CameraView { image in
                pendingCapturedImage    = image
                showCamera              = false
            }
        }
        .fullScreenCover(item: $photoForPreview, onDismiss: {
            pendingPostPreviewAction?()
            pendingPostPreviewAction = nil
        }) { photo in
            ClusterScanFlowView(
                capturedPhoto: photo,
                onScanLogged: { symbol in
                    requestLogLight(symbol) { vehicle in
                        let entry = LightLogEntry(carSymbol: symbol, dateLogged: Date(), vehicle: vehicle)
                        modelContext.insert(entry)
                        pendingPostPreviewAction = {
                            detailSymbol = symbol
                            detailLogEntry = entry
                        }
                        photoForPreview = nil
                    }
                },
                onNoMatch: {
                    pendingPostPreviewAction = { activeTab = .encyclopedia }
                    photoForPreview = nil
                },
                onDismiss: {
                    photoForPreview = nil
                },
                onRetakePhoto: { source in
                    pendingPostPreviewAction = {
                        switch source {
                        case .camera:   showCamera = true
                        case .library:  showImagePicker = true
                        }
                    }
                    photoForPreview = nil
                }
            )
        }
        .fullScreenCover(item: $detailSymbol) { symbol in
            ClusterExpandedView(
                carSymbol: symbol,
                namespace: standaloneNamespace,
                isShowingLarge: .constant(true),
                bigImageId: 0,
                index: .constant(0),
                isStandAlone: true,
                logEntry: detailLogEntry,
                onToggleResolved: {
                    detailLogEntry?.isActive.toggle()
                },
                onDismiss: {
                    detailSymbol = nil
                    detailLogEntry = nil
                }
            )
            .environmentObject(uiState)
        }
        .sheet(item: $pendingLightLog) { pending in
            ClusterVehiclePickerSheet(vehicle: vehicles, symbol: pending.symbol) { vehicle in
                pending.completion(vehicle)
                pendingLightLog = nil
            }
        }
        .alert("Add a Vehicle First", isPresented: $showNoVehicleAlert) {
            Button("Go to Garage") { activeTab = .garage }
            Button("Cancel", role: .cancel) { }
        } message: {
            Text("There's no vehicle to attach this light to yet. Add one from the Garage tab, then log the light again.")
        }
        .photosPicker(isPresented: $showImagePicker, selection: $pickerItem, matching: .images)
        .onChange(of: pickerItem) { _, newItem in
            guard let item = newItem else { return }
            Task {
                do {
                    if let data = try await item.loadTransferable(type: Data.self), let uiImage = UIImage(data: data) {
                        photoForPreview = CapturedPhoto(image: uiImage, source: .library)
                    }
                } catch {
                    print("Photo load failed: \(error)")
                }
                pickerItem = nil
            }
        }
    }

    private func requestLogLight(_ symbol: CarSymbol, completion: @escaping (Vehicle) -> Void) {
        if vehicles.isEmpty {
            showNoVehicleAlert = true
        } else if vehicles.count == 1, let only = vehicles.first {
            completion(only)
        } else {
            pendingLightLog = PendingLightLog(
                symbol: symbol,
                completion: completion
            )
        }
    }

    private var customTabBar: some View {
        HStack(spacing: 10) {
            HStack(spacing: 0) {
                ForEach(AppTab.allCases, id: \.self) { tab in
                    let isActive = activeTab == tab

                    if !isScrolledDown || isActive {
                        tabButton(tab)
                    }

                    if !isScrolledDown && tab != AppTab.allCases.last {
                        Spacer(minLength: 0)
                    }
                }
            }
            .padding(.horizontal, isScrolledDown ? 0 : 8)
            .frame(width: isScrolledDown ? 54 : nil, height: 54)
            .padding(.vertical, isScrolledDown ? 0 : 8)
            .background(
                Capsule()
                    .fill(.ultraThinMaterial)
                    .overlay {
                        Capsule()
                            .stroke(Color.white.opacity(0.12), lineWidth: 0.5)
                    }
            )
            .animation(.spring(response: 0.4, dampingFraction: 0.82), value: isScrolledDown)
            .animation(.spring(response: 0.35, dampingFraction: 0.8), value: activeTab)

            if isScrolledDown {
                Spacer()
            }

            ClusterFloatingButtonView(buttonSize: 54) {
                FloatingAction(symbol: "camera.fill", background: ClusterTheme.Colors.amber) {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { showCamera = true }
                }
                FloatingAction(symbol: "photo.fill", background: ClusterTheme.Colors.green) {
                    showImagePicker = true
                }
            } label: { isExpanded in
                ClusterFABLabel(isExpanded: isExpanded)
            }
        }
    }

    @ViewBuilder
    private func tabButton(_ tab: AppTab) -> some View {
        let isActive = activeTab == tab

        Button {
            guard tab != activeTab else { return }
            withAnimation(.spring(response: 0.38, dampingFraction: 0.8)) {
                activeTab = tab
            }
        } label: {
            HStack(spacing: 6) {
                Image(systemName: tab.icon)
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundStyle(isActive ? (isScrolledDown ? ClusterTheme.Colors.amber : Color.white) : Color.secondary)
                    .scaleEffect(isActive ? 1.05 : 0.8)
                    .frame(width: isScrolledDown ? 54 : nil, height: isScrolledDown ? 54 : nil)
                    .padding(.horizontal, activeTab != tab ? 5 : 0)

                if isActive && !isScrolledDown{
                    Text(tab.rawValue)
                        .font(.system(size: 11, weight: .bold))
                        .scaleEffect(isActive ? 1.05 : 0.8)
                        .foregroundStyle(isActive ? (isScrolledDown ? ClusterTheme.Colors.amber : Color.white) : Color.secondary)
                        .transition(.opacity.combined(with: .scale(scale: 0.9, anchor: .leading)))
                        .lineLimit(1)
                }
            }
            .animation(.spring(response: 0.3, dampingFraction: 0.75), value: isActive)
            .padding(.horizontal, isScrolledDown ? 0 : (isActive ? 16 : 12))
            .padding(.vertical, isScrolledDown ? 0 : 15)
            .background {
                if isActive && !isScrolledDown {
                    Capsule()
                        .fill(ClusterTheme.Colors.amber)
                        .matchedGeometryEffect(id: "activeTabIndicator", in: tabAnimation)
                }
            }
            .animation(.spring(response: 0.3, dampingFraction: 0.75), value: isActive)
        }
        .buttonStyle(.plain)
        .transition(.asymmetric(
            insertion: .opacity.combined(with: .scale(scale: 0.7)),
            removal: .opacity.combined(with: .scale(scale: 0.7))
        ))
        .accessibilityLabel(tab.rawValue)
        .accessibilityAddTraits(isActive ? [.isSelected] : [])
    }
}

#Preview {
    ClusterRootView()
    .environmentObject(UIStateManager())
    .preferredColorScheme(.dark)
}

struct ScrollOffsetPreferenceKey: PreferenceKey {
    static var defaultValue: CGFloat = 0
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
}

extension View {
    func trackScrollOffset(isScrolledDown: Binding<Bool>) -> some View {
        self.modifier(ScrollTrackerModifier(isScrolledDown: isScrolledDown))
    }
}

struct ScrollTrackerModifier: ViewModifier {
    @Binding var isScrolledDown: Bool
    @State private var previousOffset: CGFloat = 0

    func body(content: Content) -> some View {
        content
            .onScrollGeometryChange(for: CGFloat.self) { geometry in
                geometry.contentOffset.y + geometry.contentInsets.top
            } action: { _, newValue in
                defer { previousOffset = newValue }

                // always expanded near top, regardless of direction
                guard newValue > 40 else {
                    setScrolledDown(false)
                    return
                }
                let delta = newValue - previousOffset

                guard abs(delta) > 4 else { return }

                setScrolledDown(delta > 0)
            }

    }

    private func setScrolledDown(_ value: Bool) {
        guard value != isScrolledDown else { return }
        withAnimation(.spring(response: 0.4, dampingFraction: 0.82)) {
            isScrolledDown = value
        }
    }
}
