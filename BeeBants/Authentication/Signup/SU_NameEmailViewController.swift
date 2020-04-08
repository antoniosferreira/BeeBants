//
//  SU_NameEmailViewController.swift
//  BeeBants
//
//  Created by António Ferreira on 01/04/2020.
//  Copyright © 2020 BeeBants. All rights reserved.
//

import UIKit

class SU_NameEmailViewController: UIViewController {
    
    @IBOutlet weak var nameTextField: RoundTextField!
    @IBOutlet weak var nameErrorLabel: UILabel!
    @IBOutlet weak var emailTextField: RoundTextField!
    @IBOutlet weak var emailErrorLabel: UILabel!
    @IBOutlet weak var nextButton: UIButton!
    
    var signUp: SignUpViewController!
    var pageController : SignUpPageViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpElements()
        hideKeyboardWhenTappedAround()
        setUpGesturesAndAnimations()
    }
    
    func setUpElements() {
        Styling.styleRedField(field: nameTextField, placeholder: "full name")
        Styling.styleRedField(field: emailTextField, placeholder: "e-mail")
        Styling.styleRedFilledButton(button: nextButton)
        
        nameErrorLabel.alpha = 0
        emailErrorLabel.alpha = 0
    }
    
    
    
    
    @IBAction func nameFieldEditEnd(_ sender: Any) {
        if !(Validation.isValidName(nameTextField.text ?? "")) {
            nameTextField.shake()
            nameErrorLabel.alpha = 1
        } else {
            nameErrorLabel.alpha = 0
        }
    }
    
    @IBAction func emailFieldEditEnd(_ sender: Any) {
        if !(Validation.isValidEmail(emailTextField.text ?? "")) {
            emailTextField.shake()
            emailErrorLabel.alpha = 1
        } else {
            emailErrorLabel.alpha = 0
        }
    }
    
    @IBAction func emailFieldEditChanged(_ sender: Any) {
        emailTextField.text = emailTextField.text?.trimmingCharacters(in: .whitespaces)
    }
    
    @IBAction func nextButtonTapped(_ sender: Any) {
        self.view.endEditing(true)
        
        if !(Validation.isValidName(nameTextField.text ?? "")) {
            nameTextField.shake()
        }
        if !(Validation.isValidEmail(emailTextField.text ?? "")) {
            emailTextField.shake()
        }
        
        if (Validation.isValidName(nameTextField.text ?? "") && Validation.isValidEmail(emailTextField.text ?? "")) {
            
            signUp.setNameAndEmail(name: nameTextField.text!, email: emailTextField.text!)
            pageController.forward(index: 1)
        }
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
        if view.selectedTextField == emailTextField {
            signUp.keyboardWillShow(notification: notification)
        }
    }
    
    @objc func keyboardWillHide(notification: Notification) {
        signUp.keyboardWillHide(notification: notification)
    }
}


