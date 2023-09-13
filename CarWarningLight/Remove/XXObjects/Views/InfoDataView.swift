//
//  --InfoDataView.swift
//  CarWarningLight
//
//  Created by Sam Greenhill on 10/26/20.
//  Copyright © 2020 simplyAmazingMachines. All rights reserved.
//

import Foundation
import UIKit
import CoreML
import GoogleMobileAds

//view that appears when info btn is pressed
class InfoDataView: UIView {

    let sections = Bundle.main.decode([Section].self, from: "car.json")

    var collectionView: UICollectionView!
    
    var dataSource: UICollectionViewDiffableDataSource<Section, InfoData>?
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setUpCollection()
    }
    
    func setUpCollection() {
        collectionView = UICollectionView(frame: self.bounds, collectionViewLayout: createCompositionalLayout())
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        collectionView.backgroundColor = .systemBackground
        self.addSubview(collectionView)
        collectionView.register(InfoDataCell.self, forCellWithReuseIdentifier: InfoDataCell.reuseIdentifier)
        createDataSource()
        reloadData()
    }
    
    func configure<T: SelfConfiguringCell>(_ cellType: T.Type, with info: InfoData, for indexPath: IndexPath) -> T {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellType.reuseIdentifier, for: indexPath) as? T else {
            fatalError("unable to dequeue \(cellType)")
        }
        cell.configure(with: info)
        return cell
    }
    
    func createDataSource() {
        dataSource = UICollectionViewDiffableDataSource<Section, InfoData>(collectionView: collectionView) { collectionView, indexPath, item in
            switch self.sections[indexPath.section] {
            default:
                return self.configure(InfoDataCell.self, with: item, for: indexPath)
            }
        }
    }
    
    func reloadData() {
        var snapshot = NSDiffableDataSourceSnapshot<Section, InfoData>()
        snapshot.appendSections(sections)
        for section in sections {
            snapshot.appendItems(section.data, toSection: section)
        }
        dataSource?.apply(snapshot)
    }
    
    func createCompositionalLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { sectionIndex, layoutEnvironment in
            let section = self.sections[sectionIndex]
            
            switch section {
            default:
                return self.createFunctionSection(using: section)
            }
        }
        let config = UICollectionViewCompositionalLayoutConfiguration()
        layout.configuration = config
        return layout
    }
    
    func createFunctionSection(using section: Section) -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
        
        let layoutItem = NSCollectionLayoutItem(layoutSize: itemSize)
        layoutItem.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0)
        
        let layoutGroupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(0.45))
        
        let layoutGroup = NSCollectionLayoutGroup.horizontal(layoutSize: layoutGroupSize, subitems: [layoutItem])
        
        let layoutSection = NSCollectionLayoutSection(group: layoutGroup)
        layoutSection.orthogonalScrollingBehavior = .groupPagingCentered
        
        return layoutSection        
    }

}
