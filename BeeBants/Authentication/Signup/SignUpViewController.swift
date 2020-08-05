//
//  SignUpViewController.swift
//  BeeBants
//
//  Created by António Ferreira on 04/08/2020.
//  Copyright © 2020 BeeBants. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class SignUpViewController: UIPageViewController, UIPageViewControllerDataSource, UIPageViewControllerDelegate {

    var mainView : SignUpMainViewController?
    var pageController : SignUpPageViewController?
    var pages : [SlideViewController] = []
    
    var tapped = false
    override func viewDidLoad() {
        super.viewDidLoad()
            
        loadPages()
        setPageController()
    }

    private func loadPages() {
        let vc1 = UIStoryboard(name: "Signup", bundle: nil).instantiateViewController(withIdentifier: "FirstSlideViewController") as! FirstSlideViewController
        vc1.signViewController = self
        let _ = vc1.view
        pages.append(vc1)
        
        let vc2 = UIStoryboard(name: "Signup", bundle: nil).instantiateViewController(withIdentifier: "SecondSlideViewController") as! SecondSlideViewController
        vc2.signViewController = self
        let _ = vc2.view
        pages.append(vc2)
        
        let vc3 = UIStoryboard(name: "Signup", bundle: nil).instantiateViewController(withIdentifier: "ThirdSlideViewController") as! ThirdSlideViewController
        vc3.signViewController = self
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
            (pages[0] as! FirstSlideViewController).labelBadName,
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
    }
    
    private func setPageController() {
        self.pageController = SignUpPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
        self.pageController?.dataSource = self
        self.pageController?.delegate = self
        self.pageController?.view.backgroundColor = .clear
        self.pageController?.view.frame = self.view.frame
        self.addChild(self.pageController!)
        self.view.addSubview(self.pageController!.view)
        
        
        self.pageController?.setViewControllers([pages[0]], direction: .forward, animated: true, completion: nil)
        self.pageController?.didMove(toParent: self)
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
    
    /*
        REGISTER TO FIREBASE
     */
    func register() {
        if (tapped) {return}
        tapped = true
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        
        print(pages[0].validData())
        print(pages[1].validData())
        print(pages[2].validData())

        if (!(pages[0].validData() &&
            pages[1].validData() &&
            pages[2].validData())) {
            
            let alert = UIAlertController(title: "Bad Sign Up", message: "Confirm your information", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .destructive, handler: nil))
            self.present(alert, animated: true, completion: nil)
            
            print("heredfd")
            tapped = false
            return
        }
        
        
        let name = (pages[0] as! FirstSlideViewController).fieldName.text!
        let email = (pages[0] as! FirstSlideViewController).fieldEmail.text!
        
        let date = dateFormatter.string(from:(pages[1] as! SecondSlideViewController).fieldDate.date!)
        let nation = (pages[1] as! SecondSlideViewController).fieldLocation.text!
        
        let password = (pages[2] as! ThirdSlideViewController).fieldPassword.text!
        let news = (pages[2] as! ThirdSlideViewController).tc
        
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
                    "name":name,"dateofbirth":date, "email": email, "nation":nation,
                    "newsletter":news, "uid":authResult!.user.uid]) {
                
                    (error) in
                    if error != nil {

                        let alert = UIAlertController(title: "Bad Sign Up", message: error?.localizedDescription, preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "Ok", style: .destructive, handler: nil))
                        self.present(alert, animated: true, completion: nil)
                        
                        
                    } else {
                        
                        // Initializes new Profile from default
                        db.collection("ProfilingBars").document(authResult!.user.uid).setData([
                            "density1":true, "density2":true, "density3":true,
                            "style1":true, "style2":true, "style3":true,
                            "time1":true, "time2":true,
                            "price":2, "name":name,
                            "uid":authResult!.user.uid, "version":0])
                        
                        
                        db.collection("ProfilingRestaurants").document(authResult!.user.uid).setData([
                            "amb1":true, "amb2":true, "amb3":true,
                            "diet1":false, "diet2":false, "diet3":false, "diet4":false,
                            "price":2, "name":name,
                            "uid":authResult!.user.uid, "version":0])
                        
                        
                        // GOES TO NEXT VIEW CONTROLLER AFTER SIGN UP
                        let vc = UIStoryboard(name: "Signup", bundle: nil).instantiateViewController(withIdentifier: "FinalViewController") as! FinalViewController
                        vc.modalPresentationStyle = .fullScreen
                        self.present(vc, animated: true, completion: nil)
                        
                    }
                }
            }
            
        }
    }
}
