//
//  LostPasswordViewController.swift
//  BeeBants
//
//  Created by António Ferreira on 07/04/2020.
//  Copyright © 2020 BeeBants. All rights reserved.
//

import UIKit
import FirebaseAuth

class LostPasswordViewController: UIViewController {

    @IBOutlet weak var emailTextField: RoundTextField!
    @IBOutlet weak var submitButton: RoundButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setUpElements()
        hideKeyboardWhenTappedAround()
    }
    
    func setUpElements() {
        Styling.styleWhiteField(field: emailTextField, placeholder: "e-mail")
        Styling.styleRedFilledBorderButton(button: submitButton)
    }
    
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    

    @IBAction func emailEditChanged(_ sender: Any) {
        emailTextField.text = emailTextField.text?.trimmingCharacters(in: .whitespaces)

    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    
    func resetPassword(email: String) {
        Auth.auth().sendPasswordReset(withEmail: email) { (error) in
            
            if error != nil {
                let alert = UIAlertController(title: "Something wrong happened", message: error?.localizedDescription, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .destructive, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
         if  let vc = segue.destination as? RecoveryPasswordViewController {
            if let email = emailTextField.text  {
                resetPassword(email: email)
                vc.email = email
         }
        vc.submitHeight = Int(submitButton.bounds.height)
        }
    }
 
}
