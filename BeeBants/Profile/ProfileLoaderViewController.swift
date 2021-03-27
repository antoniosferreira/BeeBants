//
//  ProfileLoaderViewController.swift
//  BeeBants
//
//  Created by António Ferreira on 31/07/2020.
//  Copyright © 2020 BeeBants. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class ProfileLoaderViewController: UIViewController {
    
    lazy var functions = Functions.functions()

    @IBOutlet weak var loadingBee: UIImageView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        rotation(imageView: loadingBee, aCircleTime: 2.0)
        loadProfile()
    }
    
    
    private func rotation(imageView: UIImageView, aCircleTime: Double) { //UIView
        
        UIView.animate(withDuration: aCircleTime/2, delay: 0.0, options: .curveLinear, animations: {
            imageView.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi))
        }, completion: { finished in
            UIView.animate(withDuration: aCircleTime/2, delay: 0.0, options: .curveLinear, animations: {
                imageView.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi*2))
            }, completion: { finished in
                self.rotation(imageView: imageView, aCircleTime: aCircleTime)
            })
        })
    }
    
    
    private func loadProfile() {
        
        // Loads profile data
        functions.httpsCallable("readProfilings").call() {
            (result, error) in
                        
            if let error = error {
                
            }
            if let barData = (result?.data as? [String: Any])?["profileBar"] as? [String:Any],
               let resData = (result?.data as? [String: Any])?["profileRestaurant"] as? [String:Any],
               let username = (result?.data as? [String: Any])?["userName"] as? String {
    
                
                let barProfile = BarProfile(initData: barData)
                let resProfile = ResProfile(initData: resData)
                
                self.loadProfileView(username, barProfile: barProfile, resProfile: resProfile)
            } else {
                let alert = ProfileBadAlert(title: "Something went wrong", message: "Failed loading profile data", buttonTitle: "Try again", view: self)
                self.present(alert.getAlert(), animated: true, completion: {self.dismiss(animated: true, completion: nil);})
            }
        }
    }
    
    
    private func loadProfileView(_ username : String, barProfile: BarProfile, resProfile: ResProfile) {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Profile", bundle: nil)
        let newViewController = storyBoard.instantiateViewController(withIdentifier: "ProfileMain") as! ProfileViewController
        newViewController.modalPresentationStyle = .fullScreen
        
        
        newViewController.barProfile = barProfile
        newViewController.resProfile = resProfile
        newViewController.userName = username
        
        self.present(newViewController, animated: true, completion: nil)
    }
}
