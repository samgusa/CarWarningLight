//
//  TabOverlayModifier.swift
//  CarWarningLight
//
//  Created by Sam Greenhill on 7/28/26.
//  Copyright © 2026 simplyAmazingMachines. All rights reserved.
//

import SwiftUI

struct TabOverlayModifier<ViewContent: View>: ViewModifier {

    var isPresented: Bool
    @ViewBuilder var viewContent: ViewContent
    var onDismiss: () -> Void

    @State private var isViewAppearing: Bool = false

    func body(content: Content) -> some View {
        content
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .overlay {
                if isViewAppearing {
                    GlassEffectContainer {
                        if isPresented {
                            Rectangle()
                                .fill(.black.opacity(0.25))
                                .contentShape(.rect)
                                .onTapGesture { onDismiss() }
                                .ignoresSafeArea()
                                .transition(.opacity)
                        }
                        if isPresented {
                            viewContent
                                .clipShape(.rect(cornerRadius: 30))
                                .glassEffect(.regular.interactive(), in: .rect(cornerRadius: 30))
                                .frame(maxHeight: .infinity, alignment: .bottom)
                                .padding(.horizontal, 15)
                                .padding(.bottom, 10)
                        }
                    }
                    .allowsHitTesting(isPresented)
                    .animation(.interpolatingSpring(duration: 0.3, bounce: 0, initialVelocity: 0), value: isPresented)
                }
            }
            .onAppear { isViewAppearing = true }
            .onDisappear { isViewAppearing = false }
    }
}

struct TabBarExtractor: UIViewRepresentable {
    var result: (UITabBar) -> Void

    func makeUIView(context: Context) -> UIView {
        let view = UIView()
        view.backgroundColor = .clear
        DispatchQueue.main.async {
            if let tbc = view.superview?.superview?.subviews.last?.subviews.first?.next as? UITabBarController {
                result(tbc.tabBar)
            }
        }
        return view
    }

    func updateUIView(_ uiView: UIView, context: Context) { }
}

extension UIView {
    func subviews<T: UIView>(type: T.Type) -> [T] {
        subviews.compactMap { $0 as? T } + subviews.flatMap { $0.subviews(type: type) }
    }
}
