//
//  LargeLbl.swift
//  CarWarningLight
//
//  Created by Sam Greenhill on 10/20/20.
//  Copyright © 2020 simplyAmazingMachines. All rights reserved.
//

import UIKit
//LargeLbl for information.
class LargeLbl: UILabel {
    
    var dataTxt = [String]()
    
    private lazy var setUpLbl: Void = {
        self.textAlignment = .left
        self.font = UIFont.systemFont(ofSize: 25)
        //self.sizeToFit()
        self.adjustsFontSizeToFitWidth = true
        self.backgroundColor = .clear
        self.textColor = .label
        self.numberOfLines = 0
        let concatStr = dataTxt.joined(separator: ".\n\n")
        self.text = concatStr
    }()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        _ = setUpLbl
    }
}
