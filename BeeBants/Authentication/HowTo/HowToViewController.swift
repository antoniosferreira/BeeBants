//
//  HowToViewController.swift
//  BeeBants
//
//  Created by António Ferreira on 08/04/2020.
//  Copyright © 2020 BeeBants. All rights reserved.
//

import UIKit

class HowToViewController: UIViewController, UIPageViewControllerDataSource, UIPageViewControllerDelegate {

    
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var nextButton: RoundButton!
    
    @IBOutlet weak var dot1: UIImageView!
    @IBOutlet weak var dot2: UIImageView!
    @IBOutlet weak var dot3: UIImageView!
    @IBOutlet weak var dot4: UIImageView!
    @IBOutlet weak var dot5: UIImageView!
    
    var dots : [UIImageView] = []
    
    var controllers = [UIViewController]()
    
    var pageController: UIPageViewController!
    var page = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dots.append(dot1)
        dots.append(dot2)
        dots.append(dot3)
        dots.append(dot4)
        dots.append(dot5)
        
        Styling.styleRedUnfilledButton(button: nextButton)
        
        pageController = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
        pageController.dataSource = self
        pageController.delegate = self

        
        addChild(pageController)
        
        contentView.addSubview(pageController.view)
        pageController.view.frame = self.contentView.bounds

        for c in 1 ... 5 {
            let vc = UIStoryboard(name: "HowTo", bundle: nil).instantiateViewController(withIdentifier: "CONTENT") as! ContentViewController

            vc.img = "howto" + String(c)
            vc.index = c-1
            controllers.append(vc)
        }
                
        pageController.setViewControllers([controllers[0]], direction: .forward, animated: true)
    }
    
    @IBAction func nextButtonTapped(_ sender: UIButton) {
        guard let currentViewController = self.pageController.viewControllers?.first else { return }

        guard let nextViewController = pageController.dataSource?.pageViewController( self.pageController, viewControllerAfter: currentViewController ) else { return }

        pageController.setViewControllers([nextViewController], direction: .forward, animated: true, completion: nil)
        updateDots()
    }
    
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {

        if let index = controllers.firstIndex(of: viewController) {
            if index > 0 {
                page = index - 1
                updateDots()
                return controllers[index - 1]
            } else {
                updateDots()
                return nil
            }
        }
        updateDots()
        return nil
    }

    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        print("swipe")
        if let index = controllers.firstIndex(of: viewController) {
            if index < controllers.count - 1 {
                page = index + 1
                updateDots()
                return controllers[index + 1]
            } else {
                updateDots()
                return nil
            }
        }
        updateDots()
        return nil
    }


    func updateDots() {
        let currentViewController = self.pageController.viewControllers?.first as! ContentViewController
        
        for c in 0...4 {
            dots[c].image = UIImage(named: "Circle_white")
        }
        for c in 0...currentViewController.index {
            dots[c].image = UIImage(named: "Circle_red")
        }
    }
}

