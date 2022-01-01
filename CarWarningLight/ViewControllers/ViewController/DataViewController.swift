//
//  DataViewController.swift
//  CarWarningLight
//
//  Created by Sam Greenhill on 11/8/20.
//  Copyright © 2020 simplyAmazingMachines. All rights reserved.
//

import UIKit

//view with all the information from cell pressed

class DataViewController: UIViewController {

    var dataArr = TestArr()
    
    var colors = DefaultStyle.self

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = colors.Colors.views2
        smallConfig()
    }
    
    func smallConfig() {
        view = DataDetailView(dataArr: dataArr, readAction: lowerBtnPressed)
    }

    @objc func lowerBtnPressed() {
        dismiss(animated: true, completion: nil)
    }
}
