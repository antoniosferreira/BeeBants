//
//  MainStyling.swift
//  BeeBants
//
//  Created by António Ferreira on 30/03/2020.
//  Copyright © 2020 BeeBants. All rights reserved.
//

import Foundation
import UIKit

class Styling {
    
    static let redColor = UIColor(red: 0.85, green: 0.12, blue: 0.15, alpha: 1)
    static let redTranslucid = UIColor(red: 0.85, green: 0.12, blue: 0.15, alpha: 0.1)

    static let whiteTranslucid = UIColor(red: 1, green: 1, blue: 1, alpha: 0.8)

    static func styleRedFilledButton(button: UIButton) {
        button.backgroundColor = redColor
    }
    
    static func styleRedFilledBorderButton(button: UIButton) {
        button.backgroundColor = redColor
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.white.cgColor
    }
    
    static func styleRedUnfilledButton(button: UIButton) {
        button.backgroundColor = whiteTranslucid
        button.layer.borderWidth = 1
        button.layer.borderColor = redColor.cgColor
    }
    
    static func styleRedField(field: UITextField, placeholder: String) {
        field.layer.borderColor = redColor.cgColor
        
        field.attributedPlaceholder = NSAttributedString(string: placeholder,
        attributes: [NSAttributedString.Key.foregroundColor: redColor])
        
        field.font =  UIFont.init(name: "Poppins-Light", size: field.bounds.width/20)
        field.backgroundColor = whiteTranslucid
    }
    
    static func styleBadRedField(field: UITextField) {
        field.layer.borderColor = redColor.cgColor
       
        field.font =  UIFont.init(name: "Poppins-Light", size: field.bounds.width/20)
        field.backgroundColor = redTranslucid
    }
    
    static func styleWhiteField(field: UITextField, placeholder: String) {
        field.layer.borderColor = redColor.cgColor
        
        field.attributedPlaceholder = NSAttributedString(string: placeholder,
        attributes: [NSAttributedString.Key.foregroundColor: redColor])
        
        field.font =  UIFont.init(name: "Poppins-Light", size: field.bounds.width/20)
        field.backgroundColor = .white
    }
    
    
    
    static func styleHiTextLabel(label: UILabel) {
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.25
        label.numberOfLines = 2
        label.font = UIFont(name: "Poppins-Bold", size: 40)
        label.setNeedsDisplay()
    }

}

class RoundButton : UIButton {
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = bounds.height / 2
    }
}

class RoundTextField : UITextField {
    
    var textPadding = UIEdgeInsets(
            top: 0,
            left: 20,
            bottom: 0,
            right: 0
        )
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
            let rect = super.textRect(forBounds: bounds)
            return rect.inset(by: textPadding)
        }

    override func editingRect(forBounds bounds: CGRect) -> CGRect {
            let rect = super.editingRect(forBounds: bounds)
            return rect.inset(by: textPadding)
        }
    

    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = bounds.height / 2
        self.clipsToBounds = true
        self.layer.borderWidth = 1
    }
}

class RoundDateTextField : DateTextField {
    var textPadding = UIEdgeInsets(
            top: 0,
            left: 20,
            bottom: 0,
            right: 0
        )
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
            let rect = super.textRect(forBounds: bounds)
            return rect.inset(by: textPadding)
        }

    override func editingRect(forBounds bounds: CGRect) -> CGRect {
            let rect = super.editingRect(forBounds: bounds)
            return rect.inset(by: textPadding)
        }
    

    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = bounds.height / 2
        self.clipsToBounds = true
        self.layer.borderWidth = 1
    
    }
}

class RoundPickerTextField : UITextField {
    var textPadding = UIEdgeInsets(
            top: 0,
            left: 20,
            bottom: 0,
            right: 0
        )
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
            let rect = super.textRect(forBounds: bounds)
            return rect.inset(by: textPadding)
        }

    override func editingRect(forBounds bounds: CGRect) -> CGRect {
            let rect = super.editingRect(forBounds: bounds)
            return rect.inset(by: textPadding)
        }
    

    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = bounds.height / 2
        self.clipsToBounds = true
        self.layer.borderWidth = 1
       
    }
}
