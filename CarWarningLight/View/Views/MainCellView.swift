//
//  MainCellView.swift
//  CarWarningLight
//
//  Created by Sam Greenhill on 10/25/20.
//  Copyright © 2020 simplyAmazingMachines. All rights reserved.
//

import UIKit

//view that appears when cell is pressed
class MainCellView: UIView {

    typealias doneBtnPressed = (MainCellView) -> Void
    
    var action: doneBtnPressed?
    
    //imageView
    let imageView = UIImageView()
    
    //holds imageView
    let topView = UIView()
    
    //holds rest of the data
    let dataView = UIView()
    
    let nameLbl = UILabel()
    
    let descLbl = UILabel()
    
    let dataTxt = UILabel()
    
    let fixLbl = UILabel()
    
    let fixTxt = UILabel()
    
    let driveLbl = UILabel()
    
    let driveData = UILabel()
    
    let scrolling = UIScrollView()
    
    var portraitConstraints: [NSLayoutConstraint] = []
    var landscapeConstraints: [NSLayoutConstraint] = []
    
    private lazy var setUpView: Void = {
        //cornerRadius
        self.layer.cornerRadius = 10
        self.clipsToBounds = true
        
        //addSubview
        self.addSubview(topView)
        self.addSubview(dataView)
        self.topView.addSubview(imageView)
        self.dataView.addSubview(scrolling)
        self.scrolling.addSubview(nameLbl)
        self.scrolling.addSubview(descLbl)
        self.scrolling.addSubview(dataTxt)
        self.scrolling.addSubview(fixLbl)
        self.scrolling.addSubview(fixTxt)
        self.scrolling.addSubview(driveLbl)
        self.scrolling.addSubview(driveData)
        
        //mask constraints
        topView.translatesAutoresizingMaskIntoConstraints = false
        dataView.translatesAutoresizingMaskIntoConstraints = false
        imageView.translatesAutoresizingMaskIntoConstraints = false
        scrolling.translatesAutoresizingMaskIntoConstraints = false
        nameLbl.translatesAutoresizingMaskIntoConstraints = false
        descLbl.translatesAutoresizingMaskIntoConstraints = false
        dataTxt.translatesAutoresizingMaskIntoConstraints = false
        fixLbl.translatesAutoresizingMaskIntoConstraints = false
        fixTxt.translatesAutoresizingMaskIntoConstraints = false
        driveLbl.translatesAutoresizingMaskIntoConstraints = false
        driveData.translatesAutoresizingMaskIntoConstraints = false
        
        let guide = self.safeAreaLayoutGuide
        
        //imageView
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.backgroundColor = .systemBackground
        
        //topView
        topView.backgroundColor = .systemBackground
        
        //dataView
        dataView.backgroundColor = .systemBackground
        
        //nameLbl
        nameLbl.font = UIFontMetrics.default.scaledFont(for: UIFont.systemFont(ofSize: 23, weight: .bold))
        nameLbl.textAlignment = .left
        nameLbl.numberOfLines = 0
        nameLbl.adjustsFontSizeToFitWidth = true
        nameLbl.textColor = .systemRed
        nameLbl.backgroundColor = .systemBackground
        
        //descLbl
        descLbl.font = UIFontMetrics.default.scaledFont(for: UIFont.systemFont(ofSize: 23, weight: .bold))
        descLbl.textAlignment = .left
        descLbl.text = "DESCRIPTION"
        descLbl.numberOfLines = 0
        descLbl.adjustsFontSizeToFitWidth = true
        descLbl.textColor = .label
        descLbl.backgroundColor = .systemBackground
        
        //dataTxt
        dataTxt.textAlignment = .left
        dataTxt.font = UIFont.systemFont(ofSize: 25)
        dataTxt.adjustsFontSizeToFitWidth = true
        dataTxt.backgroundColor = .clear
        dataTxt.textColor = .label
        dataTxt.numberOfLines = 0
        
        //fixLbl
        fixLbl.font = UIFontMetrics.default.scaledFont(for: UIFont.systemFont(ofSize: 23, weight: .bold))
        fixLbl.textAlignment = .left
        fixLbl.numberOfLines = 0
        fixLbl.text = "HOW TO FIX"
        fixLbl.adjustsFontSizeToFitWidth = true
        fixLbl.textColor = .label
        fixLbl.backgroundColor = .systemBackground
        
        //fixTxt
        fixTxt.textAlignment = .left
        fixTxt.font = UIFont.systemFont(ofSize: 25)
        fixTxt.adjustsFontSizeToFitWidth = true
        fixTxt.backgroundColor = .clear
        fixTxt.textColor = .label
        fixTxt.numberOfLines = 0
        
        //driveLbl
        driveLbl.font = UIFontMetrics.default.scaledFont(for: UIFont.systemFont(ofSize: 23, weight: .bold))
        driveLbl.textAlignment = .left
        driveLbl.numberOfLines = 0
        driveLbl.text = "SAFE TO DRIVE?"
        driveLbl.adjustsFontSizeToFitWidth = true
        driveLbl.textColor = .label
        driveLbl.backgroundColor = .systemBackground
        
        //driveData
        driveData.font = UIFont.systemFont(ofSize: 25)
        driveData.textColor = .label
        driveData.textAlignment = .left
        driveData.numberOfLines = 0
        
        //scrolling
        scrolling.isScrollEnabled = true
        scrolling.backgroundColor = .systemBackground

        //img layout
        let defaultImgTop = topView.topAnchor.constraint(equalTo: guide.topAnchor)
        let defaultImgLeading = topView.leadingAnchor.constraint(equalTo: guide.leadingAnchor)
        
        
        //portrait
        let portraitImgTrailing = topView.trailingAnchor.constraint(equalTo: guide.trailingAnchor)
        let portraitImgHeight = topView.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.3)
        
        //view layouts
        let defaultLblTrailing = dataView.trailingAnchor.constraint(equalTo: guide.trailingAnchor)
        let defaultLblBottom = dataView.bottomAnchor.constraint(equalTo: guide.bottomAnchor)
        
        //portrait
        let portraitLblBottom = dataView.topAnchor.constraint(equalTo: topView.bottomAnchor)
        let portraitLblLeading = dataView.leadingAnchor.constraint(equalTo: guide.leadingAnchor)
        
        //imageView landscape constraints
        let landscapeImgBottom = topView.bottomAnchor.constraint(equalTo: guide.bottomAnchor)
        
        let landscapeImgWidth = topView.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.2)
        
        scrolling.contentSize = CGSize(width: scrolling.contentSize.width, height: scrolling.contentSize.height)
        
        NSLayoutConstraint.activate([
            imageView.centerXAnchor.constraint(equalTo: topView.centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: topView.centerYAnchor),
            imageView.heightAnchor.constraint(equalTo: topView.heightAnchor, multiplier: 0.5),
            imageView.widthAnchor.constraint(equalTo: topView.widthAnchor, multiplier: 0.5),
            
            scrolling.topAnchor.constraint(equalTo: dataView.topAnchor),
            scrolling.bottomAnchor.constraint(equalTo: dataView.bottomAnchor),
            scrolling.leadingAnchor.constraint(equalTo: dataView.leadingAnchor),
            scrolling.trailingAnchor.constraint(equalTo: dataView.trailingAnchor),
            
            nameLbl.centerXAnchor.constraint(equalTo: scrolling.centerXAnchor),
            nameLbl.topAnchor.constraint(equalTo: scrolling.topAnchor),
            nameLbl.trailingAnchor.constraint(equalTo: scrolling.trailingAnchor, constant: -1),
            nameLbl.leadingAnchor.constraint(equalTo: scrolling.leadingAnchor, constant: 8),
            
            descLbl.topAnchor.constraint(equalTo: nameLbl.bottomAnchor, constant: 10),
            descLbl.leadingAnchor.constraint(equalTo: scrolling.leadingAnchor, constant: 8),
            descLbl.trailingAnchor.constraint(equalTo: scrolling.trailingAnchor, constant: -1),
            
            dataTxt.topAnchor.constraint(equalTo: descLbl.bottomAnchor, constant: 8),
            
            dataTxt.leadingAnchor.constraint(equalTo: self.scrolling.leadingAnchor, constant: 8),
            dataTxt.trailingAnchor.constraint(equalTo: self.scrolling.trailingAnchor, constant: -1),
            
            fixLbl.topAnchor.constraint(equalTo: dataTxt.bottomAnchor, constant: 10),
            fixLbl.leadingAnchor.constraint(equalTo: scrolling.leadingAnchor, constant: 8),
            fixLbl.trailingAnchor.constraint(equalTo: scrolling.trailingAnchor, constant: -1),
            
            fixTxt.topAnchor.constraint(equalTo: fixLbl.bottomAnchor, constant: 10),
            fixTxt.leadingAnchor.constraint(equalTo: scrolling.leadingAnchor, constant: 8),
            fixTxt.trailingAnchor.constraint(equalTo: scrolling.trailingAnchor, constant: -1),
            
            driveLbl.topAnchor.constraint(equalTo: fixTxt.bottomAnchor, constant: 10),
            driveLbl.leadingAnchor.constraint(equalTo: scrolling.leadingAnchor, constant: 8),
            driveLbl.trailingAnchor.constraint(equalTo: scrolling.trailingAnchor, constant: -1),
            
            driveData.topAnchor.constraint(equalTo: driveLbl.bottomAnchor, constant: 10),
            driveData.leadingAnchor.constraint(equalTo: scrolling.leadingAnchor, constant: 8),
            driveData.trailingAnchor.constraint(equalTo: scrolling.trailingAnchor, constant: -1),
            driveData.bottomAnchor.constraint(equalTo: scrolling.bottomAnchor, constant: -15)
        ])

        let landscapeLblTop = dataView.topAnchor.constraint(equalTo: guide.topAnchor)
        let landscapeLblTrailing = dataView.leadingAnchor.constraint(equalTo: topView.trailingAnchor)
        
        let defaultContraints = [defaultImgTop, defaultImgLeading, defaultLblBottom, defaultLblTrailing]
        portraitConstraints = [portraitImgHeight, portraitImgTrailing, portraitLblBottom, portraitLblLeading]
        landscapeConstraints = [landscapeImgWidth, landscapeImgBottom, landscapeLblTop, landscapeLblTrailing]
        self.addConstraints(defaultContraints)
        
        toggleConstraints()
    }()
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        NotificationCenter.default.addObserver(self, selector: #selector(toggleConstraints), name: UIDevice.orientationDidChangeNotification, object: nil)
        _ = setUpView
    }
    
    @objc func toggleConstraints() {
        if UIDevice.current.orientation.isLandscape {
            self.removeConstraints(portraitConstraints)
            self.addConstraints(landscapeConstraints)
        } else {
            self.removeConstraints(landscapeConstraints)
            self.addConstraints(portraitConstraints)
        }
    }
    
}
