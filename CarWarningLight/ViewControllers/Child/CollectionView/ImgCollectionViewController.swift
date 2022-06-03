//
//  ImgCollectionViewController.swift
//  CarWarningLight
//
//  Created by Sam Greenhill on 11/16/20.
//  Copyright © 2020 simplyAmazingMachines. All rights reserved.
//

import UIKit
import GoogleMobileAds

//collectionview child when img recog 
class ImgCollectionViewController: UIViewController, UINavigationControllerDelegate, GADBannerViewDelegate {

    let carData = createCarData()
    
    var bannerView = GADBannerView()
    
    let colors = DefaultStyle.self
    
    var carArr = [String]()
    
    var spacing: CGFloat = 35.0
    
    var carCollectionView = UICollectionView(frame: CGRect.init(), collectionViewLayout: UICollectionViewFlowLayout.init())
    var layout = UICollectionViewFlowLayout.init()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.definesPresentationContext = true
        self.view.backgroundColor = colors.Colors.views2
        addCollection()
        bannerView = GADBannerView(adSize: GADAdSizeBanner)
        bannerView.rootViewController = self
        bannerView.adUnitID = "ca-app-pub-8573862990894439/2373350152"
        bannerView.delegate = self
        bannerView.load(GADRequest())
    }
    
    
    func addCollection() {
        
        layout.scrollDirection = UICollectionView.ScrollDirection.vertical
       
        layout.headerReferenceSize = CGSize(width: self.view.bounds.width, height: 50)
        layout.minimumLineSpacing = spacing
        
        carCollectionView = UICollectionView(frame: view.frame, collectionViewLayout: layout)
        carCollectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]

        carCollectionView.register(UICollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "imgHeaderView")
        carCollectionView.backgroundColor = colors.Colors.views2
        view.addSubview(carCollectionView)
        carCollectionView.delegate = self
        carCollectionView.dataSource = self
        
        carCollectionView.register(ImageCollectionCell.self, forCellWithReuseIdentifier: "ImgCollectionCellMain")
    }

   

}
