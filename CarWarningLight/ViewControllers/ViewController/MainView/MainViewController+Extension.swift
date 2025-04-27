//
//  MainViewController+Extension.swift
//  CarWarningLight
//
//  Created by Sam Greenhill on 9/19/23.
//  Copyright © 2023 simplyAmazingMachines. All rights reserved.
//

import Foundation
import UIKit

extension TestingViewController: UICollectionViewDelegate, UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return carLightSubject.value.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as? MainCollectionCell else {
            fatalError()
        }

        carLightSubject
            .sink { carData in
                let indexPath = carData[indexPath.row]
                cell.imageName.text = indexPath.name
                let image = UIImage(named: indexPath.image)
                cell.carImg.image = image?.withRenderingMode(.alwaysTemplate)
                //cell.carImg.tintColor = indexPath.symbolType.symbolColor
            }
            .store(in: &cancellables)

        return cell
    }
}

extension TestingViewController: UICollectionViewDelegateFlowLayout {
    //MARK: Size of CollectionView Cell
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let sectionInsets = UIEdgeInsets(top: 30, left: 30, bottom: 30, right: 30) // Same as in insetForSectionAt
        let interItemSpacing: CGFloat = 30.0

            // Calculate available width for the cell's content
            let availableWidth = collectionView.bounds.width - sectionInsets.left - sectionInsets.right

            // Calculate the width for each cell in a row (e.g., two cells)
            let cellWidth = (availableWidth - interItemSpacing) / 3 // Adjust the number for the desired number of cells in a row

            let cellHeight = cellWidth * 1.5

            // Use cellWidth to determine the cell size
            return CGSize(width: cellWidth, height: cellHeight)
    }

//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
//        return UIEdgeInsets(top: 15, left: 15, bottom: 15, right: 15)
//    }
}
