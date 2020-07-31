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
    
    private var barProfile : BarProfile?
    private var resProfile : ResProfile?
    
    @IBOutlet weak var loadingBee: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        rotation(imageView: loadingBee, aCircleTime: 2.0)
        startLoading()
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
    
    private func startLoading() {
        loadBarData()
    }
    
    private func loadBarData() {
        /* Starts Loading Bars Profile */
        let documentReference = Firestore.firestore().collection("ProfilingBars").document(Auth.auth().currentUser!.uid)
        
        documentReference.getDocument {
                
            (document, error) in
                
                if let error = error {
                    let alert = ProfileBadAlert(title: "Something went wrong", message: error.localizedDescription, buttonTitle: "Try again", view: self)
                    self.present(alert.getAlert(), animated: true, completion: nil)
                }
                                 
                /* LOADS BAR PROFILE */
                if let document = document, document.exists {
                    do {
                        try self.barProfile = BarProfile(document: document, documentReference: documentReference)
                        self.loadResData()
                    } catch {
                        // Impossible to load, returns to main home
                        ProfileBadAlert(title: "Something went wrong", message: error.localizedDescription, buttonTitle: "Try again", view: self)
                    }
                }
            }
    }
    
    private func loadResData() {
           /* Starts Loading Bars Profile */
        let documentReference = Firestore.firestore().collection("ProfilingRestaurants").document(Auth.auth().currentUser!.uid)
            
        documentReference.getDocument {
                   
               (document, error) in
                   
                   if let error = error {
                    let alert = ProfileBadAlert(title: "Something went wrong", message: error.localizedDescription, buttonTitle: "Try again", view: self)
                       self.present(alert.getAlert(), animated: true, completion: nil)
                   }
                                    
                   /* LOADS RES PROFILE */
                   if let document = document, document.exists {
                       do {
                        try self.resProfile = ResProfile(document: document, documentReference: documentReference)
                            self.loadProfileView()
                       } catch {
                           // Impossible to load, returns to main home
                        let alert = ProfileBadAlert(title: "Something went wrong", message: error.localizedDescription, buttonTitle: "Try again", view: self)
                           self.present(alert.getAlert(), animated: true, completion: nil)
                       }
                   }
               }
    }
    
    private func loadProfileView() {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Profile", bundle: nil)
        let newViewController = storyBoard.instantiateViewController(withIdentifier: "ProfileMain") as! ProfileViewController
        newViewController.modalPresentationStyle = .fullScreen
        
        newViewController.barProfile = barProfile
        newViewController.resProfile = resProfile
        
        self.present(newViewController, animated: true, completion: nil)
    }
}
