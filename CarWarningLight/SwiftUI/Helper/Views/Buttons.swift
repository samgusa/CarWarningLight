//
//  Buttons.swift
//  CarWarningLight
//
//  Created by Sam Greenhill on 5/6/25.
//  Copyright © 2025 simplyAmazingMachines. All rights reserved.
//

import Foundation
import SwiftUI

struct CustomButtonLabel<LabelContent: View>: View {
    var content: () -> LabelContent
    var state: ButtonState
    var wiggle: Bool

    private var isCircular: Bool {
        if case .idle = state { return false }
        return true
    }

    private var showProgressView: Bool {
        if case .loading = state { return true }
        return false
    }

    private var showCheckmark: Bool {
        if case .success = state { return true }
        return false
    }

    private var showXmark: Bool {
        if case .failed = state { return true }
        return false
    }

    var body: some View {
        ZStack {
            // Button background
            Capsule()
                .fill(Color.white)
                .shadow(color: Color.primary.opacity(0.1), radius: 6)
                .frame(width: isCircular ? 50 : 250, height: 50)
                .animation(.spring(duration: 0.4, bounce: 0.2), value: isCircular)


            // Label content (text)
            content()
                .padding(.horizontal, 30)
                .padding(.vertical, 12)
                .lineLimit(1)
                .opacity(isCircular ? 0 : 1)
                .transition(.opacity.combined(with: .scale))

            // Progress view
            if showProgressView {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle(tint: Color.black))
                    .transition(.opacity)
            }

            // Success checkmark
            if showCheckmark {
                AnimatedCheckmarkView(frameSize: 50)
                    .transition(.opacity)
            }

            // Failure X mark
            if showXmark {
                AnimatedXMark(frameSize: 50)
                    .transition(.opacity)
            }
        }
        .wiggle(wiggle)
    }
}

// Button states to better manage transitions
enum ButtonState: Equatable {
    case idle
    case loading
    case success
    case failed(String)
}

// Improved CustomButton with optimized state management
struct CustomButton<ButtonContent: View>: View {
    var content: () -> ButtonContent
    var action: () async -> TaskStatus
    var onSuccessComplete: (() -> Void)? = nil

    @State private var buttonState: ButtonState = .idle
    @State private var wiggle: Bool = false
    @State private var showAlert: Bool = false
    @State private var errorMessage: String = ""

    var body: some View {
        Button {
            Task {
                // Don't re-trigger if already in progress
                guard case .idle = buttonState else { return }

                // Update to loading state
                withAnimation(.spring(duration: 0.4, bounce: 0.2)) {
                    buttonState = .loading
                }

                // Add a minimum duration for the loading state (2 seconds)
                let operationTask = Task { await action() }
                let delayTask = Task {
                    try? await Task.sleep(for: .seconds(2))
                }

                // Wait for both the operation and minimum delay
                let status = await operationTask.value
                await delayTask.value

                // Update state based on result
                switch status {
                case .idle:
                    // Should rarely happen, but handle it
                    withAnimation(.spring(duration: 0.4, bounce: 0.2)) {
                        buttonState = .idle
                    }

                case .success:
                    withAnimation(.snappy) {
                        buttonState = .success
                    }

                    // Return to idle after showing success
                    try? await Task.sleep(for: .seconds(2.0))

                    // call Completion handler if provided
                    if let onSuccessComplete = onSuccessComplete {
                        onSuccessComplete()
                    }

                    // Reset button state
                    withAnimation(.spring(duration: 0.4, bounce: 0.2)) {
                        buttonState = .idle
                    }

                case .failed(let message):
                    errorMessage = message

                    withAnimation(.spring(duration: 0.4, bounce: 0.2)) {
                        buttonState = .failed(message)
                    }

                    // Wiggle animation for failure
                    wiggle.toggle()

                    // Show alert after a short delay
                    try? await Task.sleep(for: .seconds(0.8))
                    showAlert = true

                    // Return to idle after showing failure
                    try? await Task.sleep(for: .seconds(1.2))
                    withAnimation(.spring(duration: 0.4, bounce: 0.2)) {
                        buttonState = .idle
                    }
                }
            }
        } label: {
            CustomButtonLabel(
                content: content,
                state: buttonState,
                wiggle: wiggle
            )
        }
        .disabled(buttonState != .idle)
        .alert(errorMessage, isPresented: $showAlert) {
            Button("OK", role: .cancel) { }
        }
    }
}

// Preview for testing the improved button
struct ImprovedButtonPreview: View {
    var succeed: Bool = true

    var body: some View {
        VStack(spacing: 20) {
            CustomButton {
                Text("Identify Light")
                    .fontWeight(.semibold)
                    .foregroundStyle(.black)
            } action: {
                // Simulate network delay
                try? await Task.sleep(for: .seconds(1))

                if succeed {
                    return .success
                } else {
                    return .failed("Failed to identify the warning light")
                }
            }

            Text("Button will always show progress for at least 2 seconds")
                .font(.caption)
                .foregroundStyle(.secondary)
        }
        .padding()
    }
}

// Keep the original TaskStatus enum and wiggle extension
enum TaskStatus: Equatable {
    case idle
    case failed(String)
    case success
}

extension View {
    @ViewBuilder
    func wiggle(_ animate: Bool) -> some View {
        self
            .keyframeAnimator(initialValue: CGFloat.zero, trigger: animate) { view, value in
                view
                    .offset(x: value)
            } keyframes: { _ in
                KeyframeTrack {
                    CubicKeyframe(0, duration: 0.1)
                    CubicKeyframe(5, duration: 0.1)
                    CubicKeyframe(-5, duration: 0.1)
                    CubicKeyframe(5, duration: 0.1)
                    CubicKeyframe(-5, duration: 0.1)
                    CubicKeyframe(5, duration: 0.1)
                    CubicKeyframe(-5, duration: 0.1)
                    CubicKeyframe(5, duration: 0.1)
                    CubicKeyframe(0, duration: 0.1)
                }
            }
    }
}
#Preview(body: {
    VStack(spacing: 30) {
            ImprovedButtonPreview(succeed: true)
            ImprovedButtonPreview(succeed: false)
        }
})
