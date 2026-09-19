//
//  QuickLookPreview.swift
//  CarWarningLight
//
//  Created by Sam Greenhill on 9/2/26.
//  Copyright © 2026 simplyAmazingMachines. All rights reserved.
//

import SwiftUI
import QuickLook

struct QuickLookPreview: UIViewControllerRepresentable {
    let url: URL
    var title: String? = nil

    func makeUIViewController(context: Context) -> UINavigationController {
        let controller = QLPreviewController()
        controller.dataSource = context.coordinator
        return UINavigationController(rootViewController: controller)
    }

    func updateUIViewController(_ uiViewController: UINavigationController, context: Context) { }

    func makeCoordinator() -> Coordinator {
        Coordinator(url: url, title: title)
    }

    final class Coordinator: NSObject, QLPreviewControllerDataSource {
        let previewItem: NamedPreviewItem
        init(url: URL, title: String?) {
            self.previewItem = NamedPreviewItem(url: url, title: title)
        }

        func numberOfPreviewItems(in controller: QLPreviewController) -> Int { 1 }

        func previewController(_ controller: QLPreviewController, previewItemAt index: Int) -> QLPreviewItem {
            previewItem
        }
    }
}

final class NamedPreviewItem: NSObject, QLPreviewItem {
    let previewItemURL: URL?
    private let customTitle: String?

    init(url: URL, title: String?) {
        self.previewItemURL     = url
        self.customTitle        = title
    }

    var previewItemTitle: String? {
        customTitle
    }
}
