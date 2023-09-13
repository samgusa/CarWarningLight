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

  lazy var warningLbl: PaddingLabel = {
    let lbl = PaddingLabel()
    lbl.font = UIFont.boldSystemFont(ofSize: 30.0)
    lbl.textColor = .white
    lbl.clipsToBounds = true
    lbl.layer.cornerRadius = 10
    lbl.translatesAutoresizingMaskIntoConstraints = false
    lbl.backgroundColor = .systemRed
    lbl.textAlignment = .center
    lbl.text = "Warning Lights"
    lbl.numberOfLines = 2
    lbl.adjustsFontSizeToFitWidth = true
    return lbl
  }()

  lazy var advisoryLbl: PaddingLabel = {
    let lbl = PaddingLabel()
    lbl.font = UIFont.boldSystemFont(ofSize: 30.0)
    lbl.textColor = .white
    lbl.clipsToBounds = true
    lbl.layer.cornerRadius = 10
    lbl.translatesAutoresizingMaskIntoConstraints = false
    lbl.backgroundColor = .systemOrange
    lbl.textAlignment = .center
    lbl.text = "Advisory Lights"
    lbl.numberOfLines = 2
    lbl.adjustsFontSizeToFitWidth = true
    return lbl
  }()

  lazy var infoLbl: PaddingLabel = {
    let lbl = PaddingLabel()
    lbl.font = UIFont.boldSystemFont(ofSize: 30.0)
    lbl.textColor = .white
    lbl.clipsToBounds = true
    lbl.layer.cornerRadius = 10
    lbl.translatesAutoresizingMaskIntoConstraints = false
    lbl.backgroundColor = .systemGreen
    lbl.textAlignment = .center
    lbl.text = "Information Lights"
    lbl.numberOfLines = 2
    lbl.adjustsFontSizeToFitWidth = true
    return lbl
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

    [warningLbl, warningImgStack]
      .forEach { warningStack.addArrangedSubview($0) }
    [advisoryLbl, advisoryImgStack]
      .forEach { advisoryStack.addArrangedSubview($0) }
    [infoLbl, infoImgStack]
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
      warningLbl.widthAnchor.constraint(equalTo: infoLbl.widthAnchor),
      advisoryLbl.widthAnchor.constraint(equalTo: infoLbl.widthAnchor),
      advisoryLbl.heightAnchor.constraint(equalTo: warningLbl.heightAnchor),
      infoLbl.heightAnchor.constraint(equalTo: warningLbl.heightAnchor),
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
