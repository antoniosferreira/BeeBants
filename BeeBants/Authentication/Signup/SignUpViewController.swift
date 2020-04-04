//
//  SignUpViewController.swift
//  BeeBants
//
//  Created by António Ferreira on 01/04/2020.
//  Copyright © 2020 BeeBants. All rights reserved.
//

import UIKit


struct UserData {
    var name = ""
    var email = ""
}

class SignUpViewController: UIViewController {

    @IBOutlet weak var bbLogo: UIImageView!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    
    var userData : UserData = UserData()
    
    override func viewDidLoad() {
        super.viewDidLoad()
                
        setUpBackground()
        setUpElements()
    }
    
    func setUpElements() {
        let guestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        bbLogo.addGestureRecognizer(guestureRecognizer)
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
    
    @objc func handleTap() {
        let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "Main_SB") as UIViewController
        viewController.modalPresentationStyle = .fullScreen
        self.present(viewController, animated: true, completion: nil)
    }
    
    
   override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
       if  let vc = segue.destination as? SignUpPageViewController {
        vc.signUp = self
       }
    }
    
    func setNameAndEmail(name: String, email: String) {
        self.userData.name = name
        self.userData.email = email
    }
}


extension SignUpViewController {
    
    func keyboardWillShow(notification: Notification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.contentView.frame.origin.y == 0 {
                UIView.animate(withDuration: 0.25, animations: { () -> Void in
                    self.contentView.frame.origin.y -= keyboardSize.height
                })
            }
        }
        
    }
    
    func keyboardWillHide(notification: Notification) {
        if self.contentView.frame.origin.y != 0 {
            UIView.animate(withDuration: 0.25, animations: { () -> Void in
                self.contentView.frame.origin.y = 0
            })
        }
    }
    
}
