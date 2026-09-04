//
//  ClusterPhotoAttachmentButton.swift
//  CarWarningLight
//
//  Created by Sam Greenhill on 9/2/26.
//  Copyright © 2026 simplyAmazingMachines. All rights reserved.
//

import SwiftUI

struct ClusterPhotoAttachmentButton: View {
    var image: UIImage?
    var onCapture:  () -> Void
    var onRemove:   () -> Void

    var body: some View {
        Group {
            if let image {
                Button(action: onCapture) {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFill()
                        .frame(width: 44, height: 44)
                        .clipShape(ClusterCornerCutShape(cut: 8))
                        .overlay(
                            ClusterCornerCutShape(cut: 8)
                                .stroke(ClusterTheme.Colors.amber, lineWidth: 1.5)
                        )
                }
                .buttonStyle(.plain)
                .overlay(alignment: .topTrailing) {
                    Button(action: onRemove) {
                        Image(systemName: "xmark")
                            .font(.system(size: 8, weight: .bold))
                            .foregroundStyle(ClusterTheme.Colors.background)
                            .padding(4)
                            .background(ClusterTheme.Colors.amber)
                            .clipShape(Circle())
                    }
                    .offset(x: 6, y: -6)
                    .accessibilityLabel("Remove photo")
                }
            } else {
                Button(action: onCapture) {
                    Image(systemName: "camera.fill")
                        .font(.system(size: 15, weight: .bold))
                        .foregroundStyle(ClusterTheme.Colors.amber)
                        .frame(width: 44, height: 44)
                        .background(ClusterTheme.Colors.panel)
                        .clipShape(ClusterCornerCutShape(cut: 8))
                        .overlay(
                            ClusterCornerCutShape(cut: 8)
                                .stroke(style: StrokeStyle(lineWidth: 1.5, dash: [4, 4]))
                                .foregroundStyle(ClusterTheme.Colors.amber.opacity(0.6))
                        )
                }
                .buttonStyle(PressedButtonStyle())
                .accessibilityLabel("Attach photo")
            }
        }
    }
}

#Preview {
    HStack(spacing: 16) {
        ClusterPhotoAttachmentButton(image: nil, onCapture: {}, onRemove: {})
    }
}
