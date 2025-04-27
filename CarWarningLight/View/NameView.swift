//
//  NameView.swift
//  CarWarningLight
//
//  Created by Sam Greenhill on 9/18/23.
//  Copyright © 2023 simplyAmazingMachines. All rights reserved.
//

import Foundation
import UIKit

final class NameView: UIView {

    public var infoEnum: InfoEnum = .warning
    public var infoLight: Bool = false

    lazy var nameLbl: UILabel = {
        let lbl = UILabel()
        lbl.font = UIFont.boldSystemFont(ofSize: 30.0)
        lbl.textColor = .white
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.textAlignment = .center
        lbl.text = infoLight ? infoEnum.infoLights : infoEnum.infoName
        lbl.numberOfLines = infoLight ? 2 : 1
        lbl.adjustsFontSizeToFitWidth = true

        return lbl
    }()



    lazy var backgroundView: UIView = {
        let view = UIView()
        view.clipsToBounds = true
        view.layer.cornerRadius = 10
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = infoEnum.infoColor
        return view
    }()

    init(infoEnum: InfoEnum, infoLight: Bool = false) {
        super.init(frame: .zero)
        self.infoEnum = infoEnum
        self.infoLight = infoLight
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
            nameLbl.leadingAnchor.constraint(equalTo: backgroundView.leadingAnchor, constant: 7),
            nameLbl.trailingAnchor.constraint(equalTo: backgroundView.trailingAnchor, constant: -7)
        ])

    }

}

