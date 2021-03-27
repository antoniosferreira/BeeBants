//
//  SignupMainViewController.swift
//  BeeBants
//
//  Created by António Ferreira on 06/08/2020.
//  Copyright © 2020 BeeBants. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class SignupMainViewController: UIViewController {

    var pageController : SignupPageViewController?
    
    @IBOutlet weak var viewContainer: UIView!
    @IBOutlet weak var pageControl: UIPageControl!
    
    @IBOutlet weak var buttonNext: RoundButton!
    
    var tapped = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setUpBackground()
        setUpPageControl()
        initSignupViews()
        
        Styling.styleRedFilledButton(button: buttonNext)
    }
    
    private func setUpBackground() {
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
    
    private func setUpPageControl() {
        self.pageControl.numberOfPages = 3
        self.pageControl.currentPage = 0
    }
    
    private func initSignupViews() {
        pageController = SignupPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
        pageController!.mainView = self
        addChild(pageController!)
        pageController!.view.frame = viewContainer.frame
        viewContainer.addSubview(pageController!.view)
        pageController!.didMove(toParent: self)
    }
    
    @IBAction func tappedNextButton(_ sender: Any) {
        
        if (pageController!.forward()) {
            
            // CHECKS IF TC ARE ACCEPTED
            if !((pageController!.pages[2] as! ThirdSlideViewController).tc) {
                let alert = UIAlertController(title: "Terms & Conditions", message: "You must read and accept our T&Cs", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Got it", style: .destructive, handler: nil))
                      
                present(alert, animated: true, completion: nil)
                return
            }
            
            // IF SLOTS ARE NOT VALID
            for page in pageController!.pages {
                if (!page.validData()) {
                    let alert = UIAlertController(title: "Bad Signup", message: "Confirm the information you've provided", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Got it", style: .destructive, handler: nil))
                              
                    present(alert, animated: true, completion: nil)
                    return
                }
            }
            
            
            // PROCEEDS TO REGISTRATION
            self.register()
        }
    }
    

    @IBAction func tappedGoBack(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    

    func register() {
        if (tapped) {return}
        tapped = true
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        
        let name = (pageController!.pages[0] as! FirstSlideViewController).fieldName.text!
        let surname = (pageController!.pages[0] as! FirstSlideViewController).fieldSurname.text!
        let email = (pageController!.pages[0] as! FirstSlideViewController).fieldEmail.text!
        
        let date = dateFormatter.string(from:(pageController!.pages[1] as! SecondSlideViewController).fieldDate.date!)
        let nation = (pageController!.pages[1] as! SecondSlideViewController).fieldLocation.text!
        
        let password = (pageController!.pages[2] as! ThirdSlideViewController).fieldPassword.text!
        let news = (pageController!.pages[2] as! ThirdSlideViewController).tc
        
        Auth.auth().createUser(withEmail: email, password: password) {
            authResult, error in
            
            if error != nil {
                self.tapped = false
                
                let alert = UIAlertController(title: "Bad Sign Up", message: error?.localizedDescription, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Ok", style: .destructive, handler: nil))
                self.present(alert, animated: true, completion: nil)
                
            } else {
                let db = Firestore.firestore()
                
                db.collection("Users").document(authResult!.user.uid).setData([
                    "name":name, "surname": surname, "dateofbirth":date, "email": email, "nation":nation,
                    "newsletter":news, "uid":authResult!.user.uid]) {
                
                    (error) in
                    if error != nil {

                        let alert = UIAlertController(title: "Bad Sign Up", message: error?.localizedDescription, preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "Ok", style: .destructive, handler: nil))
                        self.present(alert, animated: true, completion: nil)
                        
                        
                    } else {
                        
                        // This is done at firebase level, now
//                        // Initializes new Profile from default
//                        db.collection("ProfilingBars").document(authResult!.user.uid).setData([
//                            "density1":true, "density2":true, "density3":true,
//                            "style1":true, "style2":true, "style3":true,
//                            "time1":true, "time2":true,
//                            "price":2, "name":name,
//                            "encodedProfile":"211111111",
//                            "uid":authResult!.user.uid, "version":0])
//
//
//                        db.collection("ProfilingRestaurants").document(authResult!.user.uid).setData([
//                            "amb1":true, "amb2":true, "amb3":true,
//                            "diet1":false, "diet2":false, "diet3":false, "diet4":false,
//                            "price":2, "name":name,
//                            "uid":authResult!.user.uid, "version":0])
//
                        
                        // GOES TO NEXT VIEW CONTROLLER AFTER SIGN UP
                        let vc = UIStoryboard(name: "HowTo", bundle: nil).instantiateViewController(withIdentifier: "HowToViewController") as! HowToViewController
                        vc.afterSignUp = true
                        vc.modalPresentationStyle = .fullScreen
                        self.present(vc, animated: true, completion: nil)
                        
                    }
                }
            }
            
        }
    }
}
