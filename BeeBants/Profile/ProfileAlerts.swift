//
//  ProfileAlerts.swift
//  BeeBants
//
//  Created by António Ferreira on 30/07/2020.
//  Copyright © 2020 BeeBants. All rights reserved.
//

import Foundation
import UIKit

public class ProfileBadAlert {
    
    private var alert : UIAlertController
    
    init (title : String, message: String, buttonTitle: String, view: UIViewController) {
        alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Try again", style: .destructive, handler:
            {
                (_) in
                // Goes to main
                let storyBoard: UIStoryboard = UIStoryboard(name: "Home", bundle: nil)
                let newViewController = storyBoard.instantiateViewController(withIdentifier: "MAIN_SB") as! HomeViewController
                newViewController.modalPresentationStyle = .fullScreen
                view.present(self.alert, animated: true, completion: nil)
        }))
    }
    
    public func getAlert() -> UIAlertController {
        return alert
    }
}

public class ProfileBadValuesAlert {
    private var alert : UIAlertController
    
    init (title : String, message: String, buttonTitle: String) {
        alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: buttonTitle, style: .destructive, handler: nil))
    }
    
    public func getAlert() -> UIAlertController {
        return alert
    }
}
                
