//
//  ClusterSafeAreaBounds.swift
//  CarWarningLight
//
//  Created by Sam Greenhill on 7/27/26.
//  Copyright © 2026 simplyAmazingMachines. All rights reserved.
//

//

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

