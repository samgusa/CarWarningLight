//
//  AccessoryView.swift
//  CarWarningLight
//
//  Created by Sam Greenhill on 7/28/26.
//  Copyright © 2026 simplyAmazingMachines. All rights reserved.
//

import SwiftUI

struct AccessoryView: View {
    var onPlacementChanged: (_ oldView: TabViewBottomAccessoryPlacement?, _ newValue: TabViewBottomAccessoryPlacement?) -> Void
    @Environment(\.tabViewBottomAccessoryPlacement) private var placement

    var body: some View {
        Color.clear
            .frame(height: 0)
            .onChange(of: placement) { oldValue, newValue in
                onPlacementChanged(oldValue, newValue)
            }
    }
}


extension View {
    @ViewBuilder
    func tabOverlay<Content: View>(
        isPresented: Bool,
        @ViewBuilder content: @escaping () -> Content,
        onDismiss: @escaping () -> Void
    ) -> some View {
        self.modifier(TabOverlayModifier(isPresented: isPresented, viewContent: content, onDismiss: onDismiss))
    }
}
