import Foundation
import UIKit

final class HighBottomView: UIView {

    lazy var warningScroll: UIScrollView = {
        let scroll = UIScrollView()
        scroll.translatesAutoresizingMaskIntoConstraints = false
        scroll.backgroundColor = .systemBackground
        scroll.isScrollEnabled = true
        return scroll
    }()

    lazy var advisoryScroll: UIScrollView = {
        let scroll = UIScrollView()
        scroll.translatesAutoresizingMaskIntoConstraints = false
        scroll.backgroundColor = .systemBackground
        scroll.isScrollEnabled = true
        return scroll
    }()

    lazy var infoScroll: UIScrollView = {
        let scroll = UIScrollView()
        scroll.translatesAutoresizingMaskIntoConstraints = false
        scroll.backgroundColor = .systemBackground
        scroll.isScrollEnabled = true
        return scroll
    }()

    lazy var warningNameView: NameView = {
        let view = NameView(infoEnum: .warning, infoLight: true)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    lazy var advisoryNameView: NameView = {
        let view = NameView(infoEnum: .advisory, infoLight: true)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    lazy var infoNameView: NameView = {
        let view = NameView(infoEnum: .info, infoLight: true)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    lazy var warningStack: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.spacing = 20
        return stack
    }()

    lazy var advisoryStack: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.spacing = 20
        return stack
    }()

    lazy var infoStack: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.spacing = 20
        return stack
    }()

    lazy var mainStack: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .horizontal
        stack.distribution = .fillProportionally
        stack.spacing = 10
        return stack
    }()

    lazy var warningImgStack: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.spacing = 20
        return stack
    }()

    lazy var advisoryImgStack: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.spacing = 20
        return stack
    }()

    lazy var infoImgStack: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.spacing = 20
        return stack
    }()

    init() {
        super.init(frame: .zero)
        setup()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setup() {
        self.addSubview(mainStack)

        [warningNameView, warningImgStack]
            .forEach { warningStack.addArrangedSubview($0) }
        [advisoryNameView, advisoryImgStack]
            .forEach { advisoryStack.addArrangedSubview($0) }
        [infoNameView, infoImgStack]
            .forEach { infoStack.addArrangedSubview($0) }

        warningScroll.addSubview(warningStack)
        advisoryScroll.addSubview(advisoryStack)
        infoScroll.addSubview(infoStack)

        [warningScroll, advisoryScroll, infoScroll]
            .forEach { mainStack.addArrangedSubview($0) }

        NSLayoutConstraint.activate([
            mainStack.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            mainStack.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            mainStack.topAnchor.constraint(equalTo: self.topAnchor, constant: 10),
            mainStack.widthAnchor.constraint(equalTo: self.widthAnchor),

            warningNameView.widthAnchor.constraint(equalTo: warningStack.widthAnchor),
            warningNameView.heightAnchor.constraint(equalTo: mainStack.heightAnchor, multiplier: 0.1),

            advisoryNameView.widthAnchor.constraint(equalTo: advisoryStack.widthAnchor),
            advisoryNameView.heightAnchor.constraint(equalTo: mainStack.heightAnchor, multiplier: 0.1),

            infoNameView.widthAnchor.constraint(equalTo: infoStack.widthAnchor),
            infoNameView.heightAnchor.constraint(equalTo: mainStack.heightAnchor, multiplier: 0.1),

            warningStack.widthAnchor.constraint(equalTo: warningScroll.widthAnchor),
            advisoryStack.widthAnchor.constraint(equalTo: advisoryScroll.widthAnchor),
            infoStack.widthAnchor.constraint(equalTo: infoScroll.widthAnchor),

            warningScroll.topAnchor.constraint(equalTo: warningStack.topAnchor),
            warningScroll.bottomAnchor.constraint(equalTo: warningStack.bottomAnchor),

            advisoryScroll.topAnchor.constraint(equalTo: advisoryStack.topAnchor),
            advisoryScroll.bottomAnchor.constraint(equalTo: advisoryStack.bottomAnchor),

            infoScroll.topAnchor.constraint(equalTo: infoStack.topAnchor),
            infoScroll.bottomAnchor.constraint(equalTo: infoStack.bottomAnchor)
        ])
    }
}
