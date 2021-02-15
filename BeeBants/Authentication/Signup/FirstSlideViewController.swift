//
//  FirstSlideViewController.swift
//  BeeBants
//
//  Created by António Ferreira on 04/08/2020.
//  Copyright © 2020 BeeBants. All rights reserved.
//

import UIKit

class FirstSlideViewController: SlideViewController, UITextFieldDelegate {
    
    @IBOutlet weak var viewScroll: UIScrollView!
    
    @IBOutlet weak var labelNameTitle: UILabel!
    @IBOutlet weak var labelEmailTitle: UILabel!
    
    @IBOutlet weak var fieldName: RoundTextField!
    @IBOutlet weak var fieldSurname: RoundTextField!
    @IBOutlet weak var fieldEmail: RoundTextField!
    
    @IBOutlet weak var labelBadEmail: UILabel!
    
        
    var activeField: UITextField?
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.view.endEditing(true)
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
                
        // Do any additional setup after loading the view.
        setUpElements()
        registerForKeyboardNotifications()
        hideKeyboardWhenTappedAround()
        
        self.index = 0
        
        self.fieldName.delegate = self
        self.fieldEmail.delegate = self
        self.fieldSurname.delegate = self
        
    }
    
    private func setUpElements() {
        Styling.styleRedField(field: fieldName, placeholder: "name")
        Styling.styleRedField(field: fieldSurname, placeholder: "surname")
        Styling.styleRedField(field: fieldEmail, placeholder: "e-mail")
    }
    
    
    
    /*
        GESTURES AND SCROLL VIEW RELATED CODE
     */
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    func registerForKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillBeHidden(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyboardWillShow(notification: NSNotification){
        guard let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else {
            return
        }
        let kbSize = keyboardFrame.cgRectValue.height * 0.85
        
        let contentInsents = UIEdgeInsets(top: 0.0, left: 0.0, bottom: kbSize, right: 0.0)
        viewScroll.contentInset = contentInsents
        viewScroll.scrollIndicatorInsets = contentInsents
        
    }
    
    @objc func keyboardWillBeHidden(notification: NSNotification){
        let contentInsets:UIEdgeInsets = UIEdgeInsets.zero
        viewScroll.contentInset = contentInsets
        viewScroll.scrollIndicatorInsets = contentInsets
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        activeField = nil
        return true
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        activeField = textField
        return true
    }
    
    
    /*
        FIELD RELATED ACTIONS
     */
    @IBAction func emailFieldEditingBegin(_ sender: Any) {
        activeField = sender as? UITextField
    }
    
    @IBAction func emailFieldEditingEnded(_ sender: Any) {
        activeField = nil
        if !(Validation.isValidEmail(fieldEmail.text ?? "")) {
            fieldEmail.shake()
            labelBadEmail.alpha = 1
            Styling.styleBadRedField(field: fieldEmail)
        } else {
            labelBadEmail.alpha = 0
            Styling.styleRedField(field: fieldEmail, placeholder: "e-mail")
        }
    }
    
    @IBAction func emailFieldEditingChanged(_ sender: Any) {
        fieldEmail.text = fieldEmail.text?.trimmingCharacters(in: .whitespaces)
    }
    
    
    @IBAction func nameFieldEditingChanged(_ sender: Any) {
        fieldName.text = fieldName.text?.trimmingCharacters(in: .whitespaces)

    }
    
    @IBAction func nameFieldEditingEnded(_ sender: Any) {
        activeField = nil
        if !(Validation.isValidName(fieldName.text ?? "")) {
            fieldName.shake()
            Styling.styleBadRedField(field: fieldName)
        } else {
            Styling.styleRedField(field: fieldName, placeholder: "name")
        }
    }
    
    @IBAction func surnameFieldEditingChanged(_ sender: Any) {
        fieldSurname.text = fieldSurname.text?.trimmingCharacters(in: .whitespaces)

    }
    
    @IBAction func surnameFieldEditingEnded(_ sender: Any) {
        activeField = nil
        if !(Validation.isValidName(fieldSurname.text ?? "")) {
            fieldSurname.shake()
            Styling.styleBadRedField(field: fieldSurname)
        } else {
            Styling.styleRedField(field: fieldSurname, placeholder: "surname")
        }
    }
    
    
    /*
        VALIDATION AND DATA INSERTION
     */
    override func validData() -> Bool {
        if (Validation.isValidName(fieldName.text ?? "") &&
            Validation.isValidName(fieldSurname.text ?? "") && Validation.isValidEmail(fieldEmail.text ?? "")) {
            return true
        }
        return false
    }
}
