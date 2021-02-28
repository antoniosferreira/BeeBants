//
//  MainViewController.swift
//  BeeBants
//
//  Created by António Ferreira on 27/02/2021.
//  Copyright © 2021 BeeBants. All rights reserved.
//

import UIKit
import FirebaseAuth


class MainViewController: UIViewController {

    @IBOutlet weak var loadingBee: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        rotation(imageView: loadingBee, aCircleTime: 2.0)
        Auth.auth().addStateDidChangeListener { (auth, user) in
            if Auth.auth().currentUser == nil {
                let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
                let nextViewController = storyBoard.instantiateViewController(withIdentifier: "Main_SB") as! AuthViewController
                nextViewController.modalPresentationStyle = .fullScreen //or .overFullScreen for transparency
                self.present(nextViewController, animated: true, completion: nil)
            } else {
                let storyBoard : UIStoryboard = UIStoryboard(name: "Home", bundle:nil)
                let nextViewController = storyBoard.instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController
                nextViewController.modalPresentationStyle = .fullScreen //or .overFullScreen for transparency
                self.present(nextViewController, animated: true, completion: nil)
            }
        }
        
        let storyBoard : UIStoryboard = UIStoryboard(name: "Home", bundle:nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController
        nextViewController.modalPresentationStyle = .fullScreen //or .overFullScreen for transparency
        self.present(nextViewController, animated: true, completion: nil)
       
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
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        
    }


}
