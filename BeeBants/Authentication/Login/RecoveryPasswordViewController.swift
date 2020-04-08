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


    var submitHeight : Int = 0
    var email : String = ""
    var times : Int  = 0
    
    @IBOutlet weak var submitButton: RoundButton!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        Styling.styleRedFilledBorderButton(button: submitButton)
    }
    
    @IBAction func resend(_ sender: UITapGestureRecognizer) {
        if times < 3 {
            resetPassword(email: email)
            times = times + 1
        } else {
            let alert = UIAlertController(title: "Oh oh", message: "You've exceeded the amount of requests. Try again later", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .destructive, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
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
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
