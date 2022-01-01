//
//  TestViewExtensions.swift
//  CarWarningLight
//
//  Created by Sam Greenhill on 10/19/20.
//  Copyright © 2020 simplyAmazingMachines. All rights reserved.
//

import Foundation
import UIKit
//Extension for the floating button and what happens when pressed

extension TestingViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func setUpFloatingBtn() {
        
        let systemSize = UIImage.SymbolConfiguration(pointSize: 50, weight: .bold, scale: .medium)
        let smallSize = UIImage.SymbolConfiguration(pointSize: 35, weight: .medium, scale: .small)
        let cameraRound = UIImage(systemName: "camera.circle.fill", withConfiguration: systemSize)?.withRenderingMode(.alwaysTemplate)
        
        let cameraBtn = UIImage(systemName: "camera.circle", withConfiguration: smallSize)?.withRenderingMode(.alwaysTemplate)
        
        let photoBtn = UIImage(systemName: "photo", withConfiguration: smallSize)?.withRenderingMode(.alwaysTemplate)
        
        let camera = FloatingButtonItem(title: "Camera", image: cameraBtn)
        let photo = FloatingButtonItem(title: "Photo", image: photoBtn)
        
        camera.action = { item in
            self.cameraBtnPressed()
        }
        
        photo.action = { item in
            self.photoBtnPressed()
        }
            
        floatBtn = FloatingButton(attachedToView: self.view, items: [photo, camera])
        
        floatBtn.setImage(cameraRound, forState: .normal)
        
        floatBtn.backgroundColor = .systemBackground
        floatBtn.action = { button in
            self.childView.cellInfoView.removeFromSuperview()
            self.childView.blursView.removeFromSuperview()
            self.childView.blurPressed = false
            self.navigationController?.navigationBar.isHidden = false
            button.toggleMenu()
        }
    }
    
    //MARK: Action for user to take photo
    func cameraBtnPressed() {
        guard UIImagePickerController.isSourceTypeAvailable(.camera) else {
        let alert = UIAlertController(title: "No Camera", message: "This device does not support camera", preferredStyle: .alert)
        let ok = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alert.addAction(ok)
            self.present(alert, animated: true, completion: nil)
            return
        }
        
        let picker = UIImagePickerController()
        picker.delegate = self as UIImagePickerControllerDelegate & UINavigationControllerDelegate
        picker.sourceType = .camera
        picker.cameraCaptureMode = .photo
        present(picker, animated: true, completion: nil)
    }
    
    //MARK: Action for user to choose from Photo Library
    func photoBtnPressed() {
        guard UIImagePickerController.isSourceTypeAvailable(.photoLibrary) else {
            let alert = UIAlertController(title: "No Photos", message: "This Device Does Not Support Photos", preferredStyle: .alert)
            let ok = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alert.addAction(ok)
            UIApplication.shared.delegate?.window!?.rootViewController?.present(alert, animated: true, completion: nil)
            return
        }
        let picker = UIImagePickerController()
        picker.delegate = self as UIImagePickerControllerDelegate & UINavigationControllerDelegate
        picker.sourceType = .photoLibrary
        present(picker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        dismiss(animated: true, completion: nil)
        
        //guard unwrap the image picked
        guard let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else { fatalError("Couldn't load image")
        }
        
        //convert UIImage to CIImage to pass to the image request handler
        guard let ciImage = CIImage(image: image) else {
            fatalError("Couldn't convert UIImage to CIImage")
        }
        removeFloatView()
        detectImages(image: ciImage, btn: infoBtn)
    }
    
    func removeFloatView() {
        DispatchQueue.main.async {
            self.floatBtn.hideBlur()
            self.floatBtn.active = false
        }
    }
}
