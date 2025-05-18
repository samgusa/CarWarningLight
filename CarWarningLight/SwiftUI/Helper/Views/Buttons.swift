//
//  Buttons.swift
//  CarWarningLight
//
//  Created by Sam Greenhill on 5/6/25.
//  Copyright © 2025 simplyAmazingMachines. All rights reserved.
//

import Foundation
import SwiftUI

// 1. Create a separate view for the label appearance
struct CustomButtonLabel<LabelContent: View>: View {
    var content: () -> LabelContent
    var isLoading: Bool
    var taskStatus: TaskStatus
    var wiggle: Bool

    var body: some View {
        content()
            .padding(.horizontal, 30)
            .padding(.vertical, 12)
            .opacity(isLoading ? 0 : 1)
            .lineLimit(1)
            .frame(width: isLoading ? 50 : nil, height: isLoading ? 50 : nil)
            .background(Color.white.shadow(.drop(color: Color.primary.opacity(0.1), radius: 6)), in: .capsule)
            .overlay {
                if isLoading && taskStatus == .idle {
                    ProgressView()
                }
            }
            .overlay {
                if taskStatus != .idle {
                    if case .failed = taskStatus {
                        AnimatedXMark(frameSize: 50)
                            .font(.title2.bold())
                            .foregroundStyle(.white)
                    } else {
                        AnimatedCheckmarkView(frameSize: 50)
                            .font(.title2.bold())
                            .foregroundStyle(.white)
                    }
                }
            }
            .wiggle(wiggle)
    }
}

// 2. Keep the original CustomButton but refactor to use CustomButtonLabel
struct CustomButton<ButtonContent: View>: View {
    var content: () -> ButtonContent
    var action: () async -> TaskStatus

    @State private var isLoading: Bool = false
    @State private var taskStatus: TaskStatus = .idle
    @State private var isFailed: Bool = false
    @State private var wiggle: Bool = false
    @State private var showPopup: Bool = false
    @State private var popupMessage: String = ""

    var body: some View {
        Button {
            Task {
                isLoading = true
                let status = await action()
                switch status {
                case .idle:
                    isFailed = false
                case .failed(let string):
                    isFailed = true
                    popupMessage = string
                case .success:
                    isFailed = false
                }
                self.taskStatus = status
                if isFailed {
                    try? await Task.sleep(for: .seconds(0.8))
                    wiggle.toggle()
                }
                try? await Task.sleep(for: .seconds(0.8))
                if isFailed {
                    showPopup = true
                }
                try? await Task.sleep(for: .seconds(1.2))
                self.taskStatus = .idle
                isLoading = false
                if showPopup {
                    showPopup = false
                }
            }
        } label: {
            CustomButtonLabel(
                content: content,
                isLoading: isLoading,
                taskStatus: taskStatus,
                wiggle: wiggle
            )
        }
        .disabled(isLoading)
        .animation(.snappy, value: isLoading)
        .animation(.snappy, value: taskStatus)
        .alert(popupMessage, isPresented: $showPopup) {
            Button("OK", role: .cancel) {}
        }
    }
}

// 4. Usage example with CustomButton
struct CompleteExample: View {
    var testSuccess: Bool
    var body: some View {
        CustomButton {
            Text("Submit")
        } action: {
            // Simulate an async operation
            try? await Task.sleep(for: .seconds(1))
            if testSuccess {
                return .success
            } else {
                return .failed("Error message")
            }
        }
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
    CompleteExample(testSuccess: false)
})

