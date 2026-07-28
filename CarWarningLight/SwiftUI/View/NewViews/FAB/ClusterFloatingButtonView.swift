//
//  ClusterFloatingButtonView.swift
//  CarWarningLight
//
//  Created by Sam Greenhill on 7/26/26.
//  Copyright © 2026 simplyAmazingMachines. All rights reserved.
//

import SwiftUI

struct ClusterFloatingButtonView<Label: View>: View {
    var buttonSize: CGFloat
    var actions: [FloatingAction]
    var label: (Bool) -> Label

    init(buttonSize: CGFloat = 54, @FloatingActionBuilder actions: @escaping () -> [FloatingAction], label: @escaping (Bool) -> Label) {
        self.buttonSize = buttonSize
        self.actions = actions()
        self.label = label
    }

    @State private var isExpanded: Bool = false
    @State private var dragLocation: CGPoint = .zero
    @GestureState private var isDragging: Bool = false
    @State private var selectedAction: FloatingAction?


    var body: some View {
        Button {
            isExpanded.toggle()
        } label: {
            label(isExpanded)
                .frame(width: buttonSize, height: buttonSize)
                .contentShape(.rect)
        }
        .buttonStyle(NoAnimationButtonStyle())
        .simultaneousGesture(
            LongPressGesture(minimumDuration: 0.3)
                .onEnded { _ in
                    isExpanded = true
                }.sequenced(before: DragGesture().updating($isDragging, body: { _, out, _ in
                    out = true
                }).onChanged { value in
                    guard isExpanded else { return }
                    dragLocation = value.location
                }.onEnded { _ in
                    Task {
                        if let selectedAction {
                            isExpanded = false
                            selectedAction.action()
                        }
                        selectedAction = nil
                        dragLocation = .zero
                    }
                })
        )
        .background {
            ZStack {
                ForEach(actions) { action in
                    ActionView(action)
                }
            }
            .frame(width: buttonSize, height: buttonSize)
        }
        .coordinateSpace(.named("CLUSTER FAB"))
        .animation(.snappy(duration: 0.4, extraBounce: 0), value: isExpanded)
    }

    @ViewBuilder
    func ActionView(_ action: FloatingAction) -> some View {
        Button {
            action.action()
            isExpanded = false
        } label : {
            ZStack{
                Circle()
                    .fill(action.background)
                    .frame(width: buttonSize * 0.6, height: buttonSize * 0.6)
                    .blur(radius: 12)
                    .opacity(selectedAction?.id == action.id ? 0.85 : 0.5)

                Image(systemName: action.symbol)
                    .font(action.font)
                    .foregroundStyle(ClusterTheme.Colors.textPrimary)
            }
            .frame(width: buttonSize, height: buttonSize)
            .background(ClusterTheme.Colors.panel)
            .overlay(Circle().stroke(action.background.opacity(0.6), lineWidth: 1))
            .clipShape(Circle())
            .contentShape(.circle)
        }
        .buttonStyle(PressedButtonStyle())
        .disabled(!isExpanded)
        .animation(.snappy(duration: 0.3, extraBounce: 0)) { content in
            content
                .scaleEffect(selectedAction?.id == action.id ? 1.15 : 1)
        }
        .background {
            GeometryReader {
                let rect = $0.frame(in: .named("CLUSTER FAB"))

                Color.clear
                    .onChange(of: dragLocation) { oldValue, newValue in
                        if isExpanded && isDragging {
                            if rect.contains(newValue) {
                                selectedAction = action
                            } else if selectedAction?.id == action.id && !rect.contains(newValue) {
                                selectedAction = nil
                            }
                        }
                    }
            }
        }
        .rotationEffect(.init(degrees: progress(action) * -90))
        .offset(x: isExpanded ? -offset / 2 : 0)
        .rotationEffect(.init(degrees: progress(action) * 90))
    }

    private var offset: CGFloat {
        let buttonSize = buttonSize + 10
        return Double(actions.count) * (actions.count == 1 ? buttonSize * 2 : (actions.count == 2 ? buttonSize * 1.25 : buttonSize))
    }

    private func progress(_ action: FloatingAction) -> CGFloat {
        let index = CGFloat(actions.firstIndex(where: { $0.id == action.id }) ?? 0)
        return actions.count == 1 ? 1 : (index / CGFloat(actions.count - 1))
    }
}

#Preview {
    struct PreviewHost: View {
        @State var expanded = false
        var body: some View {
            ZStack(alignment: .bottomTrailing) {
                ClusterTheme.Colors.background.ignoresSafeArea()

                ClusterFloatingButtonView {
                    FloatingAction(symbol: "photo.fill", background: ClusterTheme.Colors.green) { }
                    FloatingAction(symbol: "camera.fill", background: ClusterTheme.Colors.amber) { }
                } label: { isExpanded in
                    ClusterFABLabel(isExpanded: isExpanded)
                }
                .padding(24)
            }
        }
    }
    return PreviewHost()
}
