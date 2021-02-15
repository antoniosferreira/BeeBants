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
import Darwin

class LoaderViewController: UIViewController {
    
    var pageController : PlacesPageViewController!

    private let db = Firestore.firestore()
    
    private var spotData : Spot?
    private var locationData : Location?
    
    @IBOutlet weak var loadingBeeImg: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        rotate(imageView: loadingBeeImg, aCircleTime: 2.0)
    }
    
    func rotate(imageView: UIImageView, aCircleTime: Double) { //UIView
        UIView.animate(withDuration: aCircleTime/2, delay: 0.0, options: .curveLinear, animations: {
            imageView.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi))
        }, completion: { finished in
            UIView.animate(withDuration: aCircleTime/2, delay: 0.0, options: .curveLinear, animations: {
                imageView.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi*2))
            }, completion: { finished in
                self.rotate(imageView: imageView, aCircleTime: aCircleTime)
            })
        })
    }
    
    
    
    func initSpot(_ isBar: Bool) {
        
        //if (!pageController.option) { docName = "Restaurants" }
        
        let spotId = pageController.gatheredSpots[pageController.indexDisplayedSpot][0]
        let spotFilename = spotId + ".json"
        
        // Prepare download of Slot Information
        var url = ""
        var append = ""
        if (isBar){
            url = "gs://beebants-bcf17.appspot.com/Manchester/BarsData"
            append = "bar_"
        } else {
            url = "gs://beebants-bcf17.appspot.com/Manchester/ResData"
            append = "res_"
        }
        
        let storageRef = Storage.storage().reference(forURL: url)
        let spotFile = storageRef.child(spotFilename)
        let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let localURL = documentsURL.appendingPathComponent(append + spotFilename)
        
        // Download Slot Information to the local filesystem
        spotFile.write(toFile: localURL) { (url, error) in
            
            if let _ = error {
                exit(-1)
            } else {
                
                do {
                    let data = try Data(contentsOf: localURL)
                    
                    let spot: Spot = try! JSONDecoder().decode(Spot.self, from: data)
                    self.spotData = spot
                    self.initLocation(locationUID: spot.locationID)
                    
                } catch {
                    // Couldn't Download Spot Information
                    exit(-1)
                }
            }
        }
    }
    
       
    func initLocation(locationUID: String) {
       
        let locationPath = locationUID + ".json"
        
        // Prepare download of Location Information
        let storageRef = Storage.storage().reference(forURL: "gs://beebants-bcf17.appspot.com/Manchester/Locations/")
        let locationFile = storageRef.child(locationPath)
        let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let localURL = documentsURL.appendingPathComponent("location_" + locationPath)
                
        // Download to the local filesystem
        locationFile.write(toFile: localURL) { (url, error) in
            if let _ = error {
                exit(-1)
            } else {
                
                do {
                    let data = try Data(contentsOf: localURL)
                    let location: Location = try! JSONDecoder().decode(Location.self, from: data)
                    self.locationData = location
                    
                    // Retrieves Location Image
                    let imgPath = "Manchester/Locations/" + location.displayImgName
                    let storageRef = Storage.storage().reference(withPath: imgPath)
                    
                    storageRef.getData(maxSize: (1 * 4194304 * 4194304)) {
                        (data, error) in
                        if let _data  = data {
                            // DOWNLOADED IMG
                            
                            let img:UIImage! = UIImage(data: _data)

                            // UPDATES PAGE CONTROLLER CURRENT SPOT
                            self.pageController.setPlace(place: Place(spot: self.spotData!, location: self.locationData!, historyFile: "", feedback: 0), img: img)
                            self.pageController.displaySpotInitialView()
                        }
                    }
                    
                } catch {
                    exit(-1)
                }
            }
        }

    }
}
