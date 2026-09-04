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

    private static var reportsDirectory: URL {
        let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
            .appendingPathComponent("Reports", isDirectory: true)
        try? FileManager.default.createDirectory(at: dir, withIntermediateDirectories: true)
        return dir
    }

    @MainActor
    static func generate(from document: ReportDocumentView, vehicleName: String) -> URL? {
        let renderer = ImageRenderer(content: document)
        renderer.scale = 3

        guard let fullImage = renderer.uiImage, fullImage.size.height > 0 else { return nil }

        let pdfRenderer = UIGraphicsPDFRenderer(bounds: CGRect(x: 0, y: 0, width: pageWidth, height: pageHeight))

        let safeName = vehicleName
            .trimmingCharacters(in: .whitespacesAndNewlines)
            .components(separatedBy: CharacterSet.alphanumerics.inverted)
            .joined()
        let filename = "\(safeName.isEmpty ? "Vehicle" : safeName)-Report-\(shortDateStamp()).pdf"
        let url = reportsDirectory.appendingPathComponent(filename)

        do {
            try pdfRenderer.writePDF(to: url) { context in
                var yOffset: CGFloat = 0
                while yOffset < fullImage.size.height {
                    context.beginPage()
                    fullImage.draw(at: CGPoint(x: 0, y: -yOffset))
                    yOffset += pageHeight
                }
            }
            return url
        } catch {
            print("Report PDF generation failed: \(error)")
            return nil
        }
    }

    private static func shortDateStamp() -> String {
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
