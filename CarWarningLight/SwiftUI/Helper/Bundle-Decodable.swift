//
//  Bundle-Decodable.swift
//  CarWarningLight
//
//  Created by Sam Greenhill on 10/30/20.
//  Copyright © 2020 simplyAmazingMachines. All rights reserved.
//

import Foundation
import UIKit

//for jsonFile

extension Bundle {
    func decode<T: Decodable>(_ type: T.Type, from file: String) -> T {
        guard let url = self.url(forResource: file, withExtension: nil) else {
            fatalError("Failed to locate \(file) in bundle.")
        }

        guard let data = try? Data(contentsOf: url) else {
            fatalError("Failed to load \(file) from bundle.")
        }

        let decoder = JSONDecoder()

        guard let loaded = try? decoder.decode(T.self, from: data) else {
            fatalError("Failed to decode \(file) from bundle. \(LocalizedError.self)")
        }

        return loaded
    }
}
