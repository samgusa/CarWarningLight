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

enum Drivable: String, Codable {
    case yes, no, uncertain

    /// One-word summary
    var title: String {
        rawValue.capitalized
    }

    /// At-a-glance true/false/nil
    var isDrivable: Bool? {
        switch self {
        case .yes:       return true
        case .no:        return false
        case .uncertain: return nil
        }
    }

    /// A more conversational, human explanation with the case word included
    var message: String {
        switch self {
        case .yes:
            return "Your vehicle is safe to drive. If you have any questions please consult a mechanic or check your car’s manual."
        case .no:
            return "Your vehicle should not be driven right now. It's best to have it checked by a professional."
        case .uncertain:
            return "We couldn't determine for sure. It’s a good idea to consult a mechanic or check your car’s manual."
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

struct CarSymbol: Identifiable, Codable, Hashable {
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

    var transitionID: String {
            return "\(id)-transition"
    }

    var imageID: String {
        return "\(id)-image"
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
