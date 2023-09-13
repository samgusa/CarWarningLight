import UIKit
import Combine

class BottomSheetViewController: UIViewController {

    var rootView = BottomSheetView()

    var viewModel = BottomSheetViewModel()

    var cancellables = Set<AnyCancellable>()

    override func loadView() {

        self.view = rootView
        setUpPanGesture()
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(animateDismissView))
        self.rootView.dimmedView.addGestureRecognizer(tapGesture)

        viewModel.fetchInfo()
            .sink { [weak self] info in
                guard let self = self else { return }
                print("INFO: \(info)")
//                self.rootView.lowView.warningData.text = self.viewModel.infoFilter(arr: info, info: .warning)
//                self.rootView.lowView.advisoryData.text = self.viewModel.infoFilter(arr: info, info: .advisory)
//                self.rootView.lowView.infoData.text = self.viewModel.infoFilter(arr: info, info: .info)
            }
            .store(in: &cancellables)

        //otherFilter()
    }
    

}
//
//import UIKit

//class BottomSheetViewController: UIViewController {
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//        // Set a semi-transparent background color
//        view.backgroundColor = UIColor.black.withAlphaComponent(0.7)
//
//        // Create and add UI elements (e.g., labels, buttons)
//        let titleLabel = UILabel()
//        titleLabel.text = "Modal Title"
//        titleLabel.textColor = .white
//
//        let closeButton = UIButton()
//        closeButton.setTitle("Close", for: .normal)
//        closeButton.addTarget(self, action: #selector(closeButtonTapped), for: .touchUpInside)
//
//        // Add elements to the view and configure layout
//        view.addSubview(titleLabel)
//        view.addSubview(closeButton)
//
//        titleLabel.translatesAutoresizingMaskIntoConstraints = false
//        closeButton.translatesAutoresizingMaskIntoConstraints = false
//
//        NSLayoutConstraint.activate([
//            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
//            titleLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),
//
//            closeButton.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20),
//            closeButton.centerXAnchor.constraint(equalTo: view.centerXAnchor)
//        ])
//    }
//
//    @objc func closeButtonTapped() {
//        dismiss(animated: true, completion: nil)
//    }
//}
