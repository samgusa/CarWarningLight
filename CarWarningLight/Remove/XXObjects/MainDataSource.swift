//
//  MainDataSource.swift
//  CarWarningLight
//
//  Created by Sam Greenhill on 1/21/21.
//  Copyright © 2021 simplyAmazingMachines. All rights reserved.
//

import UIKit

class MainDataSource: NSObject, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    

    //let carData = createCarData()

//    func project(at index: Int) -> CarArr {
//        //return carData[index]
//    }
//    
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        //return carData.count
//    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! MainCollectionCell
//        let img = carData[indexPath.row].image
//        let name = carData[indexPath.row].name
        
        //cell.carImg.image = img?.withRenderingMode(.alwaysTemplate)
//        cell.imageName.text = "\(name)"
//        
//        cell.carImg.tintColor = cell.carImg.image?.caseTesting(str: carData[indexPath.row].symbolType)
        
        return cell
    }
    
}
