//
//  ExpandedViewModel.swift
//  CarWarningLight
//
//  Created by Sam Greenhill on 4/27/25.
//  Copyright © 2025 simplyAmazingMachines. All rights reserved.
//

import Foundation
import SwiftUI
import Combine

class ExpandedViewModel: ObservableObject {
    // Title animation properties
    @Published var showText = false
    @Published var titleOpacity: Double = 0
    @Published var titleOffset: CGFloat = 30

    // Card animation properties
    @Published var card1Opacity: Double = 0
    @Published var card1Offset: CGFloat = 30

    @Published var card2Opacity: Double = 0
    @Published var card2Offset: CGFloat = 30

    @Published var card3Opacity: Double = 0
    @Published var card3Offset: CGFloat = 30

    // View State management
    @Published var isDismissing: Bool = false
    @Published var hasAppeared: Bool = false

    // Animation Timers
    private var animationCancellables = Set<AnyCancellable>()

    @Published var showDismissButton: Bool = false

    func startAnimations() {

        guard !isDismissing else { return }

        // Reset all animation states first
        resetAnimations()

        // Show title with animation
        withAnimation(.easeOut(duration: 0.4)) {
            showText = true
            titleOpacity = 1
            titleOffset = 0
        }

        // Stagger card animations with Combine publishers instead of timers
        Just(())
            .delay(for: .seconds(0.3), scheduler: RunLoop.main)
            .sink { [weak self] _ in
                guard let self = self else { return }
                withAnimation(.spring(response: 0.5, dampingFraction: 0.7)) {
                    self.card1Opacity = 1
                    self.card1Offset = 0
                }
            }
            .store(in: &animationCancellables)


        Just(())
            .delay(for: .seconds(0.5), scheduler: RunLoop.main)
            .sink { [weak self] _ in
                guard let self = self else { return }
                withAnimation(.spring(response: 0.5, dampingFraction: 0.7)) {
                    self.card2Opacity = 1
                    self.card2Offset = 0
                }
            }
            .store(in: &animationCancellables)


        Just(())
            .delay(for: .seconds(0.7), scheduler: RunLoop.main)
            .sink { [weak self] _ in
                guard let self = self else { return }
                withAnimation(.spring(response: 0.5, dampingFraction: 0.7)) {
                    self.card3Opacity = 1
                    self.card3Offset = 0
                }
            }
            .store(in: &animationCancellables)

        Just(())
            .delay(for: .seconds(0.9), scheduler: RunLoop.main)
            .sink { [weak self] _ in
                guard let self = self, !self.isDismissing else { return }
                withAnimation(.easeInOut(duration: 0.3)) {
                    self.showDismissButton = true
                }
            }
            .store(in: &animationCancellables)


    }

    func resetAnimations() {
        // Cancel any running animations
        cancelAnimations()

        // Reset all states to initial values
        showText = false
        titleOpacity = 0
        titleOffset = 30

        card1Opacity = 0
        card1Offset = 30

        card2Opacity = 0
        card2Offset = 30

        card3Opacity = 0
        card3Offset = 30

        showDismissButton = false
    }

    func cancelAnimations() {
        // cancel all publishers
        animationCancellables.forEach { $0.cancel() }
        animationCancellables.removeAll()
    }

    func dismissView() {
        guard !isDismissing else { return }

        cancelAnimations()

        isDismissing = true
        showDismissButton = false

        withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
            hasAppeared = false
            cancelAnimations()
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.7) {
            self.isDismissing = false
        }
    }

    deinit {
        cancelAnimations()
    }
}
