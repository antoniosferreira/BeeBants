//
//  SU_DateNationViewController.swift
//  BeeBants
//
//  Created by António Ferreira on 02/04/2020.
//  Copyright © 2020 BeeBants. All rights reserved.
//

import UIKit

class SU_DateNationViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate {

    var signUp: SignUpViewController!
    var pageController : SignUpPageViewController!
    
    @IBOutlet weak var dateTextField: RoundDateTextField!
    @IBOutlet weak var dateErrorLabel: UILabel!
    @IBOutlet weak var nationTextField: RoundPickerTextField!
    @IBOutlet weak var nationErrorLabel: UILabel!
    
    @IBOutlet weak var nextButton: RoundButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        setUpElements()
        hideKeyboardWhenTappedAround()
        setUpGesturesAndAnimations()
    }
    
    func setUpElements() {
        Styling.styleRedField(field: dateTextField, placeholder: "date of birth")
        Styling.styleRedField(field: nationTextField, placeholder: "nationality")
        Styling.styleRedFilledButton(button: nextButton)
        
        dateErrorLabel.alpha = 0
        nationErrorLabel.alpha = 0
                
        dateTextField.dateFormat = .dayMonthYear
        dateTextField.separator = "-"
        
        let pickerView = UIPickerView()
        pickerView.delegate = self
        nationTextField.inputView = pickerView
        dismissPickerView()
    }
    
    
    @IBAction func dateFieldEditEnd(_ sender: Any) {
        if !Validation.isValidDate(dateTextField.date) {
            dateTextField.shake()
            dateErrorLabel.alpha = 1
        } else {
            dateErrorLabel.alpha = 0
        }
    }
    
    @IBAction func nationEditEnd(_ sender: Any) {
        if nationTextField.text == nil || nationTextField.text == "" {
            nationTextField.shake()
            nationErrorLabel.alpha = 1
        } else {
            nationErrorLabel.alpha = 0
        }
    }
    
    
    @IBAction func nextButtonTapped(_ sender: Any) {
        self.view.endEditing(true)
              
              if !Validation.isValidDate(dateTextField.date) {
                  dateTextField.shake()
              }
              if nationTextField.text == nil || nationTextField.text == "" {
                  nationTextField.shake()
              }
              
              if Validation.isValidDate(dateTextField.date) &&
                !(nationTextField.text == nil || nationTextField.text == "") {
                
                   let dateFormatter = DateFormatter()
                   dateFormatter.dateFormat = "dd/MM/yyyy"
                let dateString = dateFormatter.string(from:dateTextField.date!)
                   print(dateString)
                
                  
                signUp.setDateAndNation(date: dateString, nation: nationTextField.text!)
                pageController.forward(index: 2)
              }
    }
    
    func dismissPickerView() {
        let toolBar = UIToolbar()
        
        toolBar.sizeToFit()
        let button = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(self.action))
        button.tintColor = Styling.redColor
        toolBar.setItems([button], animated: true)
        toolBar.isUserInteractionEnabled = true
        nationTextField.inputAccessoryView = toolBar
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
    return 1 // number of session
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return Constants.countries.count // number of dropdown items
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
    return Constants.countries[row] // dropdown item
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
    nationTextField.text = Constants.countries[row]
    }
    
    @objc func action() {
          view.endEditing(true)
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
        if view.selectedTextField == nationTextField {
            signUp.keyboardWillShow(notification: notification)
        }
    }
    
    @objc func keyboardWillHide(notification: Notification) {
        signUp.keyboardWillHide(notification: notification)
    }

}
