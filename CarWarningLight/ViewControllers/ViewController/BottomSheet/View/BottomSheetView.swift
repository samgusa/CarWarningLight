import Foundation
import UIKit
import Combine

final class BottomSheetView: UIView {

    var hiddenValueSubject = CurrentValueSubject<Bool, Never>(true)

    var cancellables = Set<AnyCancellable>()

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

    lazy var upImage: UIImageView = {
        let img = UIImageView()
        img.translatesAutoresizingMaskIntoConstraints = false
        img.contentMode = .scaleAspectFit
        img.tintColor = .white
        return img
    }()

    lazy var containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .systemBackground
        view.layer.cornerRadius = 16
        view.clipsToBounds = true
        return view
    }()

    let maxDimmedAlpha: CGFloat = 0.6

    lazy var dimmedView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .black
        view.alpha = maxDimmedAlpha
        return view
    }()

    let defaultHeight: CGFloat = 400
    let dismissableHeight: CGFloat = 200
    let maximumContainerHeight: CGFloat = UIScreen.main.bounds.height - 64
    var currentContainerHeight: CGFloat = 300

    var containerViewHeightConstraint: NSLayoutConstraint?
    var containerViewBottomConstraint: NSLayoutConstraint?

    init() {
        super.init(frame: .zero)

        mainSetup()
        self.backgroundColor = .clear
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func mainSetup() {
        self.addSubview(dimmedView)
        self.addSubview(upImage)
        self.addSubview(containerView)
        self.containerView.addSubview(topBar)
        self.containerView.addSubview(lowView)
        self.containerView.addSubview(highView)

        let largeFont = UIFont.boldSystemFont(ofSize: 25)
        let configuration = UIImage.SymbolConfiguration(font: largeFont)

        hiddenValueSubject
            .sink { [weak self] bool in
                guard let self = self else { return }
                self.lowView.isHidden = !bool
                self.highView.isHidden = bool
                self.upImage.image = bool ? UIImage(systemName: "arrow.up", withConfiguration: configuration) : UIImage(systemName: "arrow.down", withConfiguration: configuration)
            }
            .store(in: &cancellables)

        NSLayoutConstraint.activate([
            dimmedView.topAnchor.constraint(equalTo: self.topAnchor),
            dimmedView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            dimmedView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            dimmedView.bottomAnchor.constraint(equalTo: self.bottomAnchor),

            upImage.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            upImage.bottomAnchor.constraint(equalTo: containerView.topAnchor, constant: -10),

            containerView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: self.trailingAnchor),

            topBar.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 10),
            topBar.heightAnchor.constraint(equalToConstant: 5),
            topBar.widthAnchor.constraint(equalTo: containerView.widthAnchor, multiplier: 0.2),
            topBar.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),

            lowView.centerXAnchor.constraint(equalTo: self.containerView.centerXAnchor),
            lowView.centerYAnchor.constraint(equalTo: self.containerView.centerYAnchor),
            lowView.heightAnchor.constraint(equalTo: self.containerView.heightAnchor, multiplier: 0.8),
            lowView.widthAnchor.constraint(equalTo: self.containerView.widthAnchor, multiplier: 0.9),

            highView.centerXAnchor.constraint(equalTo: self.containerView.centerXAnchor),
            highView.centerYAnchor.constraint(equalTo: self.containerView.centerYAnchor),
            highView.topAnchor.constraint(equalTo: self.topBar.bottomAnchor, constant: 10),
            highView.widthAnchor.constraint(equalTo: self.containerView.widthAnchor, multiplier: 0.9)
        ])

        self.containerViewHeightConstraint = self.containerView.heightAnchor.constraint(equalToConstant: self.defaultHeight)

        self.containerViewBottomConstraint = self.containerView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: self.defaultHeight)

        self.containerViewBottomConstraint?.isActive = true
        self.containerViewHeightConstraint?.isActive = true
    }

}
