//
//  SignupPageViewController.swift
//  BeeBants
//
//  Created by António Ferreira on 06/08/2020.
//  Copyright © 2020 BeeBants. All rights reserved.
//

import UIKit

class SignupPageViewController: UIPageViewController, UIPageViewControllerDataSource, UIPageViewControllerDelegate {

    
    var mainView : SignupMainViewController?
    var pages : [SlideViewController] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        loadPages()
        setPageController()
    }
    

    /*
    // MARK: - PAGES RELATED COD
    */
    private func loadPages() {
        let vc1 = UIStoryboard(name: "Signup", bundle: nil).instantiateViewController(withIdentifier: "FirstSlideViewController") as! FirstSlideViewController
        vc1.pageController = self
        let _ = vc1.view
        pages.append(vc1)
        
        let vc2 = UIStoryboard(name: "Signup", bundle: nil).instantiateViewController(withIdentifier: "SecondSlideViewController") as! SecondSlideViewController
        vc2.pageController = self
        let _ = vc2.view
        pages.append(vc2)
        
        let vc3 = UIStoryboard(name: "Signup", bundle: nil).instantiateViewController(withIdentifier: "ThirdSlideViewController") as! ThirdSlideViewController
        vc3.pageController = self
        let _ = vc3.view
        pages.append(vc3)
        
        fixFontSizes()
    }
    
    func fixFontSizes() {
        let titleLabels = [
            (pages[0] as! FirstSlideViewController).labelNameTitle,
            (pages[0] as! FirstSlideViewController).labelEmailTitle,
            (pages[1] as! SecondSlideViewController).labelLocationTitle,
            (pages[1] as! SecondSlideViewController).labelDateTitle,
            (pages[2] as! ThirdSlideViewController).labelPasswordTitle,
        ]
        
        let badLabels = [
            (pages[0] as! FirstSlideViewController).labelBadEmail,
            (pages[1] as! SecondSlideViewController).labelBadDate,
            (pages[1] as! SecondSlideViewController).labelBadLocation,
            (pages[2] as! ThirdSlideViewController).labelBadPassword,
        ]
        
        let smallestFontSizeBad = badLabels.map{$0!.actualFontSize}.min()
        for label in badLabels {
            label?.font = label?.font.withSize(smallestFontSizeBad!)
        }
        
        let smallesFontSizeTitle = titleLabels.map{$0!.actualFontSize}.min()
        for label in titleLabels {
            label?.font = label?.font.withSize(smallesFontSizeTitle!)
        }
        for vc in pages {
            vc.view.setNeedsDisplay()
        }
    }
    
    
    private func setPageController() {
        self.dataSource = self
        self.delegate = self
        self.view.backgroundColor = .clear
        self.view.frame = self.view.frame
        
        self.setViewControllers([pages[0]], direction: .forward, animated: true, completion: nil)
        self.didMove(toParent: self)
    }

    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
        guard let currentVC = viewController as? SlideViewController else {
            return nil
        }
        var index = currentVC.index
        if (index == 0) {return nil}
        index -= 1
        return pages[index]
        
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        
        guard let currentVC = viewController as? SlideViewController else {
            return nil
        }
        var index = currentVC.index
    
        if index >= self.pages.count - 1 { return nil }
        index += 1
        return pages[index]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool){
        
        let pageContentViewController = pageViewController.viewControllers![0]
        self.mainView?.pageControl.currentPage = pages.firstIndex(of: pageContentViewController as! SlideViewController)!
    }
    
    func forward() -> Bool {
        guard let currentViewController = self.viewControllers?.first else { return false }
        guard let nextViewController = self.dataSource?.pageViewController( self, viewControllerAfter: currentViewController ) else { return true }
           

        let index = pages.firstIndex(of: currentViewController as! SlideViewController)!

        self.mainView?.pageControl.currentPage = index + 1
        setViewControllers([nextViewController], direction: .forward, animated: true, completion: nil)
         
        return false
    }
}
