//
//  TestView.swift
//  CarWarningLight
//
//  Created by Sam Greenhill on 5/1/25.
//  Copyright © 2025 simplyAmazingMachines. All rights reserved.
//

import SwiftUI

struct TestView: View {
    enum Tab: String {
            case one
            case two
            case three
        }

        @State private var selected: Tab = .one
        @Namespace private var tabNameSpace

        var body: some View {
            ZStack {
                HStack(spacing: 32) {

                    ZStack {
                        if selected == .one {
                            Color.red
                                .frame(width: 100, height: 50)
                                .matchedGeometryEffect(id: "namespace", in: tabNameSpace)
                        }

                        Text(Tab.one.rawValue)
                            .frame(width: 100, height: 50)
                            .onTapGesture {
                                withAnimation(.spring()) {
                                    selected = .one
                                }
                            }
                    }

                    ZStack {
                        if selected == .two {
                            Color.red
                                .frame(width: 100, height: 50)
                                .matchedGeometryEffect(id: "namespace", in: tabNameSpace)
                        }

                        Text(Tab.two.rawValue)
                            .frame(width: 100, height: 50)
                            .onTapGesture {
                                withAnimation(.spring()) {
                                    selected = .two
                                }
                            }
                    }

                    ZStack {
                        if selected == .three {
                            Color.red
                                .frame(width: 100, height: 50)
                                .matchedGeometryEffect(id: "namespace", in: tabNameSpace)
                        }

                        Text(Tab.three.rawValue)
                            .frame(width: 100, height: 50)
                            .onTapGesture {
                                withAnimation(.spring()) {
                                    selected = .three
                                }
                            }
                    }

                }
            }
        }
}

#Preview {
    TestView()
        .environmentObject(UIStateManager())
}
