//
//  InfoDataCell.swift
//  CarWarningLight
//
//  Created by Sam Greenhill on 10/26/20.
//  Copyright © 2020 simplyAmazingMachines. All rights reserved.
//

import Foundation
import UIKit

protocol BlurDelegate: class {
    func removeBlurView()
}

//this is the cell information for the info button being pressed

class InfoDataCell: UICollectionViewCell, SelfConfiguringCell {
    
    let colors = DefaultStyle.self
    
    static var reuseIdentifier: String = "InfoCell3"
    
    let infoImg = UIImageView()
    
    let infoName = UILabel()
    
    let infoLrg = LargeLbl()
    
    let leftView = UIView()
    
    let rightView = UIView()
    
    let btmView = UIView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addCell()
    }
    
    func addCell() {
        
        self.contentView.addSubview(leftView)
        self.contentView.addSubview(rightView)
        self.contentView.addSubview(btmView)
        leftView.addSubview(infoImg)
        rightView.addSubview(infoName)
        rightView.addSubview(infoLrg)
        leftView.translatesAutoresizingMaskIntoConstraints = false
        rightView.translatesAutoresizingMaskIntoConstraints = false
        infoName.translatesAutoresizingMaskIntoConstraints = false
        infoImg.translatesAutoresizingMaskIntoConstraints = false
        infoLrg.translatesAutoresizingMaskIntoConstraints = false
        btmView.translatesAutoresizingMaskIntoConstraints = false
        leftView.backgroundColor = colors.Colors.views
        rightView.backgroundColor = colors.Colors.views
        btmView.backgroundColor = .label
        infoImg.contentMode = .scaleAspectFit
        infoImg.layer.masksToBounds = true
        
        infoName.font = UIFont.boldSystemFont(ofSize: 30)
        infoName.textAlignment = .left
        infoName.numberOfLines = 0
        infoName.adjustsFontSizeToFitWidth = true
        
        NSLayoutConstraint.activate([
            leftView.topAnchor.constraint(equalTo: self.contentView.topAnchor),
            leftView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor),
            leftView.bottomAnchor.constraint(equalTo: btmView.topAnchor),
            leftView.widthAnchor.constraint(equalTo: self.contentView.widthAnchor, multiplier: 0.3),
            
            rightView.topAnchor.constraint(equalTo: self.contentView.topAnchor),
            rightView.leadingAnchor.constraint(equalTo: leftView.trailingAnchor),
            rightView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor),
            rightView.bottomAnchor.constraint(equalTo: btmView.topAnchor),
            
            btmView.heightAnchor.constraint(equalToConstant: 1),
            btmView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor),
            btmView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor),
            btmView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor),

            infoImg.centerXAnchor.constraint(equalTo: leftView.centerXAnchor),
            infoImg.heightAnchor.constraint(equalTo: leftView.heightAnchor, multiplier: 0.8),
            infoImg.widthAnchor.constraint(equalTo: leftView.widthAnchor, multiplier: 0.8),
            infoImg.centerYAnchor.constraint(equalTo: leftView.centerYAnchor),
            
            infoName.topAnchor.constraint(equalTo: rightView.topAnchor),
            infoName.leadingAnchor.constraint(equalTo: rightView.leadingAnchor, constant: 10),
            infoName.trailingAnchor.constraint(equalTo: rightView.trailingAnchor),
            infoName.heightAnchor.constraint(equalTo: rightView.heightAnchor, multiplier: 0.15),
            
            infoLrg.topAnchor.constraint(equalTo: infoName.bottomAnchor, constant: 5),
            infoLrg.leadingAnchor.constraint(equalTo: rightView.leadingAnchor, constant: 10),
            infoLrg.trailingAnchor.constraint(equalTo: rightView.trailingAnchor, constant: -10),
            infoLrg.bottomAnchor.constraint(equalTo: rightView.bottomAnchor, constant: -10)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init coder has not been implemented")
    }

    func configure(with info: InfoData) {
        infoName.text = info.name
        infoImg.image = UIImage(named: info.image)?.withRenderingMode(.alwaysTemplate)
        infoName.textColor = infoName.textColor.caseTesting(str: info.name)
        infoImg.tintColor = infoImg.tintColor.caseTesting(str: info.name)
        infoLrg.dataTxt = info.data.components(separatedBy: ". ")
    }

}
