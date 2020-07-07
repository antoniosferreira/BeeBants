//
//  LoaderViewController.swift
//  BeeBants
//
//  Created by António Ferreira on 02/07/2020.
//  Copyright © 2020 BeeBants. All rights reserved.
//

import UIKit
import FirebaseFunctions
import FirebaseAuth
import FirebaseFirestore
import FirebaseFirestoreSwift
import FirebaseStorage

class LoaderViewController: UIViewController {
    
    var pageController : PlacesPageViewController!

    private let db = Firestore.firestore()
    private let functions = Functions.functions()
    
    private var spotData : SpotStructure?
    private var locationData : LocationStructure?
    
    @IBOutlet weak var labelWaiting: UILabel!
    
    
    // Loads from backend all data related with the place
    func initPlace() {

        labelWaiting.text = String(pageController.option)

        var docName = "Bars"
        if (!pageController.option) { docName = "Restaurants" }
        let spotRef = db.collection(docName).document(pageController.spotsToChooseFrom[pageController.spot])
        
        // Gets restaurant Data
        spotRef.getDocument { (document, error) in
            if let document = document, document.exists {
                let name = document.get("Name") as! String
                let secret = document.get("Secret") as! String
                let ambiance = document.get("Ambiance") as! String
                let times = document.get("BestTimes") as! String
                let dressCode = document.get("DressCode") as! String
                let outside = document.get("OutsideArea") as! Bool
                let speciality = document.get("Speciality") as! String
                let location = document.get("Location") as! String
                let directions = document.get("Directions") as! String
                let latitude = document.get("Latitude") as! String
                let longitude = document.get("Longitude") as! String
                
                self.spotData = SpotStructure(placeName: name, placeSecret: secret, placeAmbiance: ambiance, placeBestTimes: times, placeDressCode: dressCode, placeOutsideArea: outside, placeSpeciality: speciality, placeLocation: location, placeDirections: directions, placeLatitude: latitude, placeLongitude: longitude)

                print("initLocation called")
                self.initLocation(locationUID: location)
            }
        }
    }
    
    func initLocation(locationUID: String) {
        print("initLocation starting")
        let locationRef = db.collection("Locations").document(locationUID);
        locationRef.getDocument {
            (document, error) in
            if let document = document, document.exists {
                print("initLocation 1")

                let name = document.get("Name") as! String
                let img = document.get("Image") as! String
                let desc = document.get("Description") as! String
                let imgPath = "Locations/" + img
                let storageRef = Storage.storage().reference(withPath: imgPath)
                
                print("initLocation 2")

                storageRef.getData(maxSize: (1 * 4194304 * 4194304)) {
                    (data, error) in
                    if let _error = error {
                        let img:UIImage! = UIImage(named: "bar_bg")
                        self.locationData = LocationStructure(name: name, desc: desc, img: img)
                    
                        // UPDATES PAGE CONTROLLER CURRENT SPOT
                        self.pageController.setPlace(place: Place(spot: self.spotData!, location: self.locationData!))
                        print("vamos tentar")
                        self.pageController.startExperience()
                    }
                    if let _data  = data {
                        print("initLocation 3")

                        let img:UIImage! = UIImage(data: _data)
                        self.locationData = LocationStructure(name: name, desc: desc, img: img)

                        // UPDATES PAGE CONTROLLER CURRENT SPOT
                        self.pageController.setPlace(place: Place(spot: self.spotData!, location: self.locationData!))
                        print("vamos tentar")
                        self.pageController.startExperience()
                    }
                }
            }
        }
    }
}
