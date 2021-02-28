//
//  AuthViewController.swift
//  BeeBants
//
//  Created by António Ferreira on 30/03/2020.
//  Copyright © 2020 BeeBants. All rights reserved.
//

import UIKit
import FirebaseAuth
import CoreLocation


class AuthViewController: UIViewController {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var loginButton: UIButton!
    
    var locManager : CLLocationManager?

    let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setUpBackground()
        setUpElements()
        
        let launchedBefore = UserDefaults.standard.bool(forKey: "launchedBefore")
        if launchedBefore  {
            // continue
        } else {
            UserDefaults.standard.set(false, forKey: "LocationPermission")
            UserDefaults.standard.set(true, forKey: "launchedBefore")
        }
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        guard let currentUser = Auth.auth().currentUser else { return }
        currentUser.getIDTokenForcingRefresh(true, completion:  {
            (idToken, error) in
            if let error = error {
                    print(error.localizedDescription)
            } else {
                let storyBoard : UIStoryboard = UIStoryboard(name: "Home", bundle:nil)
                let nextViewController = storyBoard.instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController
                nextViewController.modalPresentationStyle = .fullScreen //or .overFullScreen for transparency
                self.present(nextViewController, animated: true, completion: nil)
            }
        })
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
        Styling.styleRedFilledButton(button: signUpButton)
        Styling.styleRedUnfilledButton(button: loginButton)
    }
}
