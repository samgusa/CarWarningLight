//
//  InfoData.swift
//  CarWarningLight
//
//  Created by Sam Greenhill on 10/29/20.
//  Copyright © 2020 simplyAmazingMachines. All rights reserved.
//

import Foundation
import UIKit

//Structs for infobtn data
struct Section: Codable, Hashable {
    let id: Int
    let data: [InfoData]
}

struct InfoData: Codable, Hashable {
    let id: Int
    let name, data, image: String
}

enum InfoEnum: String, Codable {
    case warning
    case advisory
    case info

    var infoName: String {
        switch self {
        case .warning:
            return "WARNING"
        case .advisory:
            return "ADVISORY"
        case .info:
            return "INFORMATION"
        }
    }

    var infoLights: String {
        switch self {
        case .warning:
            return "Warning Lights"
        case .advisory:
            return "Advisory Lights"
        case .info:
            return "Information Lights"
        }
    }

    var infoColor: UIColor {
        switch self {
        case .warning:
            return .systemRed
        case .advisory:
            return .systemOrange
        case .info:
            return .systemGreen
        }
    }
}

typealias Root = [Section]
