//
//  ReportPDFGenerator.swift
//  CarWarningLight
//
//  Created by Sam Greenhill on 8/23/26.
//  Copyright © 2026 simplyAmazingMachines. All rights reserved.
//

import SwiftUI
import UIKit

enum ReportPDFGenerator {
    private static let pageWidth: CGFloat = 612
    private static let pageHeight: CGFloat = 792 // US Letter, 72pt/inch
    private static let margin: CGFloat = 32
    private static let renderScale: CGFloat = 3

    private static let maxKeptReports = 20

    private static var reportsDirectory: URL {
        let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
            .appendingPathComponent("Reports", isDirectory: true)
        try? FileManager.default.createDirectory(at: dir, withIntermediateDirectories: true)
        return dir
    }

    @MainActor
    static func generate(
        vehicle: Vehicle,
        lights: [LightLogEntry],
        issueEntries: [ReportIssueEntry],
        maintenanceItems: [MaintenanceItem],
        allLights: [CarSymbol],
        ownerName: String,
        ownerContact: String
    ) async -> URL? {
        let blocks = ReportBlock.build(
            vehicle: vehicle,
            lights: lights,
            issueEntries: issueEntries,
            maintenanceItems: maintenanceItems,
            allLights: allLights,
            ownerName: ownerName,
            ownerContact: ownerContact
        )

        let contentWidth = pageWidth - margin * 2
        var images: [UIImage] = []
        images.reserveCapacity(blocks.count)

        for block in blocks {
            let renderer = ImageRenderer(
                content: block.view.frame(
                    width: contentWidth,
                    alignment: .topLeading
                )
            )
            renderer.scale = renderScale
            if let image = renderer.uiImage {
                images.append(image)
            }
        }

        let vehicleName = vehicle.name
        return await Task.detached(priority: .userInitiated) {
            writePDF(images: images, vehicleName: vehicleName)
        }.value
    }

    nonisolated private static func writePDF(images: [UIImage], vehicleName: String) -> URL? {
        pruneOldReports()

        let renderer = UIGraphicsPDFRenderer(bounds: CGRect(x: 0, y: 0, width: pageWidth, height: pageHeight))

        let url = reportsDirectory.appendingPathComponent(uniqueFilename(for: vehicleName))

        do {
            try renderer.writePDF(to: url) { context in
                var y: CGFloat = margin
                context.beginPage()

                for image in images {
                    let heightInPoints = image.size.height
                    let widthInPoints = image.size.width

                    if y > margin, y + heightInPoints > pageHeight - margin {
                        context.beginPage()
                        y = margin
                    }

                    image.draw(in: CGRect(x: margin, y: y, width: widthInPoints, height: heightInPoints))
                    y += heightInPoints
                }
            }
            return url
        } catch {
            print("Report PDF generation failed: \(error)")
            return nil
        }
    }

    nonisolated private static func uniqueFilename(for vehicleName: String) -> String {
        let safeName = vehicleName
            .trimmingCharacters(in: .whitespacesAndNewlines)
            .components(separatedBy: CharacterSet.alphanumerics.inverted)
            .joined()
        let uniqueSuffix = UUID().uuidString.prefix(6)
        return "\(safeName.isEmpty ? "Vehicle" : safeName)-Report-\(shortDateStamp())-\(uniqueSuffix).pdf"
    }

    nonisolated private static func pruneOldReports() {
        let fm = FileManager.default
        guard let files = try? fm.contentsOfDirectory(
            at: reportsDirectory,
            includingPropertiesForKeys: [.contentModificationDateKey]
        ) else { return }

        let sortedNewestFirst = files.sorted { lhs, rhs in
            let lhsDate = (try? lhs.resourceValues(
                forKeys: [.contentModificationDateKey]))?.contentModificationDate ?? .distantPast

            let rhsDate = (try? rhs.resourceValues(
                forKeys: [.contentModificationDateKey]))?.contentModificationDate ?? .distantPast

            return lhsDate > rhsDate
        }

        for stale in sortedNewestFirst.dropFirst(maxKeptReports) {
            try? fm.removeItem(at: stale)
        }
    }

    nonisolated private static func shortDateStamp() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd-HHmm"
        return formatter.string(from: Date())
    }
}

struct ShareSheet: UIViewControllerRepresentable {
    let activityItems: [Any]

    func makeUIViewController(context: Context) -> UIActivityViewController {
        UIActivityViewController(activityItems: activityItems, applicationActivities: nil)
    }

    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) { }
}
