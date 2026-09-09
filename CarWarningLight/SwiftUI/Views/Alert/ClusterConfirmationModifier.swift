//
//  ClusterConfirmationModifier.swift
//  CarWarningLight
//
//  Created by Sam Greenhill on 9/6/26.
//  Copyright © 2026 simplyAmazingMachines. All rights reserved.
//

import SwiftUI

struct ClusterConfirmationModifier: ViewModifier {
    @Binding var isPresented: Bool
    let title: String
    let message: String
    let confirmLabel: String
    let cancelLabel: String
    let isDestructive: Bool
    let onConfirm: () -> Void


    func body(content: Content) -> some View {
        content
            .overlay {
                if isPresented {
                    ZStack {
                        Color.black
                            .opacity(0.6)
                            .ignoresSafeArea()
                            .onTapGesture { isPresented = false }

                        ClusterAlertCard(
                            title: title,
                            message: message,
                            confirmLabel: confirmLabel,
                            cancelLabel: cancelLabel,
                            isDestructive: isDestructive,
                            onConfirm: {
                                onConfirm()
                                isPresented = false
                            },
                            onCancel: { isPresented = false }
                        )
                    }
                    .transition(.opacity.combined(with: .scale(scale: 0.92)))
                    .animation(.spring(response: 0.35, dampingFraction: 0.85), value: isPresented)
                }
            }
    }
}

extension View {
    func clusterConfirmation(
        isPresented: Binding<Bool>,
        title: String,
        message: String,
        confirmLabel: String = "Delete",
        cancelLabel: String = "Cancel",
        isDestructive: Bool = true,
        onConfirm: @escaping () -> Void
    ) -> some View {
        modifier(
            ClusterConfirmationModifier(
                isPresented: isPresented,
                title: title,
                message: message,
                confirmLabel: confirmLabel,
                cancelLabel: cancelLabel,
                isDestructive: isDestructive,
                onConfirm: onConfirm
            )
        )
    }
}
