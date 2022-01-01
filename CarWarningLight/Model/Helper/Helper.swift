//
//  Helper.swift
//  CarWarningLight
//
//  Created by Sam Greenhill on 10/12/20.
//  Copyright © 2020 simplyAmazingMachines. All rights reserved.
//

import Foundation
import UIKit

/*Helper:
 shadowSetUp, caseTesting-lbl-image-color, hexstring-color, DefaultStyle-colors, setBlur, drivableTxtData-view-vc, 
*/

struct GlobalArr {
    static var otherArr = [TestArr]()
}

extension UIView {
    
    func shadowSetUp() {
        self.layer.masksToBounds = false
        self.layer.shadowColor = UIColor.black.withAlphaComponent(0.1).cgColor
        self.layer.shadowOpacity = 1
        self.layer.shadowOffset =
            .zero
        self.layer.shadowRadius = 15
        self.layer.shadowPath = UIBezierPath(rect: self.bounds).cgPath
        self.layer.shouldRasterize = true
        self.layer.rasterizationScale = UIScreen.main.scale
    }
}

extension UILabel {
    func caseTesting(str: String) -> UIColor {
        switch str {
        case "WARNING":
            return UIColor.systemRed
        case "ADVISORY":
            return UIColor.systemOrange
        case "INFORMATION":
            return UIColor.systemGreen
        default:
            return UIColor.label
        }
    }
}

extension UIImage {
    
    func caseTesting(str: String) -> UIColor {
        switch str {
        case "WARNING":
            return UIColor.systemRed
        case "ADVISORY":
            return UIColor.systemOrange
        case "INFORMATION":
            return UIColor.systemGreen
        default:
            return UIColor.label
        }
    }
}

extension UIColor {
    func caseTesting(str: String) -> UIColor {
        switch str {
        case "WARNING":
            return UIColor.systemRed
        case "ADVISORY":
            return UIColor.systemOrange
        case "INFORMATION":
            return UIColor.systemGreen
        default:
            return UIColor.label
        }
    }
}

//MARK: Colors
extension UIColor {
    convenience init(hexString: String, alpha: CGFloat = 1) {
        assert(hexString[hexString.startIndex] == "#", "Expected hex string of format #RRGGBB")
        
        let scanner = Scanner(string: hexString)
        scanner.currentIndex = scanner.string.index(after: scanner.currentIndex)
        
        var rgb: UInt64 = 0
        scanner.scanHexInt64(&rgb)
        
        self.init(
            red:   CGFloat((rgb & 0xFF0000) >> 16)/255.0,
            green: CGFloat((rgb &   0xFF00) >>  8)/255.0,
            blue:  CGFloat((rgb &     0xFF)      )/255.0,
            alpha: alpha)
    }
}

public enum DefaultStyle {
    
    public enum Colors {
        public static let views: UIColor = {
            if #available(iOS 13, *) {
                return UIColor { (traitCollection: UITraitCollection) -> UIColor in
                    if traitCollection.userInterfaceStyle == .dark {
                        
                        return UIColor(hexString:"#151515")
                    } else {
                        return UIColor.systemBackground
                    }
                }
            } else {
                return UIColor.systemBackground
            }
        }()
        
        public static let views2: UIColor = {
            if #available(iOS 13, *) {
                return UIColor { (traitCollection: UITraitCollection) -> UIColor in
                    if traitCollection.userInterfaceStyle == .dark {
                        
                        return UIColor.systemGray5
                    } else {
                        return UIColor(hexString:"#F2F2F2")
                    }
                }
            } else {
                return UIColor(hexString:"#F2F2F2")
            }
        }()
    }
}

extension UIViewController {
    func setBlur(blur: UIVisualEffectView, base: UIView) {
        blur.frame = base.frame
        blur.effect = UIBlurEffect(style: .regular)
        blur.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        base.addSubview(blur)
    }
}

extension UIViewController {
    
    func drivableTxtData(str: String) -> String {
        switch str {
        case "No":
            return "NO! You should not drive with this light on. \n"
        case "Yes":
            return "YES. It is safe to drive, but if you have any questions ask your mechanic \n"
        case "Uncertain":
            return "It is UNCERTAIN at this time. Consult your manual or your mechanic. \n"
        default:
            return "There was a problem"
        }
    }
}

extension UIView {
    func drivableTxtData(str: String) -> String {
        switch str {
        case "No":
            return "NO! You should not drive with this light on. \n"
        case "Yes":
            return "YES. It is safe to drive, but if you have any questions ask your mechanic \n"
        case "Uncertain":
            return "It is UNCERTAIN at this time. Consult your manual or your mechanic. \n"
        default:
            return "There was a problem"
        }
    }
}
