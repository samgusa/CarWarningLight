//
//  ClusterLightTagPicker.swift
//  CarWarningLight
//
//  Created by Sam Greenhill on 9/8/26.
//  Copyright © 2026 simplyAmazingMachines. All rights reserved.
//

import SwiftUI

struct ClusterLightTagPicker: View {
    @Environment(\.allLights) private var allLights
    @Binding var selectedIDs: Set<Int>
    @Environment(\.dismiss) private var dismiss
    @State private var searchText: String = ""

    private var filtered: [CarSymbol] {
        guard !searchText.isEmpty else { return allLights }
        return allLights.filter { $0.name.localizedCaseInsensitiveContains(searchText) }
    }

    var body: some View {
        VStack(spacing: 0) {
            ClusterHeaderBar(title: "Related Lights") { dismiss() }

            TextField("Search lights", text: $searchText)
                .font(ClusterTheme.Types.body(14))
                .foregroundStyle(ClusterTheme.Colors.textPrimary)
                .padding(12)
                .background(ClusterTheme.Colors.panel)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(ClusterTheme.Colors.bezel, lineWidth: 1)
                )
                .clipShape(RoundedRectangle(cornerRadius: 10))
                .padding(.horizontal)
                .padding(.top, 12)

            ScrollView {
                LazyVStack(spacing: 8) {
                    ForEach(filtered) { light in row(for: light) }
                }
                .padding(.horizontal)
                .padding(.vertical, 12)
            }
        }
        .background(ClusterTheme.Colors.background)
    }

    private func row(for light: CarSymbol) -> some View {
        let isOn = selectedIDs.contains(light.id)
        return Button {
            if isOn { selectedIDs.remove(light.id) } else { selectedIDs.insert(light.id) }
        } label : {
            HStack(spacing: 12) {
                Image(light.imageName)
                    .resizable()
                    .renderingMode(.template)
                    .scaledToFit()
                    .frame(width: 20, height: 20)
                    .foregroundStyle(ClusterTheme.Colors.forSymbolType(light.symbolType))
                    .frame(width: 36, height: 36)
                    .background(ClusterTheme.Colors.panel)
                    .clipShape(RoundedRectangle(cornerRadius: 8))

                Text(light.name)
                    .font(ClusterTheme.Types.body(14, weight: .semibold))
                    .foregroundStyle(ClusterTheme.Colors.textPrimary)

                Spacer()

                Image(systemName: isOn ? "checkmark.square.fill" : "square")
                    .font(.system(size: 18))
                    .foregroundStyle(isOn ? ClusterTheme.Colors.amber : ClusterTheme.Colors.textSecondary)
            }
            .padding(12)
            .clusterPanel()
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    ClusterLightTagPicker(selectedIDs: .constant([]))
}
