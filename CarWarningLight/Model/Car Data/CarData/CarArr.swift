//
//  CarArr.swift
//  CarWarningLight
//
//  Created by Sam Greenhill on 3/17/19.
//  Copyright © 2019 simplyAmazingMachines. All rights reserved.
//

import Foundation
import UIKit

//Class for the collectionview information

struct CarArr {
    //name, image, description, symbol type, openBool, fix description, drivable
    
    var name: String
    var image: UIImage!
    var description: String
    var symbolType: String
    var openBool: Bool
    var fixDescr: String
    var drivable: String

}

struct CarDatum: Codable {
    let id: Int
    let name, image, carDatumDescription: String
    let symbolType: SymbolType
    let fixDescr: String
    let drivable: Drivable

    enum CodingKeys: String, CodingKey {
        case id, name, image
        case carDatumDescription = "description"
        case symbolType, fixDescr, drivable
    }
}

enum Drivable: String, Codable {
    case no = "no"
    case uncertain = "uncertain"
    case yes = "yes"

    var drivable: String {
        switch self {
        case .yes:
            return "Yes"
        case .no:
            return "No"
        case .uncertain:
            return "Uncertain"
        }
    }
}

enum SymbolType: String, Codable {
    case advisory = "advisory"
    case info = "info"
    case warning = "warning"

    var symbolColor: UIColor {
        switch self {
        case .warning:
            return .systemRed
        case .info:
            return .systemGreen
        case .advisory:
            return .systemYellow
        }
    }
}


typealias CarData = [CarDatum]
