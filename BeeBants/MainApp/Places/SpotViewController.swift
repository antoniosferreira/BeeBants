//
//  SpotViewController.swift
//  BeeBants
//
//  Created by António Ferreira on 04/07/2020.
//  Copyright © 2020 BeeBants. All rights reserved.
//

import UIKit

class SpotViewController: UIViewController {

    var pageController : PlacesPageViewController!
    
    @IBOutlet weak var infoView: UIView!
    @IBOutlet weak var labelName: UILabel!
    @IBOutlet weak var labelDirections: UILabel!
    
    var popupMenu : UIAlertController?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        labelName.text = pageController?.getPlace().spot.place_name
        labelDirections.text = pageController?.getPlace().spot.place_directions
        
        infoView.layer.cornerRadius = infoView.frame.size.height / 6
        infoView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        
        let latitude = pageController!.getPlace().spot.place_latitude
        let longitude = pageController!.getPlace().spot.place_longitude
        
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
        pageController.goLocation()
    }
    
    @IBAction func tappedGoogleMaps(_ sender: Any) {
        present(popupMenu!, animated: true)
    }
    
}
