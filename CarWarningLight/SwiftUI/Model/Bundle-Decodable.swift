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

enum BundleDecodeError: Error {
    case missingFile(String)
    case unreadableData(String)
    case decodeFailure(String, Error)
}

extension Bundle {

    func decodeOrThrow<T: Decodable>(_ type: T.Type, from file: String) throws -> T {
        guard let url = self.url(forResource: file, withExtension: nil) else {
            throw BundleDecodeError.missingFile(file)
        }

        let data: Data
        do {
            data = try Data(contentsOf: url)
        } catch {
            throw BundleDecodeError.unreadableData(file)
        }

        do {
            return try JSONDecoder().decode(T.self, from: data)
        } catch {
            throw BundleDecodeError.decodeFailure(file, error)
        }
    }

    func decode<T: Decodable>(_ type: T.Type, from file: String) -> T {
        do {
            return try decodeOrThrow(type, from: file)
        } catch {
            fatalError("Failed to decode \(file) from bundle: \(error)")
        }
    }
}
