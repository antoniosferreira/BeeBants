//
//  ThirdSlideViewController.swift
//  BeeBants
//
//  Created by António Ferreira on 04/08/2020.
//  Copyright © 2020 BeeBants. All rights reserved.
//

import UIKit

class ThirdSlideViewController: SlideViewController {

    @IBOutlet weak var viewScroll: UIScrollView!
    
    @IBOutlet weak var labelPasswordTitle: UILabel!
    @IBOutlet weak var labelBadPassword: UILabel!
    @IBOutlet weak var fieldPassword: RoundTextField!
    
    @IBOutlet weak var buttonTC: UIImageView!
    @IBOutlet weak var buttonNews: UIImageView!
    @IBOutlet weak var buttonNext: RoundButton!
    
    var tc = false
    var news = false
    
    override func viewDidLoad() {
        super.viewDidLoad()


        self.index = 2
        setUpElements()
        hideKeyboardWhenTappedAround()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.view.endEditing(true)
    }
    
    func setUpElements() {
        Styling.styleRedFilledButton(button: buttonNext)
        Styling.styleRedField(field: fieldPassword, placeholder: "password")
        
        buttonTC.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tappedButtonTC)))
        buttonNews.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tappedButtonNews)))
        labelBadPassword.alpha = 0
    }
    
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }

    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    @objc func tappedButtonTC() {
        if tc {
            buttonTC.image = UIImage(named: "selectionbox_empty")!
        } else {
            buttonTC.image = UIImage(named: "selectionbox_selected")!
        }
        tc = !tc
    }
    
    @objc func tappedButtonNews() {
        if news {
            buttonNews.image = UIImage(named: "selectionbox_empty")!
        } else {
            buttonNews.image = UIImage(named: "selectionbox_selected")!
        }
        news = !news
    }
    
    
    @IBAction func passEditingChanged(_ sender: Any) {
        labelBadPassword.alpha = 1
        if !Validation.isValidPass(fieldPassword.text) {
            labelBadPassword.alpha = 1
        } else {
            labelBadPassword.alpha = 0
        }
    }
    
    @IBAction func passEditingEnded(_ sender: Any) {
        if !Validation.isValidPass(fieldPassword.text) {
            fieldPassword.shake()
            labelBadPassword.alpha = 1
        } else {
            labelBadPassword.alpha = 0
        }
    }
    
    override func validData() -> Bool {
        return Validation.isValidPass(fieldPassword.text)
    }

    @IBAction func tappedButtonNext(_ sender: Any) {
        if !Validation.isValidPass(fieldPassword.text) {
               fieldPassword.shake()
               labelBadPassword.alpha = 1
            
        } else if !tc {
            let alert = UIAlertController(title: "Terms & Conditions", message: "You must read and accept our T&Cs", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Got it", style: .destructive, handler: nil))
                  
            present(alert, animated: true, completion: nil)
            
        } else {
            self.signViewController!.register()
        }
    }
    

}
