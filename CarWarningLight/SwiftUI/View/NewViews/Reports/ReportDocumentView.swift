//
//  ReportDocumentView.swift
//  CarWarningLight
//
//  Created by Sam Greenhill on 8/23/26.
//  Copyright © 2026 simplyAmazingMachines. All rights reserved.
//

import SwiftUI

struct ReportDocumentView: View {
    let vehicle: Vehicle
    let lights: [LightLogEntry]
    let issueEntries: [ReportIssueEntry]
    let generatedDate: Date = Date()

    private let pageWidth: CGFloat = 612 // US Letter, 72pt/inch

    var body: some View {
        VStack(alignment: .leading, spacing: 22) {
            header

            if !lights.isEmpty          { lightsSection }
            if !issueEntries.isEmpty    { issuesSection }

            Spacer(minLength: 0)
            footer
        }
        .padding(32)
        .frame(width: pageWidth, alignment: .topLeading)
        .background(Color.white)
        .foregroundStyle(Color.black)
    }

    private var header: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text("VEHICLE REPORT")
                .font(.system(size: 11, weight: .bold, design: .monospaced))
                .tracking(2)
                .foregroundStyle(.gray)
            Text(vehicle.name)
                .font(.system(size: 26, weight: .heavy, design: .monospaced))
            Text("Generated \(generatedDate.formatted(date: .abbreviated, time: .shortened))")
                .font(.system(size: 11, weight: .medium))
                .foregroundStyle(.gray)

            Rectangle()
                .fill(Color.black)
                .frame(height: 2)
                .padding(.top, 6)
        }
    }

    private var lightsSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            sectionLabel("Warning Lights", count: lights.count)

            ForEach(lights) { entry in
                VStack(alignment: .leading, spacing: 3) {
                    HStack {
                        Circle()
                            .fill(severityColor(entry.carSymbol.symbolType))
                            .frame(width: 8, height: 8)
                        Text(entry.carSymbol.name)
                            .font(.system(size: 14, weight: .bold))
                        Spacer()
                        Text(entry.carSymbol.symbolType.title.uppercased())
                            .font(.system(size: 9, weight: .bold, design: .monospaced))
                            .foregroundStyle(.gray)
                    }
                    Text(entry.carSymbol.drivable.message)
                        .font(.system(size: 11))
                        .foregroundStyle(.gray)
                    Text("Logged \(entry.dateLogged.formatted(date: .abbreviated, time: .omitted))")
                        .font(.system(size: 10, design: .monospaced))
                        .foregroundStyle(.gray.opacity(0.8))
                }
                .padding(.vertical, 8)
                .overlay(alignment: .bottom) {
                    Rectangle()
                        .fill(Color.gray.opacity(0.25))
                        .frame(height: 0.75)
                }
            }
        }
    }

    private var issuesSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            sectionLabel("Issues", count: issueEntries.count)

            ForEach(Array(issueEntries.enumerated()), id: \.offset) { _, entry in
                VStack(alignment: .leading, spacing: 5) {
                    HStack {
                        Text(entry.categories.map(\.label).joined(separator: " + "))
                            .font(.system(size: 14, weight: .bold))
                        Spacer()
                        Text(entry.issue.dateCreated.formatted(date: .abbreviated, time: .omitted))
                            .font(.system(size: 10, design: .monospaced))
                            .foregroundStyle(.gray)
                    }
                    if !entry.issue.noteText.isEmpty {
                        Text(entry.issue.noteText)
                            .font(.system(size: 11))
                            .foregroundStyle(.black.opacity(0.8))
                    }
                    if !entry.issue.markedZones.isEmpty {
                        IssueDiagramSnapshot(vehicle: vehicle, markedZones: entry.issue.markedZones)
                    }
                }
                .padding(.vertical, 8)
                .overlay(alignment: .bottom) {
                    Rectangle()
                        .fill(Color.gray.opacity(0.25))
                        .frame(height: 0.75)
                }
            }
        }
    }

    private func sectionLabel(_ title: String, count: Int) -> some View {
        Text("\(title.uppercased()) (\(count))")
            .font(.system(size: 11, weight: .bold, design: .monospaced))
            .tracking(1.2)
            .foregroundStyle(.gray)
            .padding(.top, 4)
    }

    private func severityColor(_ type: SymbolType) -> Color {
        switch type {
        case .warning:      return .red
        case .advisory:     return .orange
        case .info:         return .green
        }
    }

    private var footer: some View {
        Text("Generated by Warning Light Camera")
            .font(.system(size: 9))
            .foregroundStyle(.gray.opacity(0.6))
            .padding(.top, 12)
    }
}

private struct IssueDiagramSnapshot: View {
    let vehicle: Vehicle
    let markedZones: Set<String>

    private var kindsWithMarks: [VehicleDiagramKind] {
        VehicleDiagramKind.allCases.filter { kind in
            markedZones.contains { $0.hasPrefix("\(kind.rawValue):")}
        }
    }

    private func imageName(for kind: VehicleDiagramKind) -> String {
        switch kind {
        case .topDown:                  return vehicle.imageName
        case .leftSide, .rightSide:     return vehicle.imageName.replacingOccurrences(of: "vehicle", with: "side")
        }
    }

    var body: some View {
        HStack(alignment: .top, spacing: 16) {
            ForEach(kindsWithMarks) { kind in
                VStack(spacing: 4) {
                    VehicleDiagramView(
                        imageName: imageName(for: kind),
                        kind: kind,
                        selectedZones: .constant(markedZones),
                        tint: .black.opacity(0.7),
                        isInteractive: false
                    )
                    .frame(width: 130, height: kind == .topDown ? 120 : 70)

                    Text(kind.title.uppercased())
                        .font(.system(size: 8, weight: .bold, design: .monospaced))
                        .foregroundStyle(.gray)
                }
            }
        }
        .padding(.top, 4)
    }
}

#Preview {
    ReportDocumentView(vehicle: Vehicle(name: "My Civic"), lights: [], issueEntries: [])
}
