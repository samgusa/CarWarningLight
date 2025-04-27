//
//  TestingViewController.swift
//  CarWarningLight
//
//  Created by Sam Greenhill on 10/18/20.
//  Copyright © 2020 simplyAmazingMachines. All rights reserved.
//

import UIKit
import Combine
//GOOD

//MAIN View
class TestingViewController: UIViewController {

    let childView = CollectionChildView()

    var rootView = MainView()
    
    let infoView = InfoDataView()
    
    let infoBtn = InfoBtn()
    
    var blurPressed = false
    
    let blursView = UIVisualEffectView()
    
    var floatBtn: FloatingButton!
    
    var colors = DefaultStyle.self

    var infoDataSubject = PassthroughSubject<Void, Never>()

    var viewModel = MainViewModel()

    var carLightSubject = CurrentValueSubject<CarData, Never>([])

    var cancellables = Set<AnyCancellable>()
    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        self.view.backgroundColor = colors.Colors.views2
//        navigationItem.title = "Warning Light Camera"
//        setUpInfoBtn()
//        childSetUp()
//        setUpFloatingBtn()
//    }

    override func loadView() {
        self.view = rootView
        rootView.collectionView.delegate = self
        rootView.collectionView.dataSource = self
        navigationItem.title = "Warning Light Camera"
        setupCombine()
        setUpInfoBtn()
    }

    func setupCombine() {
        viewModel.fetchData()
            .sink { completion in
                switch completion {
                case .finished:
                    print("Worked")
                case .failure(let error):
                    print(error)
                }
            } receiveValue: { [weak self] carLights in
                self?.carLightSubject.send(carLights)
            }
            .store(in: &cancellables)
    }
    
    //MARK: Set up tableView
//    func childSetUp() {
//        addChild(childView)
//        view.addSubview(childView.view)
//        childView.didMove(toParent: self)
//        childView.view.translatesAutoresizingMaskIntoConstraints = false
//        childView.view.backgroundColor = colors.Colors.views2
//
//        NSLayoutConstraint.activate([
//            childView.view.topAnchor.constraint(equalTo: self.view.topAnchor),
//            childView.view.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
//            childView.view.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
//            childView.view.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
//        ])
//    }
    
    //MARK: Sets up Info Btn
    func setUpInfoBtn() {
        let customBtn = UIBarButtonItem()
        customBtn.image = UIImage(systemName: "info.circle")
        customBtn.tintColor = .black
        customBtn.target = self
        customBtn.action = #selector(infoBtnPressed)
        navigationItem.rightBarButtonItem = customBtn
        infoDataSubject
          .sink { [weak self] _ in
            let vc = BottomSheetViewController()
            vc.modalPresentationStyle = .overCurrentContext
            self?.present(vc, animated: false)
          }
          .store(in: &cancellables)
    }

    @objc func infoBtnPressed() {
      infoDataSubject.send()
    }
    
    //MARK: Presents infoview when infoBtn pressed
//    func presentInfoView() {
//        blurPressed = !blurPressed
//        floatBtn.hideBlur()
//        floatBtn.active = false
//
//        infoView.translatesAutoresizingMaskIntoConstraints = false
//        if blurPressed {
//            self.navigationItem.title = "Light Types"
//            self.setBlur(blur: blursView, base: self.view)
//            self.view.addSubview(infoView)
//            NSLayoutConstraint.activate([
//                infoView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
//                infoView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.9),
//                infoView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.8),
//                infoView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 30)
//            ])
//
//            infoView.layer.cornerRadius = 15
//            infoView.clipsToBounds = true
//            infoView.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
//            infoView.alpha = 0
//            UIView.animate(withDuration: 0.6, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0, options: [], animations: {
//                self.infoView.alpha = 1
//                self.infoView.transform = .identity
//            })
//        } else {
//            self.animateOut()
//        }
//    }

//    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//        let touch: UITouch? = touches.first
//        if touch?.view != infoView {
//            super.touchesEnded(touches, with: event)
//            self.animateOut()
//        }
//    }
    
//    func animateOut() {
//        UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0, options: [], animations: {
//            self.infoView.transform = CGAffineTransform.init(scaleX: 0.2, y: 0.2)
//            self.infoView.alpha = 0
//        })
//        blurPressed = false
//        self.navigationItem.title = "Warning Light Camera"
//        self.blursView.removeFromSuperview()
//    }
}
