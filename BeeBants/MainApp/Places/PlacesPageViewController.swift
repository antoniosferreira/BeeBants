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

class PlacesPageViewController: UIPageViewController {
    
    // true: bar, false = restaurant
    var option : Bool = true

    // List with all suggestions received
    var spotsToChooseFrom : [[String]] = []
    var spot = 0
    
    // Current Displaying Place
    private var place : Place?
    var locationIMG : UIImage?

    
    
    // GETS SPOTS SUGGESTIONS FROM BACKEND
    func initializeSpots(view: LoaderViewController) {
        
        // COLLECT USER PROFILE DATA
        let db = Firestore.firestore()
        let docRef = db.collection("ProfilingBars").document(Auth.auth().currentUser!.uid)

        var encodedProfile = ""
        docRef.getDocument { (document, error) in
            if let document = document, document.exists {
                encodedProfile = document.get("encodedProfile") as! String
                encodedProfile.append(".json")
                // DOWNLOAD SPOT DATA
                let storageRef = Storage.storage().reference(forURL: "gs://beebants-bcf17.appspot.com/Manchester/BarsProfiled")
                
                // Create a reference to the file you want to download
                let barsSuggestions = storageRef.child(encodedProfile)

                // Permissions
                let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
                let localURL = documentsURL.appendingPathComponent("bar_suggestions.json")
                    
                // Download to the local filesystem
                barsSuggestions.write(toFile: localURL) {
                    url, error in
                    if let error = error {
                        print(error)
                    } else {
                        do {
                            let data = try Data(contentsOf: localURL)
                            let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers)

                            guard let barsJson = json as? [Dictionary<String, Any>] else {return}
                            for bar in barsJson {
                                let id = bar["id"] as! String
                                let latitude = bar["latitude"] as! String
                                let longitude = bar["longitude"] as! String
                                self.spotsToChooseFrom.append([id, latitude, longitude])
                            }
                            view.initPlace()
                        } catch {
                            // Catch any errors
                            print("Unable to read the file")
                        }
                    }
                }
            } else {
                print("Document does not exist")
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
       
    func setPlace(place: Place, img: UIImage) {
        self.place = place
        self.locationIMG = img
    }
}
