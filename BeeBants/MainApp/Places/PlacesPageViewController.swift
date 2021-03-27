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
import CoreLocation


class PlacesPageViewController: UIPageViewController {
    
    // True: Bar, False: Restaurant
    var isBar : Bool = true
    var specific : Int = 0

    // Gathered Spots suggested according
    // with user profile
    var gatheredSpots : [[String]] = []
    var spotSpecifics : [String:[Int]] = [:]
    var indexDisplayedSpot = 0
    
    // Current Displaying Spot
    private var place : Place?
    var currentLocationImg = UIImage(named: "bar_bg")
    
    
    
    let locationManager = CLLocationManager()

    
    override func viewDidLoad() {
        super.viewDidLoad()

        displayLoadingPage()
    }
    
    
    //  GATHERS SPOT SUGGESTIONS FROM FIREBASE
    /// [spotId, latitude, longitude]
    func gatherSpotsSuggestions(view: LoaderViewController) {
        
        
        if (!gatheredSpots.isEmpty) {
            view.initSpot(isBar)
            return
        }
        
        // Retrieves from server the encoded user profile
        let db = Firestore.firestore()
        var collection = "", url="", append=""
        
        if (isBar) {
            collection = "ProfilingBars"
            append = "bar_"
            url = "gs://beebants-bcf17.appspot.com/Manchester/BarsProfiled"
        } else {
            collection = "ProfilingRestaurants"
            append = "res_"
            url = "gs://beebants-bcf17.appspot.com/Manchester/ResProfiled"
        }
        let docRef = db.collection(collection).document(Auth.auth().currentUser!.uid)

        var encodedProfile = ""
        
        docRef.getDocument { (document, error) in
            if let document = document, document.exists {
                encodedProfile = document.get("encodedProfile") as! String
                encodedProfile.append(".json")
                
                // Gathering of spots suggestions
                // For given encoded profile
                let storageRef = Storage.storage().reference(forURL: url)
                let spotSuggestions = storageRef.child(encodedProfile)
                let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
                let localURL = documentsURL.appendingPathComponent(append+encodedProfile+".json")
                    
                // Download to the local filesystem
                spotSuggestions.write(toFile: localURL) { (url, error) in
                    if let _ = error {
                        self.dismiss(animated: true, completion: nil)
                    } else {
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
                                let specifics = spot["specifics"] as! [Int]
                                self.spotSpecifics[id] = specifics
                                self.gatheredSpots.append([id, latitude, longitude])
                            }
                            
                            
                            // On the loading Page, starts loading
                            // information of the spot
                            self.sortSpots(view: view)
                            
                            return
                        } catch {
                            // Couldn't read the file
                            self.dismiss(animated: true, completion: nil)
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
    
    func displayFeedbackView() {
        let viewController = UIStoryboard(name: "Places", bundle: nil).instantiateViewController(withIdentifier: "FeedbackViewSB") as! FeedbackViewController
        viewController.pageController = self
               
        self.setViewControllers([viewController], direction: .forward, animated: true, completion: nil)
    }
    
    func displayReportPage() {
        let viewController = UIStoryboard(name: "Places", bundle: nil).instantiateViewController(withIdentifier: "ReportViewSB") as! ReportViewController
        viewController.pageController = self
               
        self.setViewControllers([viewController], direction: .forward, animated: true, completion: nil)
    }
    
    func displayFinal() {
        let viewController = UIStoryboard(name: "Places", bundle: nil).instantiateViewController(withIdentifier: "FinalViewControllerSB") as! FinalPlacesViewController
        //viewController.pageController = self
               
        self.setViewControllers([viewController], direction: .forward, animated: true, completion: nil)
    }
    
    func displayFinalThanks() {
        let viewController = UIStoryboard(name: "Places", bundle: nil).instantiateViewController(withIdentifier: "FinalViewSB") as! FinalThanksViewController
        viewController.pageController = self
               
        self.setViewControllers([viewController], direction: .forward, animated: true, completion: nil)
    }
    
    
    func sortSpots(view: LoaderViewController) {
        let defaults = UserDefaults.standard
        locationManager.requestAlwaysAuthorization()
        
        // Regarding Actual Location Sorting
        if CLLocationManager.authorizationStatus() == .authorizedAlways ||
            CLLocationManager.authorizationStatus() == .authorizedWhenInUse {
            
            defaults.set(true, forKey: "LocationPermission")
            sortLocationPhase()
            sortSpecificsPhase()
            
        } else {
            defaults.set(false, forKey: "LocationPermission")
        }
        
        view.initSpot(isBar)
    }
    
    func sortSpecificsPhase() {
        var ids : [String] = []
        for x in gatheredSpots {
            if spotSpecifics[x[0]]!.contains(specific) {
                ids.append(x[0])
            }
        }
        
        for x in ids {
            for c in gatheredSpots.reversed() {
                if c[0] == x {
                    let element = gatheredSpots.remove(at: gatheredSpots.firstIndex(of: c)!)
                    gatheredSpots.insert(element, at: 0)
                }
            }
        }

    }
    
    func sortLocationPhase() {
        
        let myCurrentLocation = locationManager.location
        let myLatitude = myCurrentLocation?.coordinate.latitude
        let myLongitude = myCurrentLocation?.coordinate.longitude
        
        if myCurrentLocation == nil {
                return
        }
        
        var index = 0
        
        // Calculate Distances
        while (index <= gatheredSpots.count - 1) {
            let spotLatitude = Double(gatheredSpots[index][1])!
            let spotLongitude = Double(gatheredSpots[index][2])!
            gatheredSpots[index].remove(at: 2)
            gatheredSpots[index].remove(at: 1)
            
            
            let distance = DistanceCalculator.distance(lat1: myLatitude!, lon1: myLongitude!, lat2: spotLatitude, lon2: spotLongitude)
            gatheredSpots[index].append(String(distance))
            index += 1
        }
        
        
        
        let firstSlice = Int(round(Double(gatheredSpots.count / 4)))
        let secondSlice = Int(round(Double(gatheredSpots.count / 2)))
    
        _ = gatheredSpots[..<firstSlice].sorted(by: { return Double($0[1])! < Double($1[1])! })
        
        if firstSlice > 1 {
            _ = gatheredSpots[firstSlice..<secondSlice].sorted(by: { return Double($0[1])! < Double($1[1])! })
            _ = gatheredSpots[secondSlice...].sorted(by: { return Double($0[1])! < Double($1[1])! })
        }
    }
    
}
