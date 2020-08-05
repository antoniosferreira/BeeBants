//
//  HowToViewController.swift
//  BeeBants
//
//  Created by António Ferreira on 05/08/2020.
//  Copyright © 2020 BeeBants. All rights reserved.
//

import UIKit

class HowToViewController: UIViewController {

    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var viewContainer: UIView!
    
    private var vc : HowToPageViewController?
    @IBOutlet weak var buttonNext: RoundButton!
    var afterSignUp = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        Styling.styleRedUnfilledButton(button: buttonNext)
        
        // Scale Page Control Dots
        pageControl.subviews.forEach {
            $0.transform = CGAffineTransform(scaleX: 2, y: 2)
        }
        
        vc = HowToPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
        
        self.addChild(vc!)
        vc!.view.frame = CGRect(x: 0, y: 0, width: self.viewContainer.frame.size.width, height: self.viewContainer.frame.size.height);
        self.viewContainer.addSubview(vc!.view)
        vc!.didMove(toParent: self)
        
        vc!.dataSource = vc
        vc!.delegate = vc
        
        vc!.mainVC = self
        vc!.loadPages()
        vc!.setViewControllers([vc!.pages[0]], direction: .forward, animated: true, completion: nil)
    }
    
    @IBAction func tappedNext(_ sender: Any) {
        
        // Always transits to next view
        if (vc!.forward()) {
            
            if (afterSignUp) {
                let newViewController = UIStoryboard(name: "Home", bundle: nil).instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController
                newViewController.modalPresentationStyle = .fullScreen
                present(newViewController, animated: true, completion: nil)
            
            } else {
                dismiss(animated: true, completion: nil)
            }
        }
    }
    
    @IBAction func tappedLogo(_ sender: Any) {
        if !(afterSignUp) {
            dismiss(animated: true, completion: nil)
        }
    }
}
