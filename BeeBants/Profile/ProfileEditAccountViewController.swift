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


class ProfileEditAccountViewController: UIViewController {
    
    // VIEWS
    @IBOutlet weak var viewEditEmail: UIView!
    
    // CONSTRAINTS
    private lazy var constraintEmailZeroHeight: NSLayoutConstraint = viewEditEmail.heightAnchor.constraint(equalToConstant: 0)
    
    // FIELDS
    @IBOutlet weak var fieldEmail: RoundTextField!
    
    
    // LABELS
    @IBOutlet weak var labelTitleEmail: UILabel!
    @IBOutlet weak var labelTitleNotification: UILabel!
    @IBOutlet weak var labelTitleGPS: UILabel!
    lazy var titlesLabel = [labelTitleEmail, labelTitleNotification, labelTitleGPS]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        fieldEmail.alpha = 0
        constraintEmailZeroHeight.isActive = true
        
        setUpElements()
        hideKeyboardWhenTappedAround()
        self.view.layoutIfNeeded()
        
        
        
        

        
    }
    
    
    func setUpElements() {
        fixFontSizes()
        Styling.styleWhiteField(field: fieldEmail, placeholder: "e-mail")
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

        }, completion: nil)
    }
    
}
