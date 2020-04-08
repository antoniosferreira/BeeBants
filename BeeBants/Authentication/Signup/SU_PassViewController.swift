//
//  SU_PassViewController.swift
//  BeeBants
//
//  Created by António Ferreira on 06/04/2020.
//  Copyright © 2020 BeeBants. All rights reserved.
//

import UIKit

class SU_PassViewController: UIViewController {

    var signUp: SignUpViewController!
    var pageController : SignUpPageViewController!
    
    var newsletter = false
    var tc = false
    var tapped = false
    
    
    @IBOutlet weak var helpLabel: UILabel!
    
    @IBOutlet weak var passwordTextField: RoundDateTextField!
    @IBOutlet weak var passwordErrorLabel: UILabel!
    @IBOutlet weak var tcButton: UIImageView!
    @IBOutlet weak var ncButtton: UIImageView!
    @IBOutlet weak var nextButton: RoundButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setUpElements()
        hideKeyboardWhenTappedAround()
        setUpGesturesAndAnimations()
    }
    
    
    func setUpElements() {
        Styling.styleRedField(field: passwordTextField, placeholder: "password")
    
        Styling.styleRedFilledButton(button: nextButton)
        
        tcButton.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tcTapped)))
        ncButtton.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(ncTapped)))
        
        passwordErrorLabel.alpha = 0
        helpLabel.alpha = 0
    }
    
    @IBAction func nextButtonTapped(_ sender: Any) {
        if !Validation.isValidPass(passwordTextField.text) {
            passwordTextField.shake()
            passwordErrorLabel.alpha = 1
        } else if !tc {
            let alert = UIAlertController(title: "Terms & Conditions", message: "You must read and accept our T&Cs", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Got it", style: .destructive, handler: nil))
               
            present(alert, animated: true, completion: nil)
        } else {
            
            if !tapped {
                tapped = true
                signUp.setPassNews(password: passwordTextField.text!, news: newsletter)
                signUp.register()
            }
        }
        
        
    }
    
    @objc func tcTapped() {
        if tc {
            tcButton.image = UIImage(named: "selectionbox_empty")!
        } else {
            tcButton.image = UIImage(named: "selectionbox_selected")!
        }
        tc = !tc
    }
    
    @objc func ncTapped() {
        if newsletter {
            ncButtton.image = UIImage(named: "selectionbox_empty")!
        } else {
            ncButtton.image = UIImage(named: "selectionbox_selected")!
        }
        newsletter = !newsletter
    }

    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }

    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    func setUpGesturesAndAnimations() {
        NotificationCenter.default.addObserver(self,selector:#selector(self.keyboardWillShow),name:UIResponder.keyboardDidShowNotification, object: nil)
        NotificationCenter.default.addObserver(self,selector: #selector(self.keyboardWillHide),name:UIResponder.keyboardDidHideNotification, object: nil)
    }
    
    @objc func keyboardWillShow(notification: Notification) {
       // do nothing
    }
    
    @objc func keyboardWillHide(notification: Notification) {
        signUp.keyboardWillHide(notification: notification)
    }

    @IBAction func passEditChanged(_ sender: Any) {
        helpLabel.alpha = 1
        if !Validation.isValidPass(passwordTextField.text) {
            passwordErrorLabel.alpha = 1
        } else {
            passwordErrorLabel.alpha = 0
            helpLabel.alpha = 0
        }
    }
    
    @IBAction func passEditEnd(_ sender: Any) {
        helpLabel.alpha = 0
        if !Validation.isValidPass(passwordTextField.text) {
            passwordTextField.shake()
            passwordErrorLabel.alpha = 1
        } else {
            passwordErrorLabel.alpha = 0
        }
    }

}
