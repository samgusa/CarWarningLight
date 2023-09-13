//
//  MainCollectionCell.swift
//  CarWarningLight
//
//  Created by Sam Greenhill on 10/24/20.
//  Copyright © 2020 simplyAmazingMachines. All rights reserved.
//

import UIKit

//Cell for the Main View
class MainCollectionCell: UICollectionViewCell {
    
    let colors = DefaultStyle.self
    
    var carImg = UIImageView()
    
    var imageName = UILabel()
    
    private lazy var setUpCell: Void = {
        self.contentView.addSubview(carImg)
        carImg.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(imageName)
        imageName.translatesAutoresizingMaskIntoConstraints = false
        
        //contentView
        self.contentView.layer.masksToBounds = true
        self.contentView.backgroundColor = colors.Colors.views
        self.contentView.layer.cornerRadius = 8
        self.clipsToBounds = false
        self.layer.masksToBounds = false

        //carImg
        carImg.contentMode = .scaleAspectFit
        
        //imageName
        imageName.textColor = .label
        imageName.font = UIFontMetrics.default.scaledFont(for: UIFont.systemFont(ofSize: 15, weight: .regular))
        imageName.textAlignment = .left
        imageName.numberOfLines = 0
        imageName.adjustsFontSizeToFitWidth = true
        
        NSLayoutConstraint.activate([
            carImg.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 10),
            carImg.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 10),
            carImg.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -10),
            carImg.heightAnchor.constraint(equalToConstant: 75),
            
            imageName.topAnchor.constraint(equalTo: carImg.bottomAnchor, constant: 10),
            imageName.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 10),
            imageName.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -3),
            imageName.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -3)
        
        ])
    }()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        _ = setUpCell
    }
}
