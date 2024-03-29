//
//  Auxiliary.swift
//  BeeBants
//
//  Created by António Ferreira on 02/04/2020.
//  Copyright © 2020 BeeBants. All rights reserved.
//

import Foundation
import UIKit
import GoogleMobileAds



extension UIView {
    var textFieldsInView: [UITextField] {
        return subviews
            .filter ({ !($0 is UITextField) })
            .reduce (( subviews.compactMap { $0 as? UITextField }), { summ, current in
                return summ + current.textFieldsInView
        })
    }
    var selectedTextField: UITextField? {
        return textFieldsInView.filter { $0.isFirstResponder }.first
    }
}

extension UIView {
    func shake() {
        let animation = CAKeyframeAnimation()
        animation.keyPath = "position.x"
        animation.values = [0, 10, -10, 10, 0]
        animation.keyTimes = [NSNumber(value: 0), NSNumber(value: 1/6.0), NSNumber(value: 3/6.0), NSNumber(value: 5/6.0), NSNumber(value: 1)]
        animation.duration = 0.4
        animation.isAdditive = true
        self.layer.add(animation, forKey: "shake")
    }
}

extension UIView {

    func constraintsForAnchoringTo(boundsOf view: UIView) -> [NSLayoutConstraint] {
        return [
            topAnchor.constraint(equalTo: view.topAnchor),
            leadingAnchor.constraint(equalTo: view.leadingAnchor),
            view.bottomAnchor.constraint(equalTo: bottomAnchor),
            view.trailingAnchor.constraint(equalTo: trailingAnchor)
        ]
    }
}

extension UIViewController: GADInterstitialDelegate  {
    
    public func interstitialDidDismissScreen(_ ad: GADInterstitial) {
    
    }
    
    public func interstitialDidReceiveAd(_ ad: GADInterstitial) {
        ad.present(fromRootViewController: self)
    }
}


class Constants {
    static var countries : [String?] {
        let countries = Locale.isoRegionCodes.compactMap { Locale.current.localizedString(forRegionCode: $0) }
        var sortedCountries = countries.sorted(by: { $0 < $1 })
        
        if let myCountry = Locale.current.regionCode {
            sortedCountries.insert(Locale.current.localizedString(forRegionCode: myCountry)!, at: 0)
        }
        return sortedCountries
    }

    static func getFirstName(_ fullName: String) -> String {
        
        if let first = fullName.components(separatedBy: " ").first {
            return first
        }
        return ""
    }
    
    //static let spotAdId = "ca-app-pub-1688041325566506/1932656861"
    static let spotAdId = "ca-app-pub-3940256099942544/4411468910"
    //static let profileAdId = ""
    static let profileAdId = "ca-app-pub-3940256099942544/4411468910"
    //static let signupAdId = ""
    static let signupAdId = "ca-app-pub-3940256099942544/4411468910"

    
}

class PassThroughView : UIView {
        
    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        return isUserInteractionEnabled
    }
}


extension UILabel {
    func getFontSizeForLabel() -> CGFloat {
        let text: NSMutableAttributedString = NSMutableAttributedString(attributedString: self.attributedText!)
        text.setAttributes([NSAttributedString.Key.font: self.font], range: NSMakeRange(0, text.length))
        let context: NSStringDrawingContext = NSStringDrawingContext()
        context.minimumScaleFactor = self.minimumScaleFactor
        text.boundingRect(with: self.frame.size, options: NSStringDrawingOptions.usesLineFragmentOrigin, context: context)
        let adjustedFontSize: CGFloat = self.font.pointSize * context.actualScaleFactor
        return adjustedFontSize
    }
}

class DistanceCalculator {
    static func deg2rad(deg:Double) -> Double {
        return deg * Double.pi / 180
        }

    static func rad2deg(rad:Double) -> Double {
        return rad * 180.0 / Double.pi
        }

    static func distance(lat1:Double, lon1:Double, lat2:Double, lon2:Double) -> Double {
            let theta = lon1 - lon2
            var dist = sin(deg2rad(deg: lat1)) * sin(deg2rad(deg: lat2)) + cos(deg2rad(deg: lat1)) * cos(deg2rad(deg: lat2)) * cos(deg2rad(deg: theta))
            dist = acos(dist)
            dist = rad2deg(rad: dist)
            dist = dist * 60 * 1.1515
            dist = dist * 1.609344
            
            return dist
    }

}


