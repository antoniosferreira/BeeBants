//
//  SignUpViewController.swift
//  BeeBants
//
//  Created by António Ferreira on 01/04/2020.
//  Copyright © 2020 BeeBants. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseFirestore

struct UserData {
    var name = ""
    var email = ""
    var date = ""
    var nation = ""
    var news = false
    var password = ""
}

class SignUpViewController: UIViewController {

    @IBOutlet weak var bbLogo: UIImageView!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    
    var userData : UserData = UserData()
    var signUpController : SignUpPageViewController? = nil
    
    @IBOutlet weak var c1: UIImageView!
    @IBOutlet weak var c2: UIImageView!
    @IBOutlet weak var c3: UIImageView!
    @IBOutlet weak var c4: UIImageView!
    
    
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
        self.signUpController = vc
       }
    }
    
    func setNameAndEmail(name: String, email: String) {
        self.userData.name = name
        self.userData.email = email
    }
    
    func setDateAndNation(date: String, nation: String) {
        self.userData.date = date
        self.userData.nation = nation
    }
    
    func setPassNews(password: String, news: Bool) {
        self.userData.password = password
        self.userData.news = news
    }
    
    func register() {
        
        Auth.auth().createUser(withEmail: self.userData.email, password: self.userData.password) {
            authResult, error in
            
            if error != nil {
                let alert = UIAlertController(title: "Bad Sign Up", message: error?.localizedDescription, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Start again", style: .destructive, handler: nil))
                self.present(alert, animated: true, completion: nil)
                self.signUpController?.forward(index: 0)

            } else {
                let db = Firestore.firestore()
                db.collection("users").addDocument(data: ["name":self.userData.name,"dateofbirth":self.userData.date, "nation":self.userData.nation, "newsletter":self.userData.news, "uid":authResult!.user.uid]) {
                    
                    (error) in
                    if error != nil {
                        let alert = UIAlertController(title: "Bad Sign Up", message: error?.localizedDescription, preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "Start again", style: .destructive, handler: nil))
                        self.present(alert, animated: true, completion: nil)
                        self.signUpController?.forward(index: 0)

                    } else {
                        // Everythint went fine
                        
                        self.signUpController?.forward(index: 3)
                    }
                }
            }
            
        }
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
