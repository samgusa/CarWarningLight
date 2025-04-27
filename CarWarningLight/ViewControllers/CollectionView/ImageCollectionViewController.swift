//
//  ImageCollectionViewController.swift
//  CarWarningLight
//
//  Created by Sam Greenhill on 11/16/20.
//  Copyright © 2020 simplyAmazingMachines. All rights reserved.
//

import UIKit
import CoreML
import Vision

//Main vc for collectionview after image recognition is done
class ImageCollectionViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    let childView = CameraChildView()
    
    //var carData = createCarData()
    
    var carArr = [String]()
    
    let colors = DefaultStyle.self
    
    let cellSpacingHeight: CGFloat = 15
    
    let carPredictionView = ImgCollectionViewController()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = colors.Colors.views2
        addCollection()
    }
    
    func addCollection() {
        addChild(childView)
        view.addSubview(childView.view)
        childView.didMove(toParent: self)
        childView.view.translatesAutoresizingMaskIntoConstraints = false

        addChild(carPredictionView)
        view.addSubview(carPredictionView.view)
        carPredictionView.didMove(toParent: self)
        carPredictionView.view.translatesAutoresizingMaskIntoConstraints = false
        carPredictionView.view.backgroundColor = colors.Colors.views2
        
        childView.action = { item in
            self.cameraAction()
        }
        
        let guide = view.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            childView.view.topAnchor.constraint(equalTo: guide.topAnchor),
            childView.view.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            childView.view.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            childView.view.heightAnchor.constraint(equalToConstant: 75),
            carPredictionView.view.topAnchor.constraint(equalTo: childView.view.bottomAnchor),
            carPredictionView.view.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            carPredictionView.view.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            carPredictionView.view.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
        ])
    }
    
    func cameraAction() {
        let alertController = UIAlertController.init(title: nil, message: nil, preferredStyle: .actionSheet)
        let takePhotoAction = UIAlertAction(title: "Camera", style: .default, handler: { action in
            self.cameraBtnPressed()
        })
        alertController.addAction(takePhotoAction)
        let selectFromAlbumAction = UIAlertAction(title: "Photos", style: .default, handler: { action in
            self.photoBtnPressed()
            
        })
        alertController.addAction(selectFromAlbumAction)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        present(alertController, animated: true, completion: nil)

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
        print("Image appears")
        guard let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else {
            fatalError("couldn't load Image")
        }
        
        guard let ciImage = CIImage(image: image) else {
            fatalError("couldn't convert UIImage to CIImage")
        }
        detectImg(image: ciImage)
    }
    
    
}
