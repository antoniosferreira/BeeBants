//
//  HowToPageViewController.swift
//  BeeBants
//
//  Created by António Ferreira on 05/08/2020.
//  Copyright © 2020 BeeBants. All rights reserved.
//

import UIKit

class HowToPageViewController: UIPageViewController, UIPageViewControllerDataSource, UIPageViewControllerDelegate {

    var mainVC : HowToViewController?
    var pages : [ContentViewController] = []

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func loadPages() {
        let vc1 = UIStoryboard(name: "HowTo", bundle: nil).instantiateViewController(withIdentifier: "ContentViewController") as! ContentViewController
        let _ = vc1.view
        vc1.img.image = UIImage(named: "howto1")
        pages.append(vc1)
        
        let vc2 = UIStoryboard(name: "HowTo", bundle: nil).instantiateViewController(withIdentifier: "ContentViewController") as! ContentViewController
        let _ = vc2.view
        vc2.img.image = UIImage(named: "howto2")
        pages.append(vc2)

        
        let vc3 = UIStoryboard(name: "HowTo", bundle: nil).instantiateViewController(withIdentifier: "ContentViewController") as! ContentViewController
        let _ = vc3.view
        vc3.img.image = UIImage(named: "howto3")
        pages.append(vc3)

        
        let vc4 = UIStoryboard(name: "HowTo", bundle: nil).instantiateViewController(withIdentifier: "ContentViewController") as! ContentViewController
        let _ = vc4.view
        vc4.img.image = UIImage(named: "howto4")
        pages.append(vc4)

        
        let vc5 = UIStoryboard(name: "HowTo", bundle: nil).instantiateViewController(withIdentifier: "ContentViewController") as! ContentViewController
        let _ = vc5.view
        vc5.img.image = UIImage(named: "howto5")
        pages.append(vc5)
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
        guard let currentVC = viewController as? ContentViewController
        else {return nil}
        
        var index = pages.firstIndex(of: currentVC)!
        if (index == 0) {return nil}
        index -= 1

        return pages[index]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let currentVC = viewController as? ContentViewController
        else {return nil}
        
        var index = pages.firstIndex(of: currentVC)!

        if index >= self.pages.count - 1 { return nil }
        index += 1

        return pages[index]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool){
           
        let pageContentViewController = pageViewController.viewControllers![0]
        self.mainVC?.pageControl.currentPage = pages.firstIndex(of: pageContentViewController as! ContentViewController)!
    }
    
    func forward() -> Bool {
        guard let currentViewController = self.viewControllers?.first else { return false}
        guard let nextViewController = dataSource?.pageViewController( self, viewControllerAfter: currentViewController ) else { return true }
        
        let index = pages.firstIndex(of: currentViewController as! ContentViewController)!

        self.mainVC?.pageControl.currentPage = index + 1
        setViewControllers([nextViewController], direction: .forward, animated: false, completion: nil)
        
        return false
    }


}
