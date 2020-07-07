//
//  PlacesPageViewController.swift
//  BeeBants
//
//  Created by António Ferreira on 02/07/2020.
//  Copyright © 2020 BeeBants. All rights reserved.
//

import UIKit
import FirebaseFunctions
import FirebaseAuth

class PlacesPageViewController: UIPageViewController {
    
    // true: bar, false = restaurant
    var option : Bool = true

    // List with all suggestions received
    var spotsToChooseFrom : [String] = []
    var spot = 0
    
    // Current Displaying Place
    private var place : Place?
    

    
    
    // GETS SPOTS SUGGESTIONS FROM BACKEND
    func initializeSpots(view: LoaderViewController) {
        let functions = Functions.functions()
        
        // Init of spots recommendations
        var functionName = "getBars"
        if (!option) {functionName = "getRestaurants"}
        functions.httpsCallable(functionName).call(["uid": Auth.auth().currentUser!.uid]) {
            (result, error) in
            
            if let error = error as NSError? {
                print(error.localizedDescription)
            }
            
            if let spotsList = result?.data as? [String]  {
                print(spotsList)
                self.spotsToChooseFrom.append(contentsOf: spotsList)
                view.initPlace()
            }
        }
    }

    // INITIALIZES LOADING PAGE
    // LOADS DATA FROM PARTICULAR SPOT
    func startLoading() {
        let viewController = UIStoryboard(name: "Places", bundle: nil).instantiateViewController(withIdentifier: "LoaderViewController") as! LoaderViewController
        viewController.pageController = self
        self.setViewControllers([viewController], direction: .forward, animated: true, completion: nil)
        initializeSpots(view: viewController)
    }
    
    func startExperience() {
        print("ade")

        let viewController = UIStoryboard(name: "Places", bundle: nil).instantiateViewController(withIdentifier: "SpotSelectorViewController") as! SpotSelectorViewController
        print("adeus")

        viewController.pageController = self
        print("set")

        self.setViewControllers([viewController], direction: .forward, animated: true, completion: nil)
    }
    
    
    func goLocation() {
        let viewController = UIStoryboard(name: "Places", bundle: nil).instantiateViewController(withIdentifier: "LocationViewController") as! LocationViewController
        viewController.pageController = self
               
        self.setViewControllers([viewController], direction: .forward, animated: true, completion: nil)
        
    }
    
    func goPlace() {
        let viewController = UIStoryboard(name: "Places", bundle: nil).instantiateViewController(withIdentifier: "SpotViewController") as! SpotViewController
        viewController.pageController = self
               
        self.setViewControllers([viewController], direction: .forward, animated: true, completion: nil)
    }
    
    
    func changeSpot() {
        self.spot += 1
        self.startLoading()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        startLoading()
    }
    
    func getPlace() -> Place {
        return place!
    }
       
    func setPlace(place: Place) {
        self.place = place
    }
}
