//
//  ImgCollectionExtension.swift
//  CarWarningLight
//
//  Created by Sam Greenhill on 11/16/20.
//  Copyright © 2020 simplyAmazingMachines. All rights reserved.
//

import Foundation
import UIKit

extension ImgCollectionViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return GlobalArr.otherArr.count
    }

    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "imgHeaderView", for: indexPath)
        headerView.addSubview(bannerView)
        bannerView.center = headerView.center
        bannerView.topAnchor.constraint(equalTo: headerView.topAnchor).isActive = true
        
        return headerView
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        return CGSize(width: (view.frame.size.width)*0.9, height: (view.frame.size.width)*0.2)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImgCollectionCellMain", for: indexPath) as! ImageCollectionCell

        let dict = GlobalArr.otherArr[indexPath.row]
        
        cell.imageName.text = dict.name
        
        cell.imgView.image = dict.image.withRenderingMode(.alwaysTemplate)
        cell.imgView.tintColor = dict.image.caseTesting(str: dict.symbolType)
        return cell
    }

    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 15, left: 15, bottom: 30, right: 15)
    }
    

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        AppStoreReviewManager.requestReviewIfAppropriate()
        let dict = GlobalArr.otherArr[indexPath.row]
        //let cell = collectionView.cellForItem(at: indexPath) as? ImageCollectionCell
        
        self.presentDataView(data: dict)
    }
    
    override func willTransition(to newCollection: UITraitCollection, with coordinator: UIViewControllerTransitionCoordinator) {
        if UIDevice.current.orientation.isLandscape, let layout = carCollectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            //let width = view.frame.height
            layout.itemSize = CGSize(width: (view.frame.height)*0.5, height: (view.frame.width)*0.2)
            layout.invalidateLayout()
        }
            else if UIDevice.current.orientation.isPortrait, let layout = carCollectionView.collectionViewLayout as? UICollectionViewFlowLayout {

            layout.itemSize = CGSize(width: (view.frame.width)*0.9, height: (view.frame.width)*0.2)
            layout.invalidateLayout()
        }
    }
    
    func presentDataView(data: TestArr) {
        let vc = DataViewController()
        vc.dataArr = data
        vc.modalPresentationStyle = .popover
        if let presentation = vc.popoverPresentationController {
            presentation.barButtonItem = navigationItem.rightBarButtonItem
        }
        
        self.present(vc, animated: true, completion: nil)
    }
}
