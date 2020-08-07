//
//  RecoveryPasswordViewController.swift
//  BeeBants
//
//  Created by António Ferreira on 08/04/2020.
//  Copyright © 2020 BeeBants. All rights reserved.
//

import UIKit
import FirebaseAuth

class RecoveryPasswordViewController: UIViewController {

    var email : String = ""
    var times : Int  = 0
    
    @IBOutlet weak var startButton: RoundButton!
    override func viewDidLoad() {
        super.viewDidLoad()

        Styling.styleRedFilledBorderButton(button: startButton)
    }
    
    func resetPassword(email: String) {
           Auth.auth().sendPasswordReset(withEmail: email) { (error) in
               
               if error != nil {
                   let alert = UIAlertController(title: "Something wrong happened", message: error?.localizedDescription, preferredStyle: .alert)
                   alert.addAction(UIAlertAction(title: "OK", style: .destructive, handler: nil))
                   self.present(alert, animated: true, completion: nil)
               }
           }
    }

    @IBAction func tappedResend(_ sender: Any) {
        print(times)
        if times < 2 {
            resetPassword(email: email)
            times = times + 1
        } else {
            let alert = UIAlertController(title: "Oh oh", message: "You've exceeded the amount of requests. Try again later", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .destructive, handler: {(_: UIAlertAction!) in self.dismiss(animated: true, completion: nil)}))
            
            present(alert, animated: true)
        }
    }
    
    @IBAction func tappedStart(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}
