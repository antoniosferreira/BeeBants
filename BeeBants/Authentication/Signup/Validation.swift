//
//  Validation.swift
//  BeeBants
//
//  Created by António Ferreira on 02/04/2020.
//  Copyright © 2020 BeeBants. All rights reserved.
//

import Foundation

class Validation {
    
    static func isValidName(_ name: String) -> Bool {
        
        //Check if at least 2 names
        let chararacterSet = CharacterSet.whitespacesAndNewlines.union(.punctuationCharacters)
        let components = name.components(separatedBy: chararacterSet)
        let words = components.filter { !$0.isEmpty }
        if (words.count < 2) { return false }

        // Check if contains numbers
        let numbersRange = name.rangeOfCharacter(from: .decimalDigits)
        if (numbersRange != nil) { return false }
        
        
        return true
    }
 
    static func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"

        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }
    
    
    
}
