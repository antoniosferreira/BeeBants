//
//  LoaderViewController.swift
//  BeeBants
//
//  Created by António Ferreira on 02/07/2020.
//  Copyright © 2020 BeeBants. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore
import FirebaseFirestoreSwift
import FirebaseStorage

class LoaderViewController: UIViewController {
    
    var pageController : PlacesPageViewController!

    private let db = Firestore.firestore()
    
    private var spotData : Spot?
    private var locationData : Location?
    
    @IBOutlet weak var loadingBee: UIImageView!
    // Loads from backend all data related with the place
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        rotate2(imageView: loadingBee, aCircleTime: 2.0)
        
    }
    
    func rotate2(imageView: UIImageView, aCircleTime: Double) { //UIView
            
            UIView.animate(withDuration: aCircleTime/2, delay: 0.0, options: .curveLinear, animations: {
                imageView.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi))
            }, completion: { finished in
                UIView.animate(withDuration: aCircleTime/2, delay: 0.0, options: .curveLinear, animations: {
                    imageView.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi*2))
                }, completion: { finished in
                    self.rotate2(imageView: imageView, aCircleTime: aCircleTime)
                })
            })
    }
    
    func initPlace() {


//        if (!pageController.option) { docName = "Restaurants" }
        let spotId = pageController.spotsToChooseFrom[pageController.spot][0]
        let barPath = spotId + ".json"
        
        // DOWNLOAD PLACE DATA
        let storageRef = Storage.storage().reference(forURL: "gs://beebants-bcf17.appspot.com/Manchester/BarsData")
            
        // Create a reference to the file you want to download
        let spotSuggestions = storageRef.child(barPath)

        // Permissions
        let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let localURL = documentsURL.appendingPathComponent("bar_" + barPath)
                
        // Download to the local filesystem
        spotSuggestions.write(toFile: localURL) {
            url, error in
                
            if let error = error {
                print(error)
            } else {
                
                do {
                    let data = try Data(contentsOf: localURL)
                    
                    let spot: Spot = try! JSONDecoder().decode(Spot.self, from: data)
                    self.spotData = spot
                    self.initLocation(locationUID: spot.locationID)
                    
                } catch {
                    // Catch any errors
                    print("Unable to read the file")
                }
            }
        }
    }
       
    func initLocation(locationUID: String) {
        let locationPath = locationUID + ".json"
        
        // DOWNLOAD PLACE DATA
        let storageRef = Storage.storage().reference(forURL: "gs://beebants-bcf17.appspot.com/Manchester/Locations/")
            
        // Create a reference to the file you want to download
        let locationFile = storageRef.child(locationPath)

        // Permissions
        let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let localURL = documentsURL.appendingPathComponent("location_" + locationPath)
                
        // Download to the local filesystem
        locationFile.write(toFile: localURL) {
            url, error in
                
            if let error = error {
                print(error)
            } else {
                
                do {
                    let data = try Data(contentsOf: localURL)
                    
                    let location: Location = try! JSONDecoder().decode(Location.self, from: data)
                    self.locationData = location
                    
                    
                    // Retrieves image
                    let imgPath = "Manchester/Locations/" + location.displayImgName
                    let storageRef = Storage.storage().reference(withPath: imgPath)


                    storageRef.getData(maxSize: (1 * 4194304 * 4194304)) {
                        (data, error) in
                        if let _error = error {
                            
                            // DEFAULT IMG
                            let img:UIImage! = UIImage(named: "bar_bg")

                            // UPDATES PAGE CONTROLLER CURRENT SPOT
                            self.pageController.setPlace(place: Place(spot: self.spotData!, location: self.locationData!), img: img)
                            self.pageController.startExperience()
                        }
                        
                        if let _data  = data {
                            // DOWNLOADED IMG
                            
                            let img:UIImage! = UIImage(data: _data)

                            // UPDATES PAGE CONTROLLER CURRENT SPOT
                            self.pageController.setPlace(place: Place(spot: self.spotData!, location: self.locationData!), img: img)
                            self.pageController.startExperience()
                        }
                    }
                    
                } catch {
                    // Catch any errors
                    print("Unable to read the file")
                }
            }
        }
        
        
        
        
        
        
        
//        let locationRef = db.collection("Locations").document(locationUID);
//        locationRef.getDocument {
//            (document, error) in
//            if let document = document, document.exists {
//
//                let name = document.get("Name") as! String
//                let img = document.get("Image") as! String
//                let desc = document.get("Description") as! String
                
//            }
//        }
    }
}
