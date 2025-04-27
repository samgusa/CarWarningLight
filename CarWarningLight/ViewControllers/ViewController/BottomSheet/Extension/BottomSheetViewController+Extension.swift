//
//  BottomSheetViewController+Extension.swift
//  CarWarningLight
//
//  Created by Sam Greenhill on 9/18/23.
//  Copyright © 2023 simplyAmazingMachines. All rights reserved.
//

import Foundation
import UIKit
import Combine

extension BottomSheetViewController {

    // Add combine
    func addCombine() {
        viewModel.fetchInfo()
            .sink { [weak self] info in
                guard let self = self else { return }
                self.rootView.lowView.warningTextView.nameLbl.text = viewModel.infoFilter(sections: info, info: .warning)
                self.rootView.lowView.advisoryTextView.nameLbl.text = viewModel.infoFilter(sections: info, info: .advisory)
                self.rootView.lowView.infoTextView.nameLbl.text = viewModel.infoFilter(sections: info, info: .info)
            }
            .store(in: &cancellables)

        let largeFont = UIFont.boldSystemFont(ofSize: 25)
        let configuration = UIImage.SymbolConfiguration(font: largeFont)

        self.rootView.hiddenValueSubject
            .sink { [weak self] bool in
                guard let self = self else { return }
                self.rootView.lowView.isHidden = !bool
                self.rootView.highView.isHidden = bool
                self.rootView.directionImage.image = bool ? UIImage(systemName: "arrow.up", withConfiguration: configuration) : UIImage(systemName: "arrow.down", withConfiguration: configuration)
            }
            .store(in: &cancellables)

        filterLights()
    }

    @objc func handleCloseAction() {
        animateDismissView()
    }

    func setupPanGesture() {
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(self.handlePanGesture(gesture:)))
        // change to false to immediately listen on gesture movement
        panGesture.delaysTouchesBegan = false
        panGesture.delaysTouchesEnded = false
        view.addGestureRecognizer(panGesture)
    }

    @objc func handlePanGesture(gesture: UIPanGestureRecognizer) {
        let translation = gesture.translation(in: view)

        // Get drag direction
        let isDraggingDown = translation.y > 0

        // New height is based on value of dragging plus current container height
        let newHeight = self.rootView.currentContainerHeight - translation.y

        // Handle based on gesture state
        switch gesture.state {
        case .changed:
            // This state will occur when user is dragging
            if newHeight < self.rootView.maximumContainerHeight {
                // Keep updating the height constraint
                self.rootView.containerViewHeightConstraint?.constant = newHeight
                // refresh layout
                view.layoutIfNeeded()
            }
        case .ended:
            // This happens when user stop drag,
            // so we will get the last height of container

            // Condition 1: If new height is below min, dismiss controller
            if newHeight < self.rootView.dismissibleHeight {
                self.animateDismissView()
            }
            else if newHeight < self.rootView.defaultHeight {
                // Condition 2: If new height is below default, animate back to default
                self.rootView.hiddenValueSubject.send(true)
                animateContainerHeight(self.rootView.defaultHeight)
            }
            else if newHeight < self.rootView.maximumContainerHeight && isDraggingDown {
                // Condition 3: If new height is below max and going down, set to default height
                self.rootView.hiddenValueSubject.send(true)
                animateContainerHeight(self.rootView.defaultHeight)
            }
            else if newHeight > self.rootView.defaultHeight && !isDraggingDown {
                // Condition 4: If new height is below max and going up, set to max height at top
                self.rootView.hiddenValueSubject.send(false)
                animateContainerHeight(self.rootView.maximumContainerHeight)
            }
        default:
            break
        }
    }

    func animateContainerHeight(_ height: CGFloat) {
        UIView.animate(withDuration: 0.4) {
            // Update container height
            self.rootView.containerViewHeightConstraint?.constant = height
            // Call this to trigger refresh constraint
            self.view.layoutIfNeeded()
        }
        // Save current height
        self.rootView.currentContainerHeight = height
    }

    // MARK: Present and dismiss animation
    func animatePresentContainer() {
        // update bottom constraint in animation block
        UIView.animate(withDuration: 0.3) {
            self.rootView.containerViewBottomConstraint?.constant = 0
            // call this to trigger refresh constraint
            self.view.layoutIfNeeded()
        }
    }

    func animateShowDimmedView() {
        self.rootView.dimmedView.alpha = 0
        UIView.animate(withDuration: 0.4) {
            self.rootView.dimmedView.alpha = self.rootView.maxDimmedAlpha
        }
    }

    func animateDismissView() {
        // hide blur view
        self.rootView.dimmedView.alpha = self.rootView.maxDimmedAlpha
        UIView.animate(withDuration: 0.4) {
            self.rootView.dimmedView.alpha = 0
        } completion: { _ in
            // once done, dismiss without animation
            self.dismiss(animated: false)
        }
        // hide main view by updating bottom constraint in animation block
        UIView.animate(withDuration: 0.3) {
            self.rootView.containerViewBottomConstraint?.constant = self.rootView.defaultHeight
            // call this to trigger refresh constraint
            self.view.layoutIfNeeded()
        }
    }

    func filterLights() {
        viewModel.warningSubject
            .combineLatest(viewModel.advisorySubject, viewModel.infoSubject)
            .sink { [weak self] (warning, advisory, info) in
                guard let self = self else { return }
                viewModel.buildView(
                    lightArr: warning,
                    stack: self.rootView.highView.warningImgStack,
                    .warning)
                viewModel.buildView(
                    lightArr: advisory,
                    stack: self.rootView.highView.advisoryImgStack,
                    .advisory)
                viewModel.buildView(
                    lightArr: info,
                    stack: self.rootView.highView.infoImgStack,
                    .info)
            }
            .store(in: &cancellables)

        viewModel.fetchInfoData()
    }

    //MARK: Check when orientation changes
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
      if UIDevice.current.orientation.isLandscape {
        self.dismiss(animated: true)
      } else {
        self.dismiss(animated: true)
      }
    }

}
