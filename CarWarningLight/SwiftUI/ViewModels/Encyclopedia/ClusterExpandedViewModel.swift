//
//  ClusterExpandedViewModel.swift
//  CarWarningLight
//
//  Created by Sam Greenhill on 8/31/26.
//  Copyright © 2026 simplyAmazingMachines. All rights reserved.
//

import SwiftUI

@Observable
@MainActor
final class ClusterExpandedViewModel {
    var showText: Bool                  = false
    var titleOpacity: Double            = 0
    var titleOffset: CGFloat            = 30

    var card1Opacity: Double            = 0
    var card1Offset: CGFloat            = 30
    var card2Opacity: Double            = 0
    var card2Offset: CGFloat            = 30
    var card3Opacity: Double            = 0
    var card3Offset: CGFloat            = 30

    var isDismissing: Bool              = false
    var hasAppeared: Bool               = false
    var showDismissButton: Bool         = false

    private var animationTask: Task<Void, Never>?

    func startAnimations() {
        guard !isDismissing else { return }
      

        withAnimation(.easeOut(duration: 0.4)) {
            showText                    = true
            titleOpacity                = 1
            titleOffset                 = 0
        }

        animationTask = Task {
            await runStaggeredSequence()
        }
    }

    private func runStaggeredSequence() async {
        try? await Task.sleep(for: .seconds(0.3))
        guard !Task.isCancelled else { return }
        withAnimation(.spring(response: 0.5, dampingFraction: 0.7)) {
            card1Opacity = 1
            card1Offset = 0
        }

        try? await Task.sleep(for: .seconds(0.2))
        guard !Task.isCancelled else { return }
        withAnimation(.spring(response: 0.5, dampingFraction: 0.7)) {
            card2Opacity = 1
            card2Offset = 0
        }

        try? await Task.sleep(for: .seconds(0.2))
        guard !Task.isCancelled else { return }
        withAnimation(.spring(response: 0.5, dampingFraction: 0.7)) {
            card3Opacity = 1
            card3Offset = 0
        }

        try? await Task.sleep(for: .seconds(0.2))
        guard !Task.isCancelled, !isDismissing else { return }
        withAnimation(.easeInOut(duration: 0.3)) {
            showDismissButton = true
        }
    }


    func resetAnimations() {
        cancelAnimations()

        showText     = false
        titleOpacity = 0
        titleOffset  = 30

        card1Opacity = 0
        card1Offset  = 30
        card2Opacity = 0
        card2Offset  = 30
        card3Opacity = 0
        card3Offset  = 30

        showDismissButton = false
    }

    func cancelAnimations() {
        animationTask?.cancel()
        animationTask = nil
    }

    func dismissView() {
        guard !isDismissing else { return }
        cancelAnimations()

        isDismissing = true
        showDismissButton = false

        withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
            hasAppeared = false
        }
    }

}
