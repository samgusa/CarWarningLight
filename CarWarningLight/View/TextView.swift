//
//  TextView.swift
//  CarWarningLight
//
//  Created by Sam Greenhill on 9/18/23.
//  Copyright © 2023 simplyAmazingMachines. All rights reserved.
//

import Foundation
import UIKit

final class TextView: UIView {

    lazy var nameLbl: UILabel = {
        let lbl = UILabel()
        lbl.font = UIFont.boldSystemFont(ofSize: 15.0)
        lbl.textColor = .black
        lbl.clipsToBounds = true
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.textAlignment = .left
        lbl.numberOfLines = 0
        lbl.adjustsFontSizeToFitWidth = true
        return lbl
    }()

    lazy var backgroundView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .systemBackground
        return view
    }()

    init() {
        super.init(frame: .zero)
        self.setUpView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setUpView() {
        self.addSubview(backgroundView)
        backgroundView.addSubview(nameLbl)

        NSLayoutConstraint.activate([
            backgroundView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            backgroundView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            backgroundView.heightAnchor.constraint(equalTo: self.heightAnchor),
            backgroundView.widthAnchor.constraint(equalTo: self.widthAnchor),
            nameLbl.centerXAnchor.constraint(equalTo: backgroundView.centerXAnchor),
            nameLbl.centerYAnchor.constraint(equalTo: backgroundView.centerYAnchor),
            nameLbl.leadingAnchor.constraint(equalTo: backgroundView.leadingAnchor, constant: 5),
            nameLbl.trailingAnchor.constraint(equalTo: backgroundView.trailingAnchor, constant: -5),
            nameLbl.topAnchor.constraint(equalTo: backgroundView.topAnchor, constant: 5),
            nameLbl.bottomAnchor.constraint(equalTo: backgroundView.bottomAnchor, constant: -5),

        ])

    }

}

