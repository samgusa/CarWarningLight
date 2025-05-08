//
//  ResultsViewModel.swift
//  CarWarningLight
//
//  Created by Sam Greenhill on 4/27/25.
//  Copyright © 2025 simplyAmazingMachines. All rights reserved.
//

import Foundation

class ResultsViewModel: ObservableObject {

    @Published var selectedIndex: Int? = nil
    @Published var isShowingLarge: Bool = false
    let bigImageId: Int = -1


}
