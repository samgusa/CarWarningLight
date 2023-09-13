import UIKit

final class LowBottomView: UIView {

    lazy var warningLbl: UILabel = {
        let lbl = UILabel()
        lbl.font = UIFont.boldSystemFont(ofSize: 30.0)
        lbl.textColor = .white
        lbl.clipsToBounds = true
        lbl.layer.cornerRadius = 10
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.backgroundColor = .systemRed
        lbl.textAlignment = .center
        lbl.text = "Warning"
        lbl.numberOfLines = 1
        lbl.adjustsFontSizeToFitWidth = true

        return lbl
    }()


    lazy var warningData: UILabel = {
      let lbl = UILabel()
      lbl.font = UIFont.boldSystemFont(ofSize: 15.0)
      lbl.textColor = .label
      lbl.clipsToBounds = true
      lbl.layer.cornerRadius = 10
      lbl.translatesAutoresizingMaskIntoConstraints = false
      lbl.textAlignment = .left
      lbl.numberOfLines = 0
      lbl.adjustsFontSizeToFitWidth = true
      return lbl
    }()

    lazy var advisoryLbl: UILabel = {
      let lbl = UILabel()
      lbl.font = UIFont.boldSystemFont(ofSize: 30.0)
      lbl.textColor = .white
      lbl.clipsToBounds = true
      lbl.layer.cornerRadius = 10
      lbl.translatesAutoresizingMaskIntoConstraints = false
      lbl.backgroundColor = .systemOrange
      lbl.textAlignment = .center
      lbl.text = "Advisory"
      lbl.numberOfLines = 1
      lbl.adjustsFontSizeToFitWidth = true
      return lbl
    }()

    lazy var advisoryData: UILabel = {
      let lbl = UILabel()
      lbl.font = UIFont.boldSystemFont(ofSize: 15.0)
      lbl.textColor = .label
      lbl.clipsToBounds = true
      lbl.layer.cornerRadius = 10
      lbl.translatesAutoresizingMaskIntoConstraints = false
      lbl.textAlignment = .left
      lbl.numberOfLines = 0
      lbl.adjustsFontSizeToFitWidth = true
      return lbl
    }()

    lazy var infoLbl: UILabel = {
      let lbl = UILabel()
      lbl.font = UIFont.boldSystemFont(ofSize: 30.0)
      lbl.textColor = .white
      lbl.clipsToBounds = true
      lbl.layer.cornerRadius = 10
      lbl.translatesAutoresizingMaskIntoConstraints = false
      lbl.backgroundColor = .systemGreen
      lbl.textAlignment = .center
      lbl.text = "Information"
      lbl.numberOfLines = 1
      lbl.adjustsFontSizeToFitWidth = true
      return lbl
    }()

    lazy var infoData: UILabel = {
      let lbl = UILabel()
      lbl.font = UIFont.boldSystemFont(ofSize: 15.0)
      lbl.textColor = .label
      lbl.clipsToBounds = true
      lbl.layer.cornerRadius = 10
      lbl.translatesAutoresizingMaskIntoConstraints = false
      lbl.textAlignment = .left
      lbl.numberOfLines = 0
      lbl.adjustsFontSizeToFitWidth = true
      return lbl
    }()

    lazy var warningStack: UIStackView = {
      let stack = UIStackView()
      stack.translatesAutoresizingMaskIntoConstraints = false
      stack.axis = .horizontal
      stack.distribution = .fillProportionally
      stack.spacing = 20
      return stack
    }()

    lazy var advisoryStack: UIStackView = {
      let stack = UIStackView()
      stack.translatesAutoresizingMaskIntoConstraints = false
      stack.axis = .horizontal
      stack.spacing = 20
      return stack
    }()

    lazy var infoStack: UIStackView = {
      let stack = UIStackView()
      stack.translatesAutoresizingMaskIntoConstraints = false
      stack.axis = .horizontal
      stack.spacing = 20
      return stack
    }()

    lazy var mainStack: UIStackView = {
      let stack = UIStackView()
      stack.translatesAutoresizingMaskIntoConstraints = false
      stack.axis = .vertical
      stack.distribution = .fillEqually
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
        [warningLbl, warningData]
            .forEach { warningStack.addArrangedSubview($0) }
        [advisoryLbl, advisoryData]
            .forEach { advisoryStack.addArrangedSubview($0) }
        [infoLbl, infoData]
            .forEach { infoStack.addArrangedSubview($0) }

        [warningStack, advisoryStack, infoStack]
            .forEach { mainStack.addArrangedSubview($0) }

        NSLayoutConstraint.activate([
            mainStack.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            mainStack.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            mainStack.heightAnchor.constraint(equalTo: self.heightAnchor),
            mainStack.widthAnchor.constraint(equalTo: self.widthAnchor),
        ])
    }

}

