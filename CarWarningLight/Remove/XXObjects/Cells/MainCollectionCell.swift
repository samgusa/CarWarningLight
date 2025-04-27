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

    lazy var carImg: UIImageView = {
      let img = UIImageView()
      img.contentMode = .scaleAspectFit
      img.translatesAutoresizingMaskIntoConstraints = false
      return img
    }()

    lazy var imageName: PaddingLabel = {
        let lbl = PaddingLabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.textColor = .label
        //lbl.font = UIFontMetrics.default.scaledFont(for: UIFont.systemFont(ofSize: 18, weight: .regular))
        lbl.font = UIFontMetrics.default.scaledFont(for: UIFont.preferredFont(forTextStyle: .caption1))
        lbl.adjustsFontSizeToFitWidth = true
        lbl.minimumScaleFactor = 0.5
        lbl.textAlignment = .center
        lbl.numberOfLines = 2
        lbl.lineBreakMode = .byWordWrapping

        return lbl
    }()
    
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

        imageName.layer.borderWidth = 1
        imageName.layer.borderColor = UIColor.black.cgColor
        
        NSLayoutConstraint.activate([
            carImg.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            carImg.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            carImg.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.4),
            carImg.widthAnchor.constraint(equalTo: carImg.heightAnchor),
//            carImg.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
//            carImg.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            carImg.bottomAnchor.constraint(equalTo: imageName.topAnchor, constant: -10),

            imageName.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            imageName.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10),
            imageName.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10),
//            imageName.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.5),
//            imageName.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.3),
            imageName.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -2)
        ])
    }()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        _ = setUpCell
    }
}
