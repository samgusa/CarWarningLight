//
//  CameraChildView.swift
//  CarWarningLight
//
//  Created by Sam Greenhill on 10/22/20.
//  Copyright © 2020 simplyAmazingMachines. All rights reserved.
//

import UIKit

//The View that appears above the tableview with Camera and Done Btns.

class CameraChildView: UIViewController {

    typealias childBtnPressed = (CameraChildView) -> Void
    
    var action: childBtnPressed?
    
    let doneBtn = UIButton()
    
    let cameraBtn = UIButton()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addViews()
        self.view.backgroundColor = .systemGray5
    }
    
    func addViews() {
        self.view.addSubview(doneBtn)
        self.view.addSubview(cameraBtn)
        doneBtn.translatesAutoresizingMaskIntoConstraints = false
        cameraBtn.translatesAutoresizingMaskIntoConstraints = false
        
        //doneBtn
        doneBtn.setTitle("Done", for: .normal)
        doneBtn.titleLabel?.font = UIFont.systemFont(ofSize: 25)
        doneBtn.setTitleColor(.label, for: .normal)
        doneBtn.contentMode = .scaleAspectFill
        
        //cameraBtn
        let largeConfig = UIImage.SymbolConfiguration(pointSize: self.view.frame.size.height, weight: .light, scale: .large)
        let img = UIImage(systemName: "camera.circle", withConfiguration: largeConfig)?.withRenderingMode(.alwaysTemplate)
        cameraBtn.tintColor = .label
        cameraBtn.setImage(img, for: .normal)
        
        cameraBtn.addTarget(self, action: #selector(cameraAction), for: .touchUpInside)
        doneBtn.addTarget(self, action: #selector(doneAction), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            cameraBtn.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            cameraBtn.centerYAnchor.constraint(equalTo: self.view.centerYAnchor),
            cameraBtn.heightAnchor.constraint(equalTo: self.view.heightAnchor, multiplier: 0.8),
            cameraBtn.widthAnchor.constraint(equalTo: self.view.heightAnchor, multiplier: 0.8),
            
            doneBtn.centerYAnchor.constraint(equalTo: self.view.centerYAnchor),
            doneBtn.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -20)
        ])
    }
    
    
    @objc func cameraAction() {
        UIView.animate(withDuration: 0.2) {
            self.cameraBtn.transform = CGAffineTransform.init(scaleX: 0.75, y: 0.75)
        } completion: { (_) in
            UIView.animate(withDuration: 0.2) {
                self.cameraBtn.transform = .identity
            } completion: { (_) in
                if let unwrappedAction = self.action {
                    unwrappedAction(self)
                }
            }
        }
    }
    
    @objc func doneAction() {
        navigationController?.popViewController(animated: true)
        dismiss(animated: true, completion: nil)
    }
}
