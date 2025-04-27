//
//  BottomMainView.swift
//  CarWarningLight
//
//  Created by Sam Greenhill on 9/18/23.
//  Copyright © 2023 simplyAmazingMachines. All rights reserved.
//

import Foundation
import UIKit
import Combine

final class BottomMainView: UIView {

    // Constants
    let maxDimmedAlpha: CGFloat = 0.6
    let defaultHeight: CGFloat = 300
    let dismissibleHeight: CGFloat = 200
    let maximumContainerHeight: CGFloat = UIScreen.main.bounds.height - 64
    // keep current new height, initial is default height
    var currentContainerHeight: CGFloat = 300

    // Dynamic container constraint
    var containerViewHeightConstraint: NSLayoutConstraint?
    var containerViewBottomConstraint: NSLayoutConstraint?

    // Combine Values:

    func fetchInfo() -> Future<[Section], Never> {
      return Future { promise in
        let sections = Bundle.main.decode([Section].self, from: "car.json")
        promise(.success(sections))
      }
    }

    func fetchData() -> Future<[CarDatum], Never> {
      return Future { promise in
        let bundleLight: [CarDatum] = Bundle.main.decode([CarDatum].self, from: "carLights.json")
        promise(.success(bundleLight))
      }
    }

    func fetchInfoData() {
      fetchData()
        .sink { [weak self] data in
          guard let self = self else { return }
          let warningLights = data.filter { $0.symbolType == .warning }
            .map { $0.image }
          let advisoryLights = data.filter { $0.symbolType == .advisory }
            .map { $0.image }
          let infoLights = data.filter { $0.symbolType == .info }
            .map { $0.image }

          self.warningSubject.send(warningLights)
          self.advisorySubject.send(advisoryLights)
          self.infoSubject.send(infoLights)
        }
        .store(in: &cancellables)
    }

    var hiddenValueSubject = CurrentValueSubject<Bool, Never>(true)

    var warningSubject = PassthroughSubject<[String], Never>()
    var advisorySubject = PassthroughSubject<[String], Never>()
    var infoSubject = PassthroughSubject<[String], Never>()

    private var cancellables = Set<AnyCancellable>()

    lazy var topBar: UIView = {
      let view = UIView()
      view.translatesAutoresizingMaskIntoConstraints = false
      view.backgroundColor = .label
      view.layer.cornerRadius = 3.0
      view.clipsToBounds = true
      return view
    }()

    lazy var lowView: LowBottomView = {
        let view = LowBottomView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    lazy var highView: HighBottomView = {
        let view = HighBottomView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    lazy var directionImage: UIImageView = {
      let img = UIImageView()
      img.translatesAutoresizingMaskIntoConstraints = false
      img.contentMode = .scaleAspectFit
      img.tintColor = .white
      return img
    }()

    lazy var containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 16
        view.clipsToBounds = true
        return view
    }()

    lazy var dimmedView: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        view.alpha = maxDimmedAlpha
        return view
    }()

    init() {
        super.init(frame: .zero)
        self.backgroundColor = .clear
        self.setupConstraints()
    }

    required init?(coder: NSCoder) {
      fatalError("init(coder:) has not been implemented")
    }

    func setupConstraints() {
        self.addSubview(dimmedView)
        self.addSubview(directionImage)
        self.addSubview(containerView)
        dimmedView.translatesAutoresizingMaskIntoConstraints = false
        containerView.translatesAutoresizingMaskIntoConstraints = false

        containerView.addSubview(topBar)
        containerView.addSubview(lowView)
        containerView.addSubview(highView)
        lowView.translatesAutoresizingMaskIntoConstraints = false
        highView.translatesAutoresizingMaskIntoConstraints = false

        // Set static constraints
        NSLayoutConstraint.activate([
            // set dimmedView edges to superview
            dimmedView.topAnchor.constraint(equalTo: self.topAnchor),
            dimmedView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            dimmedView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            dimmedView.trailingAnchor.constraint(equalTo: self.trailingAnchor),

            directionImage.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            directionImage.bottomAnchor.constraint(equalTo: containerView.topAnchor, constant: -10),

            topBar.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 10),
            topBar.heightAnchor.constraint(equalToConstant: 5),
            topBar.widthAnchor.constraint(equalTo: containerView.widthAnchor, multiplier: 0.2),
            topBar.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),

            // set container static constraint (trailing & leading)
            containerView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            // content stackView
            lowView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 32),
            lowView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -20),
            lowView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20),
            lowView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -20),

            highView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 32),
            highView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -20),
            highView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20),
            highView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -20),
        ])
        containerViewHeightConstraint = containerView.heightAnchor.constraint(equalToConstant: defaultHeight)
        containerViewBottomConstraint = containerView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: defaultHeight)
        containerViewHeightConstraint?.isActive = true
        containerViewBottomConstraint?.isActive = true
    }

}
