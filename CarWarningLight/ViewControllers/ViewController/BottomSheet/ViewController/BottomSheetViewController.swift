//
//  BottomSheetViewController.swift
//  CarWarningLight
//
//  Created by Sam Greenhill on 9/17/23.
//  Copyright © 2023 simplyAmazingMachines. All rights reserved.
//

import Foundation
import UIKit
import Combine


class BottomSheetViewController: UIViewController {

    var rootView = BottomMainView()
    var viewModel = BottomSheetViewModel()

    var cancellables = Set<AnyCancellable>()

    override func loadView() {
        self.view = rootView
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.handleCloseAction))
        self.rootView.dimmedView.addGestureRecognizer(tapGesture)
        addCombine()
        setupPanGesture()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        animateShowDimmedView()
        animatePresentContainer()
    }

    
}
