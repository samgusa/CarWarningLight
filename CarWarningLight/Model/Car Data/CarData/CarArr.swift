//
//  CarArr.swift
//  CarWarningLight
//
//  Created by Sam Greenhill on 3/17/19.
//  Copyright © 2019 simplyAmazingMachines. All rights reserved.
//

import Foundation
import UIKit
import SwiftUI

//Class for the collectionview information

struct CarArr {
    //name, image, description, symbol type, openBool, fix description, drivable
    
    var name: String
    var image: UIImage
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
    case yes, no, uncertain

    var description: String {
        rawValue.capitalized
    }

    var isDrivable: Bool? {
        switch self {
        case .yes: return true
        case .no: return false
        case .uncertain: return nil
        }
    }
}


enum SymbolType: String, Codable {
    case advisory, info, warning

    var color: Color {
        switch self {
        case .warning: return .red
        case .info: return .green
        case .advisory: return .yellow
        }
    }
}



typealias CarData = [CarDatum]

struct CarSymbol: Identifiable, Codable {
    let id: Int
    let name: String
    let imageName: String
    let description: String
    let symbolType: SymbolType
    let fixDescription: String
    let drivable: Drivable

    enum CodingKeys: String, CodingKey {
        case id, name, imageName = "image", description = "description", symbolType, fixDescription = "fixDescr", drivable
    }

    var image: Image {
        Image(imageName)
    }

    var uiImage: UIImage? {
        UIImage(named: imageName)
    }

    static let empty = CarSymbol(
            id: 0,
            name: "",
            imageName: "",
            description: "",
            symbolType: .warning, // Or a sensible default
            fixDescription: "",
            drivable: .yes // Or a sensible default
        )
}

typealias CarSymbols = [CarSymbol]
