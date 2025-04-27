import UIKit

final class LowBottomView: UIView {

    lazy var warningNameView: NameView = {
        let view = NameView(infoEnum: .warning)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    lazy var warningTextView: TextView = {
        let view = TextView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    lazy var advisoryNameView: NameView = {
        let view = NameView(infoEnum: .advisory)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    lazy var advisoryTextView: TextView = {
        let view = TextView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    lazy var infoNameView: NameView = {
        let view = NameView(infoEnum: .info)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    lazy var infoTextView: TextView = {
        let view = TextView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    lazy var warningStack: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .horizontal
        stack.distribution = .fillProportionally
        stack.isLayoutMarginsRelativeArrangement = true
        stack.spacing = 20
        return stack
    }()

    lazy var advisoryStack: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .horizontal
        stack.distribution = .fillProportionally
        stack.isLayoutMarginsRelativeArrangement = true
        stack.spacing = 20
        return stack
    }()

    lazy var infoStack: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .horizontal
        stack.distribution = .fillProportionally
        stack.isLayoutMarginsRelativeArrangement = true
        stack.spacing = 20
        return stack
    }()

    lazy var mainStack: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.distribution = .fillEqually
        stack.isLayoutMarginsRelativeArrangement = true
        stack.spacing = 10
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
        [warningNameView, warningTextView]
            .forEach { warningStack.addArrangedSubview($0) }
        [advisoryNameView, advisoryTextView]
            .forEach { advisoryStack.addArrangedSubview($0) }
        [infoNameView, infoTextView]
            .forEach { infoStack.addArrangedSubview($0) }

        [warningStack, advisoryStack, infoStack]
            .forEach { mainStack.addArrangedSubview($0) }

        NSLayoutConstraint.activate([
            mainStack.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            mainStack.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            mainStack.heightAnchor.constraint(equalTo: self.heightAnchor),
            mainStack.widthAnchor.constraint(equalTo: self.widthAnchor),
            mainStack.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            warningNameView.widthAnchor.constraint(equalTo: mainStack.widthAnchor, multiplier: 0.3),
            advisoryNameView.widthAnchor.constraint(equalTo: mainStack.widthAnchor, multiplier: 0.3),
            infoNameView.widthAnchor.constraint(equalTo: mainStack.widthAnchor, multiplier: 0.3)
        ])
    }

}

