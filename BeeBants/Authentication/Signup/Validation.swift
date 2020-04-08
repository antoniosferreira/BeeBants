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
    
    static func isValidDate(_ date: Date?) -> Bool {
        
        if date != nil {
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy/MM/dd HH:mm"
            let someDateTime = formatter.date(from: "1920/12/31 00:00")
            
//            if (someDateTime! > date!) {
//                return false }
            
            
            return true
        }
        
        return false
    }
    
    
    static func isValidPass(_ pass: String?) -> Bool {
        let passRegex = "^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9]).{6,}$"
        let passPred = NSPredicate(format:"SELF MATCHES %@", passRegex)
        return passPred.evaluate(with: pass)
    }
    
}
