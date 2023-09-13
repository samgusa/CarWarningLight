import Foundation
import Combine
import UIKit

extension BottomSheetViewController {

    //MARK: Filtering
    func otherFilter() {
        viewModel.warningSubject
            .combineLatest(viewModel.advisorySubject, viewModel.infoSubject)
            .sink { [weak self] (warning, advisory, info) in
                guard let self = self else { return }
                self.viewModel.buildView(
                    lightArr: warning,
                    stack: self.rootView.highView.warningImgStack,
                    .warning)
                self.viewModel.buildView(
                    lightArr: advisory,
                    stack: self.rootView.highView.advisoryImgStack,
                    .advisory)
                self.viewModel.buildView(
                    lightArr: info,
                    stack: self.rootView.highView.infoImgStack,
                    .info)
            }
            .store(in: &cancellables)

        viewModel.fetchInfoData()
    }

    //MARK: Animated presentation
    @objc func animateDismissView() {
        UIView.animate(withDuration: 0.3) {
            self.rootView.containerViewBottomConstraint?.constant = self.rootView.defaultHeight
            self.view.layoutIfNeeded()
        }
        
        self.rootView.dimmedView.alpha = rootView.maxDimmedAlpha
        UIView.animate(withDuration: 0.4) {
            self.rootView.dimmedView.alpha = 0
        } completion: { _ in
            self.dismiss(animated: false)
        }
    }

    func setUpPanGesture() {
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(self.handlePanGesture(gesture:)))
        panGesture.delaysTouchesBegan = false
        panGesture.delaysTouchesEnded = false
        view.addGestureRecognizer(panGesture)
    }


    @objc func handlePanGesture(gesture: UIPanGestureRecognizer) {
        let translation = gesture.translation(in: view)

        let isDraggingDown = translation.y > 0

        let newHeight = self.rootView.currentContainerHeight - translation.y

        switch gesture.state {
        case .changed:
            //this state will occur when user is dragging
            if newHeight < self.rootView.maximumContainerHeight {
                self.rootView.containerViewHeightConstraint?.constant = newHeight
                view.layoutIfNeeded()
            }
        case .ended:
            //this happens when user stop drag

            //condition 1: if new height is below min, dismiss controller
            if newHeight < self.rootView.dismissableHeight {
                self.animateDismissView()
            }
            else if newHeight < self.rootView.defaultHeight {
                // condition 2: if new height is below default, animate back to default.
                rootView.hiddenValueSubject.send(true)
                animateContainerHeight(self.rootView.defaultHeight)
            }
            else if newHeight < self.rootView.maximumContainerHeight && isDraggingDown {
                // Condition 3: if new height is below max and going down, set to default height
                rootView.hiddenValueSubject.send(true)
                animateContainerHeight(self.rootView.defaultHeight)
            }
            else if newHeight > self.rootView.defaultHeight && !isDraggingDown {
                // condition 4: if new height is below max and going up, set to max height at top
                rootView.hiddenValueSubject.send(false)
                animateContainerHeight(self.rootView.maximumContainerHeight)
            }
        default:
            break
        }
    }

    func animateShowDimmedView() {
        self.rootView.dimmedView.alpha = 0
        UIView.animate(withDuration: 0.4) {
            self.rootView.dimmedView.alpha = self.rootView.maxDimmedAlpha
        }
    }

    func animatePresentContainer() {
        UIView.animate(withDuration: 0.3) {
            self.rootView.containerViewBottomConstraint?.constant = 0
            self.view.layoutIfNeeded()
        }
    }

    func animateContainerHeight(_ height: CGFloat) {
        UIView.animate(withDuration: 0.4) {
            self.rootView.containerViewHeightConstraint?.constant = height
            self.view.layoutIfNeeded()
        }
        self.rootView.currentContainerHeight = height
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
