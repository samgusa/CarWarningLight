//
//  ResultsViewModel.swift
//  CarWarningLight
//
//  Created by Sam Greenhill on 4/27/25.
//  Copyright © 2025 simplyAmazingMachines. All rights reserved.
//

import Foundation
import SwiftUI

class ResultsViewModel: ObservableObject {

    @Published var selectedIndex: Int? = nil
    @Published var isShowingLarge: Bool = false
    @Published var loadingState: LoadingState = .ready

    let bigImageId: Int = -1


    enum LoadingState {
        case loading, ready, error(String)
    }

    func dismissDetail() {
        withAnimation(.spring(response: 0.35, dampingFraction: 0.8)) {
            isShowingLarge = false
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) { [weak self] in
            self?.selectedIndex = nil
        }
    }

    

}
