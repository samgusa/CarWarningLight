//
//  ImageView.swift
//  CarWarningLight
//
//  Created by Sam Greenhill on 4/26/25.
//  Copyright © 2025 simplyAmazingMachines. All rights reserved.
//

import SwiftUI

struct ImageView: View {
    var carImg: String
    var body: some View {
        Image(carImg)
    }
}

#Preview {
    ImageView(carImg: "")
}
