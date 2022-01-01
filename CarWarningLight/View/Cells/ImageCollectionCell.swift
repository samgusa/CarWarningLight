//
//  ImageCollectionCell.swift
//  CarWarningLight
//
//  Created by Sam Greenhill on 11/16/20.
//  Copyright © 2020 simplyAmazingMachines. All rights reserved.
//

import UIKit

//Cell for collectionview after image recog is done
class ImageCollectionCell: UICollectionViewCell {
    
    var imgView = UIImageView()
    
    var imageName = UILabel()
    
    var sideImg = UIImageView()
    
    var leftView = UIView()
    
    var rightView = UIView()
    
    let colors = DefaultStyle.self
    
    private lazy var setUpCell: Void = {
        
        self.contentView.addSubview(leftView)
        self.contentView.addSubview(rightView)
        leftView.addSubview(imgView)
        rightView.addSubview(imageName)
        rightView.addSubview(sideImg)
        
        leftView.translatesAutoresizingMaskIntoConstraints = false
        rightView.translatesAutoresizingMaskIntoConstraints = false
        imgView.translatesAutoresizingMaskIntoConstraints = false
        imageName.translatesAutoresizingMaskIntoConstraints = false
        sideImg.translatesAutoresizingMaskIntoConstraints = false
        
        imgView.contentMode = .scaleAspectFit
        imgView.layer.masksToBounds = true
        
        //imageName
        imageName.textColor = .label
        imageName.font = UIFont.systemFont(ofSize: 23)
        imageName.textAlignment = .left
        imageName.numberOfLines = 0
        imageName.adjustsFontSizeToFitWidth = true
        
        //sideImg
        let sideImage = UIImage(systemName: "chevron.right.circle")?.withRenderingMode(.alwaysTemplate)
        sideImg.image = sideImage
        sideImg.tintColor = .label
        
        NSLayoutConstraint.activate([
            leftView.topAnchor.constraint(equalTo: self.contentView.topAnchor),
            leftView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor),
            leftView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor),
            leftView.widthAnchor.constraint(equalTo: self.contentView.widthAnchor, multiplier: 0.25),
            
            rightView.topAnchor.constraint(equalTo: self.contentView.topAnchor),
            rightView.leadingAnchor.constraint(equalTo: leftView.trailingAnchor),
            rightView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor),
            rightView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor),
            
            imgView.centerYAnchor.constraint(equalTo: leftView.centerYAnchor),
            imgView.leadingAnchor.constraint(equalTo: leftView.leadingAnchor, constant: 16),
            imgView.heightAnchor.constraint(equalTo: leftView.heightAnchor, multiplier: 0.7),
            imgView.widthAnchor.constraint(equalTo: leftView.heightAnchor, multiplier: 0.7),
            
            sideImg.centerYAnchor.constraint(equalTo: rightView.centerYAnchor),
            sideImg.trailingAnchor.constraint(equalTo: rightView.trailingAnchor, constant: -5),
            sideImg.heightAnchor.constraint(equalToConstant: 25),
            sideImg.widthAnchor.constraint(equalToConstant: 25),
            
            imageName.leadingAnchor.constraint(equalTo: rightView.leadingAnchor),
            imageName.trailingAnchor.constraint(equalTo: sideImg.leadingAnchor, constant: -5),
            imageName.centerYAnchor.constraint(equalTo: rightView.centerYAnchor)
        ])
    }()

    override func layoutSubviews() {
        super.layoutSubviews()
        _ = setUpCell
        self.contentView.backgroundColor = colors.Colors.views
        self.contentView.layer.masksToBounds = true
        self.contentView.shadowSetUp()
        self.contentView.layer.cornerRadius = 15
    }
}
