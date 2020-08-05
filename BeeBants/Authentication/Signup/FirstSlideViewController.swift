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
    @IBOutlet weak var fieldEmail: RoundTextField!
    
    @IBOutlet weak var labelBadName: UILabel!
    @IBOutlet weak var labelBadEmail: UILabel!
    
    @IBOutlet weak var buttonNext: RoundButton!
        
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
        
        self.fieldEmail.delegate = self
        self.fieldName.delegate = self
        
    }
    
    private func setUpElements() {
        labelNameTitle.setNeedsDisplay()
        labelEmailTitle.setNeedsDisplay()
        Styling.styleRedField(field: fieldName, placeholder: "full name")
        Styling.styleRedField(field: fieldEmail, placeholder: "e-mail")
        Styling.styleRedFilledButton(button: buttonNext)
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
        let kbSize = keyboardFrame.cgRectValue.height
        
        let contentInsets:UIEdgeInsets  = UIEdgeInsets(top: 0.0, left: 0.0, bottom: kbSize, right: 0.0)
        viewScroll.contentInset = contentInsets
        viewScroll.scrollIndicatorInsets = contentInsets
        var aRect: CGRect = self.view.frame
        aRect.size.height -= kbSize
        //you may not need to scroll, see if the active field is already visible
        if activeField != nil {
            if (!aRect.contains(activeField!.frame.origin) ) {
                let scrollPoint:CGPoint = CGPoint(x: 0.0, y: activeField!.frame.origin.y - kbSize)
                viewScroll.setContentOffset(scrollPoint, animated: true)
            }
        }
        
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
            
        } else {
            labelBadEmail.alpha = 0
        }
    }
    
    @IBAction func emailFieldEditingChanged(_ sender: Any) {
        fieldEmail.text = fieldEmail.text?.trimmingCharacters(in: .whitespaces)
    }
    
    @IBAction func nameFieldEditingBegin(_ sender: Any) {
        activeField = sender as? UITextField
    }
    
    @IBAction func nameFieldEditingChanged(_ sender: Any) {
    }
    
    @IBAction func nameFieldEditingEnded(_ sender: Any) {
        activeField = nil
        if !(Validation.isValidName(fieldName.text ?? "")) {
            fieldName.shake()
            labelBadName.alpha = 1
        } else {
            labelBadName.alpha = 0
        }
    }

    
    /*
        VALIDATION AND DATA INSERTION
     */
    
    
    override func validData() -> Bool {
        if (Validation.isValidName(fieldName.text ?? "") && Validation.isValidEmail(fieldEmail.text ?? "")) {
            return true
        }
        return false
    }
    
    @IBAction func tappedNext(_ sender: Any) {
        self.view.endEditing(true)
        
        // Transition to next Slide
        self.signViewController?.pageController?.setViewControllers([(self.signViewController?.pages[1])! as UIViewController], direction: .forward, animated: true, completion: nil)
        
    }
    
}
