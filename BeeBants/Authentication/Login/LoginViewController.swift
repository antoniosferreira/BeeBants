//
//  LoginViewController.swift
//  BeeBants
//
//  Created by António Ferreira on 05/08/2020.
//  Copyright © 2020 BeeBants. All rights reserved.
//

import UIKit
import CTSlidingUpPanel
import FirebaseAuth


class LoginViewController: UIViewController {

    
    // Slide Constraints
    @IBOutlet weak var constraintTop: NSLayoutConstraint!
    @IBOutlet weak var constraintHeight: NSLayoutConstraint!
    
    
    // Main Views
    @IBOutlet weak var viewScroll: UIScrollView!
    @IBOutlet weak var viewBottom: UIView!
    @IBOutlet weak var viewForgot: UIView!
    @IBOutlet weak var viewForgotWrapper: UIView!
    
    // Forgot Password Subviews & Related
    @IBOutlet weak var viewTopBar: UIView!
    @IBOutlet weak var viewForgotContent: UIView!
    @IBOutlet weak var viewScrollForgotten: UIScrollView!
    @IBOutlet weak var labelForgot2: UILabel!
    lazy var labels = [labelForgot2]
    @IBOutlet weak var fieldForgottenEmail: RoundTextField!
    @IBOutlet weak var buttonSubmit: RoundButton!
    
    @IBOutlet weak var fieldEmail: RoundTextField!
    @IBOutlet weak var fieldPassword: RoundTextField!
    @IBOutlet weak var buttonLogin: RoundButton!
    
    var activeField: UITextField?

    // Forgot password slide
    private var slideController : CTBottomSlideController?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setUpBackground()
        setUpElements()
        hideKeyboardWhenTappedAround()
        registerForKeyboardNotifications()
        
        
        configureForgotSlide()
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
        Styling.styleRedField(field: fieldEmail, placeholder: "e-mail")
        Styling.styleRedField(field: fieldPassword, placeholder: "password")
        Styling.styleRedFilledButton(button: buttonLogin)
        Styling.styleWhiteField(field: fieldForgottenEmail, placeholder: "e-mail")
        Styling.styleRedFilledBorderButton(button: buttonSubmit)
        
        // Set Up Forgot View
        viewTopBar.layer.cornerRadius = viewTopBar.frame.size.height 
        viewTopBar.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        
        let smallestFontSize = labels.map{$0!.actualFontSize}.min()
        for label in labels {
            label?.font = label?.font.withSize(smallestFontSize!)
        }
     }
    
    @IBAction func tappedLogin(_ sender: Any) {
        if let email = fieldEmail.text, let pass = fieldPassword.text {
            Auth.auth().signIn(withEmail: email, password: pass) {
                [weak self] authResult, error in
                
                guard let strongSelf = self else { return }
                
                // BAD LOGIN
                if error != nil {
                    let alert = UIAlertController(title: "Bad Login", message: error?.localizedDescription, preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .destructive, handler: nil))
                    strongSelf.present(alert, animated: true, completion: nil)
                
                // SUCCESS LOGIN
                } else {
                    let home = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController
                    home.modalPresentationStyle = .fullScreen
                    self?.present(home, animated: true)
                }
            }
        }
    }
    
    @IBAction func tappedGoBack(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func tappedForgotPassword(_ sender: Any) {
        slideController?.expandPanel()
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
        guard let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else { return }
        let kbSize = keyboardSize.height
        
        
        // If on main login view
        if !(viewForgotWrapper.isUserInteractionEnabled) {
            let contentInsents = UIEdgeInsets(top: 0.0, left: 0.0, bottom: kbSize - viewBottom.frame.height, right: 0.0)
            viewScroll.contentInset = contentInsents
            viewScroll.scrollIndicatorInsets = contentInsents
        }
        // If on forgotten view
        else {
            let top = viewBottom.frame.height / 2
            let contentInsents = UIEdgeInsets(top: -top, left: 0.0, bottom: 0.0, right: 0.0)
            viewScrollForgotten.contentInset = contentInsents
            viewScrollForgotten.scrollIndicatorInsets = contentInsents
        }
    }
    
    @objc func keyboardWillBeHidden(notification: NSNotification){
        guard let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else { return }
        
        // If on main login view
        if !(viewForgotWrapper.isUserInteractionEnabled) {
            let contentInsets: UIEdgeInsets = UIEdgeInsets.zero
            viewScroll.contentInset = contentInsets
            viewScroll.scrollIndicatorInsets = contentInsets
        }
        // If on forgotten View
        else {
            let contentInsets: UIEdgeInsets = UIEdgeInsets.zero
            viewScrollForgotten.contentInset = contentInsets
            viewScrollForgotten.scrollIndicatorInsets = contentInsets
        }
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        activeField = nil
        return true
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        activeField = textField
        return true
    }
    
    func configureForgotSlide() {
        viewForgotWrapper.alpha = 0
        viewForgotWrapper.isUserInteractionEnabled = false
        viewForgot.isUserInteractionEnabled = false
        
        // Bottom Slide View for Forgot password
        slideController = CTBottomSlideController(topConstraint: constraintTop,
                                                heightConstraint: constraintHeight,
                                                parent: viewForgotWrapper,
                                                bottomView: viewForgot,
                                                tabController: nil,
                                                navController: nil,
                                                visibleHeight: 0)
        
        slideController?.onPanelExpanded = {
            self.viewForgotWrapper.alpha = 1
            self.viewForgotWrapper.isUserInteractionEnabled = true
            self.viewForgot.isUserInteractionEnabled = true

        }
        slideController?.onPanelCollapsed = {
            self.viewForgotWrapper.alpha = 0
            self.viewForgotWrapper.isUserInteractionEnabled = false
            self.viewForgot.isUserInteractionEnabled = false
        }
    }
    @IBAction func tappedTopView(_ sender: Any) {
        
        UIView.animate(withDuration: 0.5, animations: {
            self.slideController?.closePanel()
        })
    }
    @IBAction func emailFieldChanged(_ sender: Any) {
        fieldForgottenEmail.text = fieldForgottenEmail.text?.trimmingCharacters(in: .whitespaces)

    }
    
    @IBAction func tappedSubmit(_ sender: Any) {
        Auth.auth().sendPasswordReset(withEmail: fieldForgottenEmail.text!) { (error) in
            
            if error != nil {
                let alert = UIAlertController(title: "Something wrong happened", message: error?.localizedDescription, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .destructive, handler: nil))
                self.present(alert, animated: true, completion: nil)
            } else {
                
                // Everything went great
                let vc = UIStoryboard(name: "Login", bundle: nil).instantiateViewController(withIdentifier: "RecoveryPasswordViewController") as! RecoveryPasswordViewController
                vc.modalPresentationStyle = .fullScreen
                vc.email = self.fieldForgottenEmail.text!
                self.present(vc, animated: true, completion: nil)
            }
        }
    }
}
