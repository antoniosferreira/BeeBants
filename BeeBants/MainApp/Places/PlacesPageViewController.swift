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
import Firebase
import Darwin


class PlacesPageViewController: UIPageViewController {
    
    // True: Bar, False: Restaurant
    var isBar : Bool = true

    // Gathered Spots suggested according
    // with user profile
    var gatheredSpots : [[String]] = []
    var indexDisplayedSpot = 0
    
    // Current Displaying Spot
    private var place : Place?
    var currentLocationImg = UIImage(named: "bar_bg")
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        displayLoadingPage()
    }
    
    
    //  GATHERS SPOT SUGGESTIONS FROM FIREBASE
    /// [spotId, latitude, longitude]
    func gatherSpotsSuggestions(view: LoaderViewController) {
        
        
        if (!gatheredSpots.isEmpty) {
            view.initSpot()
            return
        }
        
        // Retrieves from server the encoded user profile
        let db = Firestore.firestore()
        let docRef = db.collection("ProfilingBars").document(Auth.auth().currentUser!.uid)

        var encodedProfile = ""
        
        docRef.getDocument { (document, error) in
            if let document = document, document.exists {
                encodedProfile = document.get("encodedProfile") as! String
                encodedProfile.append(".json")
                
                // Gathering of spots suggestions
                // For given encoded profile
                let storageRef = Storage.storage().reference(forURL: "gs://beebants-bcf17.appspot.com/Manchester/BarsProfiled")
                let spotSuggestions = storageRef.child(encodedProfile)
                let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
                let localURL = documentsURL.appendingPathComponent("bar_"+encodedProfile+".json")
                    
                // Download to the local filesystem
                spotSuggestions.write(toFile: localURL) { (url, error) in
                    if let _ = error {
                        // The app crashes
                        exit(-1)
                    } else {
                        print("file downloaded")
                        // File downloaded, ready to parse it
                        do {
                            let data = try Data(contentsOf: localURL)
                            let jsonData = try JSONSerialization.jsonObject(with: data, options: .mutableContainers)

                            guard let spotsJson = jsonData as? [Dictionary<String, Any>]
                                else {exit(-1)}
                            
                            for spot in spotsJson {
                                let id = spot["id"] as! String
                                let latitude = spot["latitude"] as! String
                                let longitude = spot["longitude"] as! String
                                self.gatheredSpots.append([id, latitude, longitude])
                            }
                            
                            
                            // On the loading Page, starts loading
                            // information of the spot
                            //view.initPlace()
                            view.initSpot()
                            return
                        } catch {
                            // Couldn't read the file
                            exit(-1)
                        }
                    }
                }
            } else {
                // Couldn't read user profile
                exit(-1)
            }
        }
    }
    
    
    
    func changeSpot() {
        indexDisplayedSpot += 1
        
        // Spots are displayed circularly
        if (indexDisplayedSpot > (gatheredSpots.count - 1)) {
            indexDisplayedSpot = 0
        }
        
        self.displayLoadingPage()
    }
    
    func getPlace() -> Place {
        return place!
    }
       
    func setPlace(place: Place, img: UIImage) {
        self.place = place
        self.currentLocationImg = img
    }
    
    
    
    
    // UPDATE VIEW CONTROLLER AUXILIARY METHODS
    
    func displayLoadingPage() {
        let viewController = UIStoryboard(name: "Places", bundle: nil).instantiateViewController(withIdentifier: "LoaderViewController") as! LoaderViewController
        viewController.pageController = self
        
        self.setViewControllers([viewController], direction: .forward, animated: true, completion: nil)
        
        // FIX THIS
        gatherSpotsSuggestions(view: viewController)
    }
    
    func displaySpotInitialView() {
        let viewController = UIStoryboard(name: "Places", bundle: nil).instantiateViewController(withIdentifier: "SpotSelectorViewController") as! SpotSelectorViewController
        viewController.pageController = self

        self.setViewControllers([viewController], direction: .forward, animated: true, completion: nil)
    }
    
    
    func displayLocationPage() {
        let viewController = UIStoryboard(name: "Places", bundle: nil).instantiateViewController(withIdentifier: "LocationViewController") as! LocationViewController
        viewController.pageController = self
               
        self.setViewControllers([viewController], direction: .forward, animated: true, completion: nil)
    }
    
    func displaySpotFinalView() {
        let viewController = UIStoryboard(name: "Places", bundle: nil).instantiateViewController(withIdentifier: "SpotViewController") as! SpotViewController
        viewController.pageController = self
               
        self.setViewControllers([viewController], direction: .forward, animated: true, completion: nil)
    }
}
