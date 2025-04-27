//
//  MainView.swift
//  CarWarningLight
//
//  Created by Sam Greenhill on 9/19/23.
//  Copyright © 2023 simplyAmazingMachines. All rights reserved.
//

import Foundation
import UIKit
import Combine

final class MainView: UIView {

    private var colors = DefaultStyle.self

    lazy var collectionView: UICollectionView = {
        let viewLayout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: viewLayout)
        return collectionView
    }()

    init() {
        super.init(frame: .zero)
        self.backgroundColor = colors.Colors.views2
        addCollectionView()
    }

    func addCollectionView() {
        self.collectionView.contentInsetAdjustmentBehavior = .always
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(collectionView)

        collectionView.contentInset = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)
        collectionView.backgroundColor = colors.Colors.views2

        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: self.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
        collectionView.register(MainCollectionCell.self, forCellWithReuseIdentifier: "cell")
    }
    

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    
}
