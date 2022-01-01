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

typealias Root = [Section]
