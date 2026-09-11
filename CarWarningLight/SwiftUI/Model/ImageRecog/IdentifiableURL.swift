//
//  IdentifiableURL.swift
//  CarWarningLight
//
//  Created by Sam Greenhill on 8/23/26.
//  Copyright © 2026 simplyAmazingMachines. All rights reserved.
//

import Foundation
import SwiftUI

struct IdentifiableURL: Identifiable {
    let url: URL
    var title: String? = nil
    var id: String { url.absoluteString }
}
