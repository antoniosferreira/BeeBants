//
//  SecondSlideViewController.swift
//  BeeBants
//
//  Created by António Ferreira on 04/08/2020.
//  Copyright © 2020 BeeBants. All rights reserved.
//

import UIKit

class SecondSlideViewController: SlideViewController, UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource {

    @IBOutlet weak var viewScroll: UIScrollView!
    
    @IBOutlet weak var labelDateTitle: UILabel!
    @IBOutlet weak var labelLocationTitle: UILabel!
    
    @IBOutlet weak var fieldDate: RoundDateTextField!
    @IBOutlet weak var fieldLocation: RoundPickerTextField!
    
    @IBOutlet weak var labelBadDate: UILabel!
    @IBOutlet weak var labelBadLocation: UILabel!

    @IBOutlet weak var buttonNext: RoundButton!
        
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.view.endEditing(true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.index = 1
                
        setUpElements()
        hideKeyboardWhenTappedAround()
                     
    }
    
    private func setUpElements() {
        Styling.styleRedField(field: fieldDate, placeholder: "date of birth")
        Styling.styleRedField(field: fieldLocation, placeholder: "nationality")
        Styling.styleRedFilledButton(button: buttonNext)
        
        labelBadDate.alpha = 0
        labelBadLocation.alpha = 0
                
        fieldDate.dateFormat = .dayMonthYear
        fieldDate.separator = "-"
        
        let pickerView = UIPickerView()
        pickerView.delegate = self
        fieldLocation.inputView = pickerView
        dismissPickerView()
    
    }
    

    /*
        PICKER VIEW (NATIONS) RELATED CODE
     */
    func dismissPickerView() {
         let toolBar = UIToolbar()
         
         toolBar.sizeToFit()
         let button = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(self.action))
         button.tintColor = Styling.redColor
         toolBar.setItems([button], animated: true)
         toolBar.isUserInteractionEnabled = true
         fieldLocation.inputAccessoryView = toolBar
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
       fieldLocation.text = Constants.countries[row]
    }
    @objc func action() {
        view.endEditing(true)
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
    
    
    
    /*
         FIELD ACTIONS RELATED CODE
     */
    @IBAction func dateFieldEditingEnded(_ sender: Any) {
        if !Validation.isValidDate(fieldDate.date) {
            fieldDate.shake()
            labelBadDate.alpha = 1
            return
        }
        
        labelBadDate.alpha = 0
    }
    
    @IBAction func locationFieldEditingEnded(_ sender: Any) {
        if fieldLocation.text == nil || fieldLocation.text == "" {
            fieldLocation.shake()
            labelBadLocation.alpha = 1
            return
        }
        
        labelBadLocation.alpha = 0
    }
    
    override func validData() -> Bool {
        if Validation.isValidDate(fieldDate.date) &&
            !(fieldLocation.text == nil || fieldLocation.text == "") {
            return true
        }
        return false
    }
    
    
    @IBAction func tappedNext(_ sender: Any) {
        self.view.endEditing(true)
        
        // Transition to next Slide
        let _ = self.signViewController?.forward()

        
    }
    
}
