//
//  SignUpPageViewController.swift
//  BeeBants
//
//  Created by António Ferreira on 01/04/2020.
//  Copyright © 2020 BeeBants. All rights reserved.
//

import UIKit

class SignUpPageViewController: UIPageViewController {
    
    var signUp: SignUpViewController!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        forward(index: 0)
    }
    
    func forward(index: Int) {
        let viewController = [getViewController(index: index)]
        self.setViewControllers(viewController , direction: .forward, animated: true, completion: nil)
    }
    
    func getViewController(index: Int) -> UIViewController {
        switch index {
        case 0 :
            let view = UIStoryboard(name: "Signup", bundle: nil).instantiateViewController(withIdentifier: "SU_1_SB") as! SU_NameEmailViewController
            view.signUp = self.signUp
            view.pageController = self
            return view
            
        case 1 :
            let view = UIStoryboard(name: "Signup", bundle: nil).instantiateViewController(withIdentifier: "SU_2_SB") as! SU_DateNationViewController
            view.signUp = self.signUp
            view.pageController = self
            return view
        default:
            return UIStoryboard(name: "Signup", bundle: nil).instantiateViewController(withIdentifier: "SU_1_SB") as UIViewController
        }
        
    }
    
}
