//
//  TaskStatus.swift
//  CarWarningLight
//
//  Created by Sam Greenhill on 9/6/26.
//  Copyright © 2026 simplyAmazingMachines. All rights reserved.
//

import Foundation

enum TaskStatus: Equatable {
    case idle
    case failed(String)
    case success
}
