//
//  DataDetailView.swift
//  CarWarningLight
//
//  Created by Sam Greenhill on 1/21/21.
//  Copyright © 2021 simplyAmazingMachines. All rights reserved.
//

import UIKit
//views for DataViewController. the view when img rec cell pressed
class DataDetailView: UIView {

    var readAction: (() -> Void)?
    
    init(dataArr: TestArr, readAction: @escaping() -> Void) {
        self.readAction = readAction
        super.init(frame: .zero)
        
        let imgView = UIImageView()
        imgView.translatesAutoresizingMaskIntoConstraints = false
        let imageName = UILabel()
        imageName.translatesAutoresizingMaskIntoConstraints = false
        let descLbl = UILabel()
        descLbl.translatesAutoresizingMaskIntoConstraints = false
        let descTxt = UILabel()
        descTxt.translatesAutoresizingMaskIntoConstraints = false
        let fixLbl = UILabel()
        fixLbl.translatesAutoresizingMaskIntoConstraints = false
        let fixTxt = UILabel()
        fixTxt.translatesAutoresizingMaskIntoConstraints = false
        let driveLbl = UILabel()
        driveLbl.translatesAutoresizingMaskIntoConstraints = false
        let driveTxt = UILabel()
        driveTxt.translatesAutoresizingMaskIntoConstraints = false
        let scrolling = UIScrollView()
        scrolling.translatesAutoresizingMaskIntoConstraints = false
        let lowerBar = UIView()
        lowerBar.translatesAutoresizingMaskIntoConstraints = false
        let lowerBtn = UIButton()
        lowerBtn.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(scrolling)
        scrolling.addSubview(lowerBar)
        lowerBar.addSubview(lowerBtn)
        scrolling.addSubview(imgView)
        scrolling.addSubview(imageName)
        scrolling.addSubview(descLbl)
        scrolling.addSubview(descTxt)
        scrolling.addSubview(fixLbl)
        scrolling.addSubview(fixTxt)
        scrolling.addSubview(driveLbl)
        scrolling.addSubview(driveTxt)
        
        //imgView
        imgView.contentMode = .scaleAspectFit
        imgView.layer.masksToBounds = true
        imgView.image = dataArr.image.withRenderingMode(.alwaysTemplate)
        imgView.tintColor = dataArr.image.caseTesting(str: dataArr.symbolType)
        
        //imageName
        imageName.font = UIFontMetrics.default.scaledFont(for: UIFont.systemFont(ofSize: 28, weight: .bold))
        imageName.numberOfLines = 0
        imageName.adjustsFontSizeToFitWidth = true
        imageName.text = dataArr.name.uppercased()
        imageName.textColor = imageName.caseTesting(str: dataArr.symbolType)
        
        //descTxt
        descLbl.font = UIFontMetrics.default.scaledFont(for: UIFont.systemFont(ofSize: 23, weight: .bold))
        descLbl.textAlignment = .left
        descLbl.numberOfLines = 0
        descLbl.text = "DESCRIPTION"
        descLbl.textColor = .label
        descLbl.adjustsFontSizeToFitWidth = true
        
        //fixLbl
        fixLbl.font = UIFontMetrics.default.scaledFont(for: UIFont.systemFont(ofSize: 23, weight: .bold))
        fixLbl.textAlignment = .left
        fixLbl.numberOfLines = 0
        fixLbl.text = "HOW TO FIX"
        fixLbl.adjustsFontSizeToFitWidth = true
        fixLbl.textColor = .label
        
        //driveLbl
        driveLbl.font = UIFontMetrics.default.scaledFont(for: UIFont.systemFont(ofSize: 23, weight: .bold))
        driveLbl.textAlignment = .left
        driveLbl.numberOfLines = 0
        driveLbl.text = "SAFE TO DRIVE?"
        driveLbl.textColor = .label
        driveLbl.adjustsFontSizeToFitWidth = true
        
        //driveTxt
        driveTxt.font = UIFont.systemFont(ofSize: 25)
        driveTxt.textColor = .label
        driveTxt.textAlignment = .left
        driveTxt.numberOfLines = 0
        driveTxt.adjustsFontSizeToFitWidth = true
        driveTxt.text = drivableTxtData(str: dataArr.drivable)
        
        //descTxt
        descTxt.textAlignment = .left
        descTxt.font = UIFont.systemFont(ofSize: 25)
        descTxt.adjustsFontSizeToFitWidth = true
        descTxt.backgroundColor = .clear
        descTxt.textColor = .label
        descTxt.numberOfLines = 0
        descTxt.text = dataArr.description.joined(separator: ".\n\n")
        
        //fixTxt
        fixTxt.textAlignment = .left
        fixTxt.font = UIFont.systemFont(ofSize: 25)
        fixTxt.adjustsFontSizeToFitWidth = true
        fixTxt.backgroundColor = .clear
        fixTxt.textColor = .label
        fixTxt.numberOfLines = 0
        fixTxt.adjustsFontSizeToFitWidth = true
        fixTxt.text = dataArr.fixDescr.joined(separator: ".\n\n")
        
        //scrolling
        scrolling.isScrollEnabled = true
        scrolling.backgroundColor = .systemBackground
        
        //lower
        lowerBar.backgroundColor = .systemGray5
        let medConfig = UIImage.SymbolConfiguration(pointSize: frame.size.height, weight: .bold, scale: .large)
        let img = UIImage(systemName: "chevron.compact.down", withConfiguration: medConfig)
        lowerBtn.tintColor = .label
        lowerBtn.setImage(img, for: .normal)
        
        let guide = self.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            //scrolling
            scrolling.topAnchor.constraint(equalTo: self.topAnchor),
            scrolling.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            scrolling.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            scrolling.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            
            //lower bar
            lowerBar.topAnchor.constraint(equalTo: scrolling.topAnchor),
            lowerBar.leadingAnchor.constraint(equalTo: guide.leadingAnchor),
            lowerBar.trailingAnchor.constraint(equalTo: guide.trailingAnchor),
            lowerBar.heightAnchor.constraint(equalToConstant: 30),
            
            //lowerBtn
            lowerBtn.centerXAnchor.constraint(equalTo: lowerBar.centerXAnchor),
            lowerBtn.centerYAnchor.constraint(equalTo: lowerBar.centerYAnchor),
            lowerBtn.heightAnchor.constraint(equalTo: lowerBar.heightAnchor),
            lowerBtn.widthAnchor.constraint(equalTo: lowerBar.heightAnchor),
            
            //imgView
            imgView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            imgView.heightAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.3),
            imgView.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.3),
            imgView.topAnchor.constraint(equalTo: lowerBar.bottomAnchor, constant: 10),
            
            //imageName
            imageName.topAnchor.constraint(equalTo: imgView.bottomAnchor, constant: 20),
            imageName.leadingAnchor.constraint(equalTo: guide.leadingAnchor, constant: 10),
            imageName.trailingAnchor.constraint(equalTo: guide.trailingAnchor, constant: -10),
            
            //descLbl
            descLbl.topAnchor.constraint(equalTo: imageName.bottomAnchor, constant: 20),
            descLbl.leadingAnchor.constraint(equalTo: guide.leadingAnchor, constant: 10),
            descLbl.trailingAnchor.constraint(equalTo: guide.trailingAnchor, constant: -10),

            //descTxt
            descTxt.topAnchor.constraint(equalTo: descLbl.bottomAnchor, constant: 20),
            descTxt.leadingAnchor.constraint(equalTo: guide.leadingAnchor, constant: 10),
            descTxt.trailingAnchor.constraint(equalTo: guide.trailingAnchor, constant: -10),
            
            //fixLbl
            fixLbl.topAnchor.constraint(equalTo: descTxt.bottomAnchor, constant: 20),
            fixLbl.leadingAnchor.constraint(equalTo: guide.leadingAnchor, constant: 10),
            fixLbl.trailingAnchor.constraint(equalTo: guide.trailingAnchor, constant: -10),

            //fixTxt
            fixTxt.topAnchor.constraint(equalTo: fixLbl.bottomAnchor, constant: 20),
            fixTxt.leadingAnchor.constraint(equalTo: guide.leadingAnchor, constant: 10),
            fixTxt.trailingAnchor.constraint(equalTo: guide.trailingAnchor, constant: -10),
            
            //driveLbl
            driveLbl.topAnchor.constraint(equalTo: fixTxt.bottomAnchor, constant: 20),
            driveLbl.leadingAnchor.constraint(equalTo: guide.leadingAnchor, constant: 10),
            driveLbl.trailingAnchor.constraint(equalTo: guide.trailingAnchor, constant: -10),
            
            //driveTxt
            driveTxt.topAnchor.constraint(equalTo: driveLbl.bottomAnchor, constant: 20),
            driveTxt.leadingAnchor.constraint(equalTo: guide.leadingAnchor, constant: 10),
            driveTxt.trailingAnchor.constraint(equalTo: guide.trailingAnchor, constant: -0),
            driveTxt.bottomAnchor.constraint(equalTo: scrolling.bottomAnchor, constant: -25)
        ])
        lowerBtn.addTarget(self, action: #selector(readProject), for: .touchUpInside)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    @objc func readProject() {
        readAction?()
    }
}
