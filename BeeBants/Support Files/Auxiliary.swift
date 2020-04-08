//
//  Auxiliary.swift
//  BeeBants
//
//  Created by António Ferreira on 02/04/2020.
//  Copyright © 2020 BeeBants. All rights reserved.
//

import Foundation
import UIKit


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

class Constants {
    static var countries : [String?] {
        var countries = Locale.isoRegionCodes.compactMap { Locale.current.localizedString(forRegionCode: $0) }
        if let myCountry = Locale.current.regionCode {
            countries.insert(Locale.current.localizedString(forRegionCode: myCountry)!, at: 0)
        }
        return countries
    }

    
}
