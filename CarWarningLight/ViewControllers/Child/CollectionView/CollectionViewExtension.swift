//
//  --CollectionViewExtension.swift
//  CarWarningLight
//
//  Created by Sam Greenhill on 10/24/20.
//  Copyright © 2020 simplyAmazingMachines. All rights reserved.
//

import Foundation
import UIKit

//extensions for CollectionView Child
extension CollectionChildView:  UICollectionViewDelegate, UICollectionViewDataSource {
    
    //MARK: Number of Cells in CollectionView
        //number in cells
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return carData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! MainCollectionCell
        let img = carData[indexPath.row].image
        let name = carData[indexPath.row].name
        
        cell.carImg.image = img?.withRenderingMode(.alwaysTemplate)
        cell.imageName.text = "\(name)"
        
        cell.carImg.tintColor = cell.carImg.image?.caseTesting(str: carData[indexPath.row].symbolType)
        return cell
    }
    
    //MARK: Create Header
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "headerView", for: indexPath)
        let warning = UILabel()
        warning.text = "Never Use When Driving"
        warning.textColor = UIColor.systemRed
        warning.font = UIFont.systemFont(ofSize: 15)
        headerView.addSubview(bannerView)
        headerView.addSubview(warning)
        bannerView.center = headerView.center
        bannerView.topAnchor.constraint(equalTo: headerView.topAnchor).isActive = true

        return headerView
    }
    
    //MARK: Cells Pressed
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        AppStoreReviewManager.requestReviewIfAppropriate()
        let item = carData[indexPath.row].name
        let cell = collectionView.cellForItem(at: indexPath) as? MainCollectionCell
        UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseOut, animations: {
            //cell?.layer.shadowOpacity = 0
            cell?.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
            
        }) { (_) in
            UIView.animate(withDuration: 0.2) {
                cell?.transform = .identity
            } completion: { (_) in
                self.presentCellInfoView(withInfo: item)
            }
        }
    }
}

extension CollectionChildView: UICollectionViewDelegateFlowLayout {
    //MARK: Size of CollectionView Cell
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 110, height: 150)
    }
    
    //MARK: Distance between borders and CollectionView
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 15, left: 15, bottom: 15, right: 15)
    }
}
