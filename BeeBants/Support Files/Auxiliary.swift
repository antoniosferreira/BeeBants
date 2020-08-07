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
