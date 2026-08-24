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

    @MainActor
    static func generate(from document: ReportDocumentView) -> URL? {
        let renderer = ImageRenderer(content: document)
        renderer.scale = 3

        guard let fullImage = renderer.uiImage, fullImage.size.height > 0 else { return nil }

        let pdfRenderer = UIGraphicsPDFRenderer(bounds: CGRect(x: 0, y: 0, width: pageWidth, height: pageHeight))
        let url = FileManager.default.temporaryDirectory
            .appendingPathComponent("VehicleReport-\(UUID().uuidString).pdf")

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
}

struct ShareSheet: UIViewControllerRepresentable {
    let activityItems: [Any]

    func makeUIViewController(context: Context) -> UIActivityViewController {
        UIActivityViewController(activityItems: activityItems, applicationActivities: nil)
    }

    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) { }
}
