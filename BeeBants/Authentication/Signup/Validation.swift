//
//  Validation.swift
//  BeeBants
//
//  Created by António Ferreira on 04/08/2020.
//  Copyright © 2020 BeeBants. All rights reserved.
//

import Foundation

class Validation {
    
    static func isValidName(_ name: String) -> Bool {
    
        if name == "" {return false}
        
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
        
        if let inputDate = date {
            let currentDate = Date()
            let lastValidDate = currentDate.addingTimeInterval(-189216000)
            
            
            if inputDate > lastValidDate {
                return false
            }
            
            let formatter = DateFormatter()
            formatter.dateFormat = "dd/MM/yyyy"
            if let someDateTime = formatter.date(from: "31/12/1935")  {
                if inputDate < someDateTime {
                    return false
                }
            }
            
            
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

