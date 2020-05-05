//
//  LoginViewController.swift
//  BeeBants
//
//  Created by António Ferreira on 07/04/2020.
//  Copyright © 2020 BeeBants. All rights reserved.
//

import UIKit
import FirebaseAuth

class LoginViewController: UIViewController {

    @IBOutlet weak var emailTextField: RoundTextField!
    @IBOutlet weak var passTextField: RoundTextField!
    @IBOutlet weak var signButton: RoundButton!
    @IBOutlet weak var contentView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpBackground()
        setUpElements()
        hideKeyboardWhenTappedAround()
    }
    

    func setUpBackground() {
        let backgroundImage = UIImageView(frame: UIScreen.main.bounds)
        backgroundImage.image = UIImage(named: "Main_BG")
        backgroundImage.contentMode =  UIView.ContentMode.scaleAspectFill
        backgroundImage.alpha = 0.8
        
        let gradientMaskLayer = CAGradientLayer()
        gradientMaskLayer.frame = backgroundImage.bounds
        gradientMaskLayer.bounds = backgroundImage.bounds
        gradientMaskLayer.colors = [UIColor.clear.cgColor, UIColor.white.cgColor]
        gradientMaskLayer.locations = [0.4, 1]
        
        backgroundImage.layer.mask = gradientMaskLayer
        view.addSubview(backgroundImage)
        
        self.view.insertSubview(backgroundImage, at: 0)
    }
    
    func setUpElements() {
        Styling.styleRedField(field: emailTextField, placeholder: "e-mail")
        Styling.styleRedField(field: passTextField, placeholder: "password")
        Styling.styleRedFilledButton(button: signButton)
    }

    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    
    @IBAction func signButtonTapped(_ sender: UIButton) {
        
        if let email = emailTextField.text, let pass = passTextField.text {
            Auth.auth().signIn(withEmail: email, password: pass) { [weak self] authResult, error in
                guard let strongSelf = self else { return }
                
                if error != nil {
                    let alert = UIAlertController(title: "Bad Login", message: error?.localizedDescription, preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .destructive, handler: nil))
                    strongSelf.present(alert, animated: true, completion: nil)
                } else {
                    let alert = UIAlertController(title: "Good Login", message: "You're logged in", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .destructive, handler: nil))
                    strongSelf.present(alert, animated: true, completion: nil)
                }
            }
        }
        

    }
    
    
    
    
    
}
