//
//  ReportDocumentView.swift
//  CarWarningLight
//
//  Created by Sam Greenhill on 8/23/26.
//  Copyright © 2026 simplyAmazingMachines. All rights reserved.
//

import SwiftUI

enum ReportBlock: Identifiable {
    case header(vehicle: Vehicle, ownerName: String, ownerContact: String, generatedDate: Date)
    case disclaimer
    case sectionLabel(title: String, count: Int)
    case light(LightLogEntry, index: Int)
    case issue(ReportIssueEntry, index: Int, allLights: [CarSymbol], vehicle: Vehicle)
    case maintenanceItem(MaintenanceItem, index: Int)
    case footer

    var id: String {
        switch self {
        case .header:                       return "header"
        case .disclaimer:                   return "disclaimer"
        case .sectionLabel(let title, _):   return "section-\(title)"
        case .light(let entry, _):          return "light-\(entry.id)"
        case .issue(let entry, _, _, _):    return "issue-\(entry.issue.id)"
        case .maintenanceItem(let item, _): return "maintenance-\(item.id)"
        case .footer:                       return "footer"
        }
    }

    @ViewBuilder
    var view: some View {
        switch self {
        case .header(let vehicle, let ownerName, let ownerContact, let generatedDate):
            ReportHeaderBlock(vehicle: vehicle, ownerName: ownerName, ownerContact: ownerContact, generatedDate: generatedDate)
        case .disclaimer:
            ReportDisclaimerBlock()
        case .sectionLabel(let title, let count):
            ReportSectionLabelBlock(title: title, count: count)
        case .light(let entry, let index):
            ReportLightBlock(entry: entry, index: index)
        case .issue(let entry, let index, let allLights, let vehicle):
            ReportIssueBlock(entry: entry, index: index, allLights: allLights, vehicle: vehicle)
        case .maintenanceItem(let item, let index):
            ReportMaintenanceBlock(item: item, index: index)
        case .footer:
            ReportFooterBlock()
        }
    }

    static func build(
            vehicle:            Vehicle,
            lights:             [LightLogEntry],
            issueEntries:       [ReportIssueEntry],
            maintenanceItems:   [MaintenanceItem],
            allLights:          [CarSymbol],
            ownerName:          String,
            ownerContact:       String
    ) -> [ReportBlock] {
        var blocks: [ReportBlock] = [
            .header(vehicle: vehicle, ownerName: ownerName, ownerContact: ownerContact, generatedDate: Date())
        ]

        if !lights.isEmpty {
            blocks.append(.sectionLabel(title: "Warning Lights", count: lights.count))
            blocks.append(contentsOf: lights.enumerated().map { ReportBlock.light($1, index: $0 + 1) })
            blocks.append(.disclaimer)
        }

        if !issueEntries.isEmpty {
            blocks.append(.sectionLabel(title: "Issues", count: issueEntries.count))
            blocks.append(contentsOf: issueEntries.enumerated().map {
                ReportBlock.issue($1, index: $0 + 1, allLights: allLights, vehicle: vehicle)
            })
        }

        if !maintenanceItems.isEmpty {
            blocks.append(.sectionLabel(title: "Maintenance", count: maintenanceItems.count))
            blocks.append(contentsOf: maintenanceItems.enumerated().map { ReportBlock.maintenanceItem($1, index: $0 + 1) })
        }

        blocks.append(.footer)
        return blocks
    }
}

private func reportSeverityColor(_ type: SymbolType) -> Color {
    switch type {
    case .advisory:     return .orange
    case .info:         return .green
    case .warning:      return .red
    }
}

private struct ReportNumberBadge: View {
    let number: Int

    var body: some View {
        Text("\(number)")
            .font(.system(size: 10, weight: .bold, design: .monospaced))
            .foregroundStyle(.white)
            .frame(width: 18, height: 18)
            .background(
                Circle()
                    .fill(Color.black)
            )
    }
}

// MARK: Header

private struct ReportHeaderBlock: View {
    let vehicle: Vehicle
    let ownerName: String
    let ownerContact: String
    let generatedDate: Date

    private var vehicleSubtitle: String {
        [vehicle.year, vehicle.make, vehicle.model].filter { !$0.isEmpty }.joined(separator: " ")
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text("VEHICLE REPORT")
                .font(.system(size: 11, weight: .bold, design: .monospaced))
                .tracking(2)
                .foregroundStyle(.gray)
            Text(vehicle.name)
                .font(.system(size: 26, weight: .heavy, design: .monospaced))
            if !vehicleSubtitle.isEmpty {
                Text(vehicleSubtitle)
                    .font(.system(size: 12, weight: .semibold))
                    .foregroundStyle(.gray)
            }
            if !ownerName.isEmpty {
                Text("\(ownerName)\(ownerContact.isEmpty ? "" : " · \(ownerContact)")")
                    .font(.system(size: 11, weight: .semibold))
                    .foregroundStyle(.gray)
            }

            if !vehicle.vin.isEmpty {
                Text("VIN: \(vehicle.vin)")
                    .font(.system(size: 10, design: .monospaced))
                    .foregroundStyle(.gray.opacity(0.8))
            }
            Text("Generated \(generatedDate.formatted(date: .abbreviated, time: .shortened))")
                .font(.system(size: 11, weight: .medium))
                .foregroundStyle(.gray)

            Rectangle()
                .fill(Color.black)
                .frame(height: 2)
                .padding(.top, 6)
        }
        .foregroundStyle(Color.black)
    }
}

// MARK: Disclaimer

private struct ReportDisclaimerBlock: View {

    var body: some View {
        Text("Exact meaning can vary by vehicle make and model — always confirm against your owner's manual where possible.")
            .font(.system(size: 9))
            .foregroundStyle(.gray.opacity(0.7))
            .padding(.top, 2)
            .padding(.bottom, 6)
    }
}

// MARK: Section Label

private struct ReportSectionLabelBlock: View {
    let title: String
    let count: Int

    var body: some View {
        Text("\(title.uppercased()) (\(count))")
            .font(.system(size: 11, weight: .bold, design: .monospaced))
            .tracking(1.2)
            .foregroundStyle(.gray)
            .padding(.top, 4)
            .padding(.bottom, 2)
    }
}

// MARK: Light row

private struct ReportLightBlock: View {
    let entry: LightLogEntry
    let index: Int

    var body: some View {
        VStack(alignment: .leading, spacing: 3) {
            HStack {
                ReportNumberBadge(number: index)
                Image(entry.carSymbol.imageName)
                    .resizable()
                    .renderingMode(.template)
                    .scaledToFit()
                    .frame(width: 16, height: 16)
                    .foregroundStyle(reportSeverityColor(entry.carSymbol.symbolType))
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
            Text(entry.carSymbol.description)
                .font(.system(size: 11))
                .foregroundStyle(.gray)
            Text("How to fix: \(entry.carSymbol.fixDescription)")
                .font(.system(size: 11))
                .foregroundStyle(.gray)
            Text("Logged \(entry.dateLogged.formatted(date: .abbreviated, time: .omitted))")
                .font(.system(size: 10, design: .monospaced))
                .foregroundStyle(.gray.opacity(0.8))
        }
        .foregroundStyle(Color.black)
        .padding(.vertical, 8)
        .overlay(alignment: .bottom) {
            Rectangle()
                .fill(Color.gray.opacity(0.25))
                .frame(height: 0.75)
        }
    }
}

// MARK: - Issue Block

private struct ReportIssueBlock: View {
    let entry: ReportIssueEntry
    let index: Int
    let allLights: [CarSymbol]
    let vehicle: Vehicle

    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            HStack {
                ReportNumberBadge(number: index)
                Text(entry.categories.isEmpty ?
                     entry.issue.displayTitle(allLights: allLights) :
                        entry.categories.map(\.label).joined(separator: " + ")
                )
                    .font(.system(size: 14, weight: .bold))
                Spacer()
                Text(entry.issue.dateCreated.formatted(date: .abbreviated, time: .omitted))
                    .font(.system(size: 10, design: .monospaced))
                    .foregroundStyle(.gray)
            }
            if let mileage = entry.issue.mileage {
                HStack(spacing: 5) {
                    Image(systemName: "gauge.with.dots.needle.67percent")
                        .font(.system(size: 10, weight: .semibold))

                    Text("\(mileage.formatted()) \(entry.issue.mileageUnit.abbreviation)")
                        .font(.system(size: 11, weight: .semibold))
                }
                .foregroundStyle(.black.opacity(0.7))
            }

            if !entry.issue.noteText.isEmpty {
                Text(entry.issue.noteText)
                    .font(.system(size: 11))
                    .foregroundStyle(.black.opacity(0.8))
            }

            if !entry.issue.linkedLightSymbolIDs.isEmpty {
                let linked = allLights.filter { entry.issue.linkedLightSymbolIDs.contains($0.id) }
                VStack(alignment: .leading, spacing: 3) {
                    Text("RELATED LIGHTS")
                        .font(.system(size: 9, weight: .bold, design: .monospaced))
                        .tracking(1.0)
                        .foregroundStyle(.gray)
                    ForEach(linked) { light in
                        HStack(spacing: 6) {
                            Image(light.imageName)
                                .resizable()
                                .renderingMode(.template)
                                .scaledToFit()
                                .frame(width: 12, height: 12)
                                .foregroundStyle(reportSeverityColor(light.symbolType))
                            Text(light.name)
                                .font(.system(size: 11, weight: .semibold))
                        }
                    }
                }
                .padding(.top, 2)
            }

            if !entry.issue.markedZones.isEmpty {
                IssueDiagramSnapshot(vehicle: vehicle, markedZones: entry.issue.markedZones)
            }
            if let photo = entry.issue.photoImage {
                Image(uiImage: photo)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(maxWidth: 460, maxHeight: 360)
                    .clipShape(RoundedRectangle(cornerRadius: 6))
                    .padding(.top, 4)
            }
        }
        .foregroundStyle(Color.black)
        .padding(.vertical, 8)
        .overlay(alignment: .bottom) {
            Rectangle()
                .fill(Color.gray.opacity(0.25))
                .frame(height: 0.75)
        }
    }
}

// MARK: Diagram snapshot

private struct IssueDiagramSnapshot: View {
    let vehicle: Vehicle
    let markedZones: Set<String>

    private var kindsWithMarks: [VehicleDiagramKind] {
        VehicleDiagramKind.allCases.filter { kind in
            markedZones.contains { $0.hasPrefix("\(kind.rawValue):")}
        }
    }

    var body: some View {
        HStack(alignment: .top, spacing: 16) {
            ForEach(kindsWithMarks) { kind in
                VStack(spacing: 4) {
                    VehicleDiagramView(
                        imageName: vehicle.imageName(for: kind),
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

// MARK: Maintenance Item

private struct ReportMaintenanceBlock: View {
    let item: MaintenanceItem
    let index: Int

    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            HStack {
                ReportNumberBadge(number: index)

                MaintenanceIconView(
                    category: item.category,
                    color: .gray,
                    size: 14,
                    lineWidth: 1.4
                )

                Text(item.title)
                    .font(.system(size: 14, weight: .bold))
                Spacer()
                Text(item.dateCreated.formatted(date: .abbreviated, time: .omitted))
                    .font(.system(size: 10, design: .monospaced))
                    .foregroundStyle(.gray)
            }

            if let mileage = item.mileage {
                HStack(spacing: 5) {
                    Image(systemName: "gauge.with.dots.needle.67percent")
                        .font(.system(size: 10, weight: .semibold))
                    Text("\(mileage.formatted()) \(item.mileageUnit.abbreviation)")
                        .font(.system(size: 11, weight: .semibold))
                }
                .foregroundStyle(.black.opacity(0.7))
            }

            if !item.noteText.isEmpty {
                Text(item.noteText)
                    .font(.system(size: 11))
                    .foregroundStyle(.black.opacity(0.8))
            }
            if let photo = item.photoImage {
                Image(uiImage: photo)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(maxWidth: 460, maxHeight: 360)
                    .clipShape(RoundedRectangle(cornerRadius: 6))
                    .padding(.top, 4)
            }
        }
        .foregroundStyle(Color.black)
        .padding(.vertical, 8)
        .overlay(alignment: .bottom) {
            Rectangle()
                .fill(Color.gray.opacity(0.25))
                .frame(height: 0.75)
        }
    }
}

// MARK: Footer

private struct ReportFooterBlock: View {
    var body: some View {
        Text("Generated by Warning Light Camera")
            .font(.system(size: 9))
            .foregroundStyle(.gray.opacity(0.6))
            .padding(.top, 12)
    }
}

#Preview {
    ScrollView {
        VStack(alignment: .leading, spacing: 0) {
            ForEach(ReportBlock.build(
                vehicle: Vehicle(name: "My Civic"),
                lights: [],
                issueEntries: [],
                maintenanceItems: [],
                allLights: [],
                ownerName: "John Doe",
                ownerContact: "john@example.com"
            )) { block in
                block.view
            }
        }
        .padding(32)
        .frame(width: 612, alignment: .topLeading)
        .background(Color.white)
    }
}
