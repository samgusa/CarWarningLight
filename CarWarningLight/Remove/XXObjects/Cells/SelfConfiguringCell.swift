//
//  SelfConfiguringCell.swift
//  CarWarningLight
//
//  Created by Sam Greenhill on 10/29/20.
//  Copyright © 2020 simplyAmazingMachines. All rights reserved.
//

import Foundation
import UIKit

protocol SelfConfiguringCell {
    
    static var reuseIdentifier: String { get }
    func configure(with info: InfoData)
}
