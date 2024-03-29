//
//  SpotViewController.swift
//  BeeBants
//
//  Created by António Ferreira on 04/07/2020.
//  Copyright © 2020 BeeBants. All rights reserved.
//

import UIKit
import GoogleMobileAds

class SpotViewController: UIViewController {

    var pageController : PlacesPageViewController!
    
    @IBOutlet weak var infoView: UIView!
    @IBOutlet weak var labelName: UILabel!
    @IBOutlet weak var labelDirections: UILabel!
    
    var popupMenu : UIAlertController?
    
    private var fullAd : GADInterstitial?
    

    
    override func viewDidLoad() {
        super.viewDidLoad()

        fullAd = createAd()
        
        labelName.text = pageController?.getPlace().spot.displayName
        labelDirections.text = pageController?.getPlace().spot.displayDirections
        
        infoView.layer.cornerRadius = infoView.frame.size.height / 6
        infoView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        
        setupOpenMaps()
        
        
            
    }
    
    func setupOpenMaps() {
        let latitude = pageController!.getPlace().spot.latitude
        let longitude = pageController!.getPlace().spot.longitude
        
        popupMenu = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        // GOOGLE MAPS SUPPORT
        popupMenu!.addAction(UIAlertAction(title: "Open in Google Maps", style: .default) { _ in
           if UIApplication.shared.canOpenURL(URL(string:"comgooglemaps://")!) {
               UIApplication.shared.open(URL(string:"comgooglemaps://?center=\(latitude),\(longitude)&zoom=14&views=traffic&q=\(latitude),\(longitude)")!, options: [:], completionHandler: nil)
           } else {
               //otherwise opens gmaps on web (safari)
               UIApplication.shared.open(URL(string: "http://maps.google.com/maps?q=loc:\(latitude),\(longitude)&zoom=14&views=traffic&q=\(latitude),\(longitude)")!, options: [:], completionHandler: nil)
           }
        })
        
        // APPLE MAPS SUPPORT
        popupMenu!.addAction(UIAlertAction(title: "Open in Apple Maps", style: .default) { _ in
            UIApplication.shared.open(URL(string:"http://maps.apple.com/maps?saddr=&daddr=\(latitude),\(longitude)")!)
        })
        
        // CANCEL BUTTON
        popupMenu!.addAction(UIAlertAction(title: "Close", style: .cancel) { _ in
            self.popupMenu!.dismiss(animated: true, completion: nil)
        })
    }
    
    @IBAction func tappedBackButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func tappedGoogleMaps(_ sender: Any) {
        present(popupMenu!, animated: true)
    }
    
    
    @IBAction func tap_goBack(_ sender: Any) {
        pageController.displayLocationPage()
    }
    
    
    @IBAction func tap_goFeedback(_ sender: Any) {
        pageController.displayFeedbackView()
    }
    
    private func createAd() -> GADInterstitial {
        let ad = GADInterstitial(adUnitID: Constants.spotAdId)
        ad.delegate = self
        ad.load(GADRequest())
        
        return ad
    }
}

