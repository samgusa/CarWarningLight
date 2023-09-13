//
//  InfoBtn.swift
//  CarWarningLight
//
//  Created by Sam Greenhill on 10/17/20.
//  Copyright © 2020 simplyAmazingMachines. All rights reserved.
//

import UIKit

//Info Btn on navigationBar
class InfoBtn: UIButton {
    
    let imgView = UIImageView()
    
    typealias infoBtnPressed = (InfoBtn) -> Void
    
    var action: infoBtnPressed?
    
    private lazy var setUpImg: Void = {
        self.addSubview(imgView)
        imgView.translatesAutoresizingMaskIntoConstraints = false
        
        let largeConfig = UIImage.SymbolConfiguration(pointSize: 30, weight: .light, scale: .small)
        let img = UIImage(systemName: "info.circle", withConfiguration: largeConfig)?.withRenderingMode(.alwaysTemplate)
        imgView.image = img
        imgView.tintColor = .label
        self.addTarget(self, action: #selector(infoPressed), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            imgView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            imgView.centerYAnchor.constraint(equalTo: self.centerYAnchor)
        
        ])
    }()
    
    @objc func infoPressed() {
        UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseOut, animations: {
            self.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        }) { (_) in
            UIView.animate(withDuration: 0.2) {
                self.transform = .identity
            } completion: { (_) in
                if let unwrappedAction = self.action {
                    unwrappedAction(self)
                }
            }
        }
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        _ = setUpImg
    }
}
