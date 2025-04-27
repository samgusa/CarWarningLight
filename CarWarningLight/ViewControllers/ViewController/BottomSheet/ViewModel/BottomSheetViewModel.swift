import Foundation
import Combine
import UIKit

final class BottomSheetViewModel {

  var warningSubject = PassthroughSubject<[String], Never>()
  var advisorySubject = PassthroughSubject<[String], Never>()
  var infoSubject = PassthroughSubject<[String], Never>()

  private var cancellables = Set<AnyCancellable>()

    func fetchData() -> Future<[CarDatum], Never> {
      return Future { promise in
        let bundleLight: [CarDatum] = Bundle.main.decode([CarDatum].self, from: "carLights.json")
        promise(.success(bundleLight))
      }
    }

    func buildView(lightArr: [String], stack: UIStackView, _ systemColor: SymbolType) {
      for (index, element) in lightArr.enumerated() {
        let lightImg: UIImageView = {
          let img = UIImageView()
          img.translatesAutoresizingMaskIntoConstraints = false
          img.image = UIImage(named: element)
          img.contentMode = .scaleAspectFit
          img.tintColor = systemColor.symbolColor
          img.layer.cornerRadius = 5
          img.tag = index
          return img
        }()
        stack.addArrangedSubview(lightImg)
      }
    }

    func fetchInfo() -> Future<[Section], Never> {
      return Future { promise in
        let sections = Bundle.main.decode([Section].self, from: "car.json")
        promise(.success(sections))
      }
    }

    func infoFilter(sections: [Section], info: InfoEnum) -> String {
        // Flatten the sections into a single array of InfoData
        let allInfoData = sections.flatMap { $0.data }

        // Filter and map the InfoData based on the InfoEnum
        let filteredInfoData = allInfoData.filter { $0.name == info.infoName }

        // Join the filtered InfoData's 'data' properties into a single string
        return filteredInfoData.map { $0.data }.joined()
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
}

