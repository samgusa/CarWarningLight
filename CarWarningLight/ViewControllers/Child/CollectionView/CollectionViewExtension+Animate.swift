//
//  CollectionViewExtension+Animate.swift
//  CarWarningLight
//
//  Created by Sam Greenhill on 1/21/21.
//  Copyright © 2021 simplyAmazingMachines. All rights reserved.
//

import Foundation
import UIKit


extension CollectionChildView {
    
    func setBluringView() {
        blursView.frame = view.frame
        blursView.effect = UIBlurEffect(style: .regular)
        blursView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.addSubview(blursView)
    }
    
    //MARK: Fetch data when cell pressed
    
    func presentCellInfoView(withInfo info: String) {
        
        blurPressed = !blurPressed
        if blurPressed {
            self.navigationController?.navigationBar.isHidden = true
            self.setBluringView()
            self.cellInfoView.translatesAutoresizingMaskIntoConstraints = false
            self.view.addSubview(cellInfoView)
//            for data in carData {
//                if info == data.name {
//                    let img = data.image
//                    let name = data.name
//                    let desc = data.description
//                    let symbol = data.symbolType
//                    cellInfoView.imageView.image = img?.withRenderingMode(.alwaysTemplate)
//                    cellInfoView.tintColor = cellInfoView.imageView.image?.caseTesting(str: symbol)
//                    cellInfoView.nameLbl.text = name.uppercased()
//                    cellInfoView.nameLbl.textColor = cellInfoView.nameLbl.caseTesting(str: symbol)
//                    
//                    let concatStr = desc.components(separatedBy: ". ").filter({ $0 != "" })
//
//                    cellInfoView.dataTxt.text = concatStr.joined(separator: "\n\n")
//                    let fixConcat = data.fixDescr.components(separatedBy: ". ")
//                    cellInfoView.fixTxt.text = fixConcat.joined(separator: "\n\n")
//                    cellInfoView.driveData.text = drivableTxtData(str: data.drivable)
//                    cellInfoView.scrolling.setContentOffset(CGPoint.zero, animated: false)
//                }
//            }
            cellInfoView.backgroundColor = .systemBackground
            NSLayoutConstraint.activate([
                cellInfoView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                cellInfoView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8),
                cellInfoView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.8),
                cellInfoView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
            ])
            
            cellInfoView.transform = CGAffineTransform.init(scaleX: 0.2, y: 0.2)
            cellInfoView.alpha = 0
            
            UIView.animate(withDuration: 0.6, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0, options: [], animations: {
                self.cellInfoView.alpha = 1
                self.cellInfoView.transform = .identity
            })
        } else {
            self.animateOut()
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch: UITouch? = touches.first
        if touch?.view != cellInfoView {
            super.touchesEnded(touches, with: event)
            self.animateOut()
        }
    }
    
    

    func setBlurView() {
        blursView.frame = view.frame
        blursView.effect = UIBlurEffect(style: .regular)
        blursView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.addSubview(blursView)
    }
}
