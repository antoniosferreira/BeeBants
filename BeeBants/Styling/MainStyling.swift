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
    
    static func styleWhiteField(field: UITextField, placeholder: String) {
        field.layer.borderColor = redColor.cgColor
        
        field.attributedPlaceholder = NSAttributedString(string: placeholder,
        attributes: [NSAttributedString.Key.foregroundColor: redColor])
        
        field.font =  UIFont.init(name: "Poppins-Light", size: field.bounds.width/20)
        field.backgroundColor = .white
    }

}

class RoundButton : UIButton {
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = bounds.height / 2
    }
}

class RoundTextField : UITextField {
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = bounds.height / 2
        self.clipsToBounds = true
        self.layer.borderWidth = 1
        
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: self.frame.size.width*0.075, height: self.frame.size.height))
        self.leftView = paddingView
        self.leftViewMode = .always
    }
}

class RoundDateTextField : DateTextField {
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = bounds.height / 2
        self.clipsToBounds = true
        self.layer.borderWidth = 1
        
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: self.frame.size.width*0.075, height: self.frame.size.height))
        self.leftView = paddingView
        self.leftViewMode = .always
    }
}

class RoundPickerTextField : UITextField {
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = bounds.height / 2
        self.clipsToBounds = true
        self.layer.borderWidth = 1
        
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: self.frame.size.width*0.075, height: self.frame.size.height))
        self.leftView = paddingView
        self.leftViewMode = .always
    }
}
