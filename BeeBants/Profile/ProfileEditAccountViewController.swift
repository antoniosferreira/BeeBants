//
//  ProfileEditAccountViewController.swift
//  BeeBants
//
//  Created by António Ferreira on 07/08/2020.
//  Copyright © 2020 BeeBants. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseFunctions
import CoreLocation


class ProfileEditAccountViewController: UIViewController {
    
    var locManager : CLLocationManager?
    let defaults = UserDefaults.standard

    
    // BUTTONS
    @IBOutlet weak var buttonSubmitEmail: RoundButton!
    @IBOutlet weak var buttonSubmitPassword: RoundButton!
    
    // VIEWS
    @IBOutlet weak var viewEditEmail: UIView!
    @IBOutlet weak var viewEditPassword: UIView!
    
    // CONSTRAINTS
    private lazy var constraintEmailZeroHeight: NSLayoutConstraint = viewEditEmail.heightAnchor.constraint(equalToConstant: 0)
    private lazy var constraintPasswordZeroHeight: NSLayoutConstraint = viewEditPassword.heightAnchor.constraint(equalToConstant: 0)
    
    // FIELDS
    @IBOutlet weak var fieldEmail: RoundTextField!
    @IBOutlet weak var fieldEmailPassword: RoundTextField!
    @IBOutlet weak var fieldOldPassword: RoundTextField!
    @IBOutlet weak var fieldNewPassword: RoundTextField!
    
    @IBOutlet weak var gpsSwitch: UISwitch!
    
    // LABELS
    @IBOutlet weak var labelTitleEmail: UILabel!
    @IBOutlet weak var labelTitleNotification: UILabel!
    @IBOutlet weak var labelTitlePassword: UILabel!
    @IBOutlet weak var labelTitleGPS: UILabel!
    lazy var titlesLabel = [labelTitleEmail, labelTitleNotification, labelTitleGPS, labelTitlePassword]
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locManager = CLLocationManager()

        fieldEmail.alpha = 0
        fieldEmailPassword.alpha = 0
        buttonSubmitEmail.alpha = 0
        
        constraintEmailZeroHeight.isActive = true
        
        viewEditEmail.layer.cornerRadius = viewEditEmail.frame.size.height / 6
        viewEditEmail.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner, .layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        
        
        fieldOldPassword.alpha = 0
        fieldNewPassword.alpha = 0
        buttonSubmitPassword.alpha = 0
        
        constraintPasswordZeroHeight.isActive = true
        
        viewEditPassword.layer.cornerRadius = viewEditEmail.frame.size.height / 6
        viewEditPassword.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner, .layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        
        
        setUpElements()
        hideKeyboardWhenTappedAround()
        self.view.layoutIfNeeded()
    }

    
    
    func setUpElements() {
        fixFontSizes()
        Styling.styleWhiteField(field: fieldEmail, placeholder: "new e-mail")
        Styling.styleWhiteField(field: fieldEmailPassword, placeholder: "current password")
        
        Styling.styleWhiteField(field: fieldNewPassword, placeholder: "new password")
        Styling.styleWhiteField(field: fieldOldPassword, placeholder: "current password")

        if defaults.bool(forKey: "LocationPermission") {
            gpsSwitch.isOn = true
        } else {
            gpsSwitch.isOn = false
        }
        
    }
    
    func fixFontSizes() {
        let fontTitles = titlesLabel.map{$0!.actualFontSize}.min()
        for label in titlesLabel {
            label?.font = label?.font.withSize(fontTitles!)
            label?.setNeedsDisplay()
        }
    }

    
    @IBAction func tappedGoBack(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func tappedSignout(_ sender: Any) {
        do {
            try Auth.auth().signOut()
            self.view.window?.rootViewController?.dismiss(animated: true, completion: nil)
        } catch let signOutError as NSError {
          print ("Error signing out: %@", signOutError)
        }
    }
    
    @IBAction func tappedTerms(_ sender: Any) {
        let storyBoard: UIStoryboard = UIStoryboard(name: "TermsConditions", bundle: nil)
        let newViewController = storyBoard.instantiateViewController(withIdentifier: "TCViewController") as! TCViewController
        newViewController.modalPresentationStyle = .fullScreen
        self.present(newViewController, animated: true, completion: nil)
    }
    
    func hideKeyboardWhenTappedAround() {
          let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
          tap.cancelsTouchesInView = false
          view.addGestureRecognizer(tap)
      }

      @objc func dismissKeyboard() {
          view.endEditing(true)
      }
    
    @IBAction func openPasswordEdition(_ sender: Any) {
        let isOpen = (viewEditPassword.frame.height != 0) ? 0 : 1
        
        if (isOpen == 0) {
            constraintPasswordZeroHeight.isActive = true
        } else {
            constraintPasswordZeroHeight.isActive = false
        }
    
        UIView.animate(withDuration: 0.5, animations: {
            self.view.layoutIfNeeded()
            self.fieldOldPassword.alpha = CGFloat(isOpen)
            self.fieldNewPassword.alpha = CGFloat(isOpen)
            self.buttonSubmitPassword.alpha = CGFloat(isOpen)


        }, completion: nil)
    }
    
    @IBAction func openEmailEdition(_ sender: Any) {

        let isOpen = (viewEditEmail.frame.height != 0) ? 0 : 1
        
        if (isOpen == 0) {
            constraintEmailZeroHeight.isActive = true
        } else {
            constraintEmailZeroHeight.isActive = false
        }
    
        UIView.animate(withDuration: 0.5, animations: {
            self.view.layoutIfNeeded()
            self.fieldEmail.alpha = CGFloat(isOpen)
            self.fieldEmailPassword.alpha = CGFloat(isOpen)
            self.buttonSubmitEmail.alpha = CGFloat(isOpen)


        }, completion: nil)
    }
    
    @IBAction func tappedGPS(_ sender: Any) {
        locManager!.requestAlwaysAuthorization()
        
        let locationSetting = defaults.bool(forKey: "LocationPermission")
        if ((CLLocationManager.authorizationStatus() == .authorizedAlways || CLLocationManager.authorizationStatus() == .authorizedWhenInUse) && (locationSetting == false)){
            defaults.set(true, forKey: "LocationPermission")
        } else {
            defaults.set(false, forKey: "LocationPermission")
        }
        
        if defaults.bool(forKey: "LocationPermission") {
            gpsSwitch.isOn = true
        } else {
            gpsSwitch.isOn = false
        }
    }
    
    @IBAction func tapped_ChangeEmail(_ sender: Any) {
        if let email = fieldEmail.text, let password = fieldEmailPassword.text {
            let user = Auth.auth().currentUser
            let credential = EmailAuthProvider.credential(withEmail: user!.email!, password: password)
            
            user?.reauthenticate(with: credential) {authResult, error  in
              if let error = error {
                // FAILED REAUTHENTICATION
                let alert = UIAlertController(title: "Wrong password", message: error.localizedDescription, preferredStyle: .alert)

                alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))

                self.present(alert, animated: true)
              } else {
                // User re-authenticated.
                
                Auth.auth().currentUser?.updateEmail(to: email) { (error) in
                    if let error = error {
                        let alert = UIAlertController(title: "Failed to update email", message: error.localizedDescription, preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))

                        self.present(alert, animated: true)
                    } else {
                        let alert = UIAlertController(title: "Email updated", message: error?.localizedDescription, preferredStyle: .alert)
                      alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))

                      self.present(alert, animated: true)
                    }
                }
                
              }
            }
        }
    }
    
    
    @IBAction func tapped_ChangedPassword(_ sender: Any) {
        
        if let newpassowrd = fieldNewPassword.text, let oldpassword = fieldOldPassword.text {
            let user = Auth.auth().currentUser
            let credential = EmailAuthProvider.credential(withEmail: user!.email!, password: oldpassword)
            
            user?.reauthenticate(with: credential) {authResult, error  in
              if let error = error {
                // FAILED REAUTHENTICATION
                let alert = UIAlertController(title: "Wrong password", message: error.localizedDescription, preferredStyle: .alert)

                alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))

                self.present(alert, animated: true)
              } else {
                // User re-authenticated.
                
                Auth.auth().currentUser?.updatePassword(to: newpassowrd) { (error) in
                    if let error = error {
                        let alert = UIAlertController(title: "Failed to change password", message: error.localizedDescription, preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))

                        self.present(alert, animated: true)
                    } else {
                        let alert = UIAlertController(title: "Password changed", message: error?.localizedDescription, preferredStyle: .alert)
                      alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))

                      self.present(alert, animated: true)
                    }
                }
                
              }
            }
        }
    }
}
