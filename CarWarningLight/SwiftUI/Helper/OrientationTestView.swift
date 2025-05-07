//
//  OrientationTestView.swift
//  CarWarningLight
//
//  Created by Sam Greenhill on 4/30/25.
//  Copyright © 2025 simplyAmazingMachines. All rights reserved.
//

import SwiftUI
import UIKit

/**
 * A helper view controller representable that locks the orientation
 * of the app to the specified orientation mask.
 */
struct OrientationLocker: UIViewControllerRepresentable {
    // MARK: - Properties
    let orientation: UIInterfaceOrientationMask

    // MARK: - UIViewControllerRepresentable
    func makeUIViewController(context: Context) -> UIViewController {
        let viewController = UIViewController()
        viewController.lockOrientation(orientation)
        return viewController
    }

    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
        uiViewController.lockOrientation(orientation)
    }
}

/**
 * Extension to add orientation locking functionality to UIViewController
 */
extension UIViewController {
    /// Lock the device orientation to the specified mask
    func lockOrientation(_ orientation: UIInterfaceOrientationMask) {
        if UIApplication.shared.delegate is AppDelegate {
            AppDelegate.orientationLock = orientation
        }

        if #available(iOS 16.0, *) {
            self.setNeedsUpdateOfSupportedInterfaceOrientations()
        }
    }
}
