//
//  CollectionChildView.swift
//  CarWarningLight
//
//  Created by Sam Greenhill on 10/18/20.
//  Copyright © 2020 simplyAmazingMachines. All rights reserved.
//

import UIKit

//collectionView on main VC

class CollectionChildView: UIViewController, BlurDelegate, UINavigationControllerDelegate {
    
    let carData = createCarData()
    
    let blursView = UIVisualEffectView()
    
    var blurPressed = false
    
    var cellInfoView = MainCellView()
    
    var colors = DefaultStyle.self
    
    func removeBlurView() {
        for subview in view.subviews {
            if subview.isKind(of: UIVisualEffect.self) {
                subview.removeFromSuperview()
                self.animateOut()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.definesPresentationContext = true
        self.view.backgroundColor = colors.Colors.views2
        addCollection()
    }

    func addCollection() {
        
        let layout = UICollectionViewFlowLayout()
        layout.headerReferenceSize = CGSize(width: self.view.bounds.width, height: 50)
        let collection = UICollectionView(frame: view.frame, collectionViewLayout: layout)
        collection.translatesAutoresizingMaskIntoConstraints = false
        collection.register(UICollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "headerView")
        collection.backgroundColor = colors.Colors.views2
        layout.minimumLineSpacing = 25
        layout.minimumInteritemSpacing = 5
        view.addSubview(collection)
        
        collection.dataSource = self
        collection.delegate = self
        
        NSLayoutConstraint.activate([
            collection.topAnchor.constraint(equalTo: self.view.topAnchor),
            collection.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            collection.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            collection.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
        ])
        
        collection.register(MainCollectionCell.self, forCellWithReuseIdentifier: "cell")
    }
    
    func animateOut() {
        self.navigationController?.navigationBar.isHidden = false
        UIView.animate(withDuration: 0.9, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0, options: [], animations: {
            self.cellInfoView.transform = CGAffineTransform.init(scaleX: 0.2, y: 0.2)
            self.cellInfoView.alpha = 0
        })
        blurPressed = false
        self.blursView.removeFromSuperview()
    }
}
