//
//  ClusterPhotoPreviewView.swift
//  CarWarningLight
//
//  Created by Sam Greenhill on 7/27/26.
//  Copyright © 2026 simplyAmazingMachines. All rights reserved.
//

//

import SwiftUI

struct ClusterPhotoPreviewView: View {
    @StateObject private var viewModel = ImageDetectionViewModel()
    @Environment(\.dismiss) private var dismiss

    let capturedPhoto: CapturedPhoto?

    var onScanLogged: (CarSymbol) -> Void = { _ in }
    var onNoMatch: () -> Void = { }

    @State private var buttonState: ScanButtonState = .idle
    @State private var showResults: Bool = false

    private enum ScanButtonState: Equatable {
        case idle, loading, success, failed(String)
    }

    var body: some View {
        ZStack {
            ClusterTheme.Colors.background
                .ignoresSafeArea()

            if let photo = capturedPhoto {
                VStack(spacing: 0) {
                    ClusterHeaderBar(title: "Scan") {
                        dismiss()
                    }
                    .clusterTopSafeArea(fill: ClusterTheme.Colors.panel)

                    VStack(spacing: 20) {
                        Spacer()

                        Image(uiImage: photo.image)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .clipShape(RoundedRectangle(cornerRadius: 16))
                            .overlay(
                                RoundedRectangle(cornerRadius: 16)
                                    .stroke(ClusterTheme.Colors.bezel, lineWidth: 1)
                            )
                            .padding(.horizontal)

                        Spacer()

                        identifySection
                    }
                }
            } else {
                emptyState
            }
        }
        .navigationBarBackButtonHidden(true)
        .fullScreenCover(isPresented: $showResults) {
            ClusterScanResultsView(matches: viewModel.scanMatches, onSelect: { selected in
                onScanLogged(selected)
            }, onNoMatch: onNoMatch)
        }
    }

    private var identifySection: some View {
        VStack(spacing: 14) {
            Text("Analyze dashboard warning light")
                .font(ClusterTheme.Types.body(15, weight: .semibold))
                .foregroundStyle(ClusterTheme.Colors.textPrimary)
            identifyButton
        }
        .padding(.bottom, 36)
    }

    private var identifyButton: some View {
        Button(action: runIdentify) {
            ZStack {
                switch buttonState {
                case .idle:
                    Text("Identify Light")
                        .font(ClusterTheme.Types.body(16, weight: .bold))
                case .loading:
                    ClusterGaugeLoader(color: ClusterTheme.Colors.background, size: 24)
                case .success:
                    Image(systemName: "checkmark")
                        .font(.system(size: 18, weight: .bold))
                case .failed(let string):
                    Image(systemName: "xmark")
                        .font(.system(size: 18, weight: .bold))
                }
            }
            .foregroundStyle(ClusterTheme.Colors.background)
            .frame(width: 220, height: 52)
            .background(stateColor)
            .clipShape(Capsule())
            .animation(.spring(duration: 0.3), value: buttonState)
        }
        .buttonStyle(.plain)
        .disabled(buttonState != .idle)
        .alert(failureMessage ?? "", isPresented: showFailureAlert) {
            Button("OK", role: .cancel) { }
        }
    }

    private var stateColor: Color {
        switch buttonState {
        case .idle, .loading: return ClusterTheme.Colors.amber
        case .success: return ClusterTheme.Colors.green
        case .failed: return ClusterTheme.Colors.red
        }
    }

    private var failureMessage: String? {
        if case .failed(let message) = buttonState { return message }
        return nil
    }

    private var showFailureAlert: Binding<Bool> {
        Binding(get: { failureMessage != nil }, set: { _ in })
    }

    private func runIdentify() {
        guard buttonState == .idle, let photo = capturedPhoto else { return }
        buttonState = .loading
        Task {
            let status = await viewModel.processImage(photo: photo.image)
            switch status {
            case .success:
                buttonState = .success
                try? await Task.sleep(for: .seconds(0.6))
                showResults = true
                buttonState = .idle
            case .failed(let message):
                buttonState = .failed(message)
                try? await Task.sleep(for: .seconds(1.6))
                buttonState = .idle
            case .idle:
                buttonState = .idle
            }
        }
    }

    private var emptyState: some View {
        VStack(spacing: 16) {
            Image(systemName: "exclamationmark.triangle")
                .font(.system(size: 44))
                .foregroundStyle(ClusterTheme.Colors.textSecondary)
            Text("No photo available")
                .font(ClusterTheme.Types.body(16, weight: .semibold))
                .foregroundStyle(ClusterTheme.Colors.textPrimary)
            Button("Go Back") { dismiss() }
                .font(ClusterTheme.Types.body(14, weight: .semibold))
                .foregroundStyle(ClusterTheme.Colors.textPrimary)
                .padding(.horizontal, 20)
                .padding(.vertical, 10)
                .background(ClusterTheme.Colors.panel)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(ClusterTheme.Colors.bezel, lineWidth: 1)
                )
                .clipShape(RoundedRectangle(cornerRadius: 10))
        }
    }
}

#Preview {
    ClusterPhotoPreviewView(capturedPhoto: CapturedPhoto(image: UIImage(systemName: "photo.fill") ?? UIImage()))
}

#Preview {
    ClusterPhotoPreviewView(capturedPhoto: CapturedPhoto(image: UIImage(systemName: "photo.fill") ?? UIImage()))
}


import SwiftUI
import UIKit

extension UIApplication {
    /// The safe area insets of the app's current key window, read live from UIKit.
    static var clusterKeyWindowSafeAreaInsets: UIEdgeInsets {
        shared.connectedScenes
            .compactMap { $0 as? UIWindowScene }
            .flatMap { $0.windows }
            .first(where: \.isKeyWindow)?
            .safeAreaInsets ?? .zero
    }
}

private enum ClusterSafeAreaBounds {
    // No iPhone's top inset (status bar / notch / Dynamic Island) exceeds
    // this, and no home indicator inset exceeds the bottom figure. Reading
    // straight from UIKit is normally reliable, but in some embedding
    // contexts (e.g. a hero-animated view that's never actually presented
    // as its own cover) the value it returns isn't trustworthy. Clamping to
    // what's physically possible on real hardware means a bad reading can
    // never balloon the layout, regardless of why it happened.
    static let maxTop: CGFloat = 62
    static let maxBottom: CGFloat = 40

    static var top: CGFloat {
        min(max(UIApplication.clusterKeyWindowSafeAreaInsets.top, 0), maxTop)
    }

    static var bottom: CGFloat {
        min(max(UIApplication.clusterKeyWindowSafeAreaInsets.bottom, 0), maxBottom)
    }
}

private struct ClusterTopSafeAreaModifier: ViewModifier {
    /// When non-nil, this color fills the inset strip itself (e.g. the area
    /// behind the Dynamic Island), so it visually blends into whatever sits
    /// just below it instead of showing the container's background through
    /// a transparent gap. Pass `nil` for the old plain-padding behavior.
    var fillColor: Color?

    @State private var topInset: CGFloat = ClusterSafeAreaBounds.top

    func body(content: Content) -> some View {
        VStack(spacing: 0) {
            if let fillColor {
                fillColor.frame(height: topInset)
            } else {
                Color.clear.frame(height: topInset)
            }
            content
        }
        .onAppear {
            // Refresh on appear too, in case the window wasn't key yet
            // at the moment this view's state was first initialized
            // (common right after a fullScreenCover presentation).
            topInset = ClusterSafeAreaBounds.top
        }
    }
}

private struct ClusterBottomSafeAreaModifier: ViewModifier {
    @State private var bottomInset: CGFloat = ClusterSafeAreaBounds.bottom

    func body(content: Content) -> some View {
        content
            .padding(.bottom, bottomInset)
            .onAppear {
                bottomInset = ClusterSafeAreaBounds.bottom
            }
    }
}

extension View {
    /// Pads the top of this view by the device's real top safe-area inset
    /// (Dynamic Island / notch / status bar), read directly from the key
    /// window rather than from SwiftUI's `safeAreaInset`/`safeAreaPadding`,
    /// and clamped to what's physically plausible on real hardware.
    ///
    /// Pair with `.ignoresSafeArea()` on the container so its background
    /// still bleeds edge-to-edge; only the content you attach this to gets
    /// pushed down.
    ///
    /// - Parameter fill: If provided, this color paints the inset strip
    ///   itself (the area behind the Dynamic Island/notch), so it blends
    ///   seamlessly into the view below rather than showing a gap of the
    ///   container's background color. Pass a view's own background color
    ///   (e.g. `ClusterTheme.Colors.panel` for a header bar) to make it look
    ///   like that view extends all the way to the top of the screen.
    func clusterTopSafeArea(fill color: Color? = nil) -> some View {
        modifier(ClusterTopSafeAreaModifier(fillColor: color))
    }

    /// Same idea as `clusterTopSafeArea()`, but for the bottom inset
    /// (home indicator).
    func clusterBottomSafeArea() -> some View {
        modifier(ClusterBottomSafeAreaModifier())
    }
}

