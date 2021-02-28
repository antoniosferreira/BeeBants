//
//  CreateProfileViewController.swift
//  BeeBants
//
//  Created by António Ferreira on 07/08/2020.
//  Copyright © 2020 BeeBants. All rights reserved.
//

import UIKit
import GoogleMobileAds

class CreateProfileViewController: UIViewController {

    @IBOutlet weak var buttonSure: RoundButton!
    @IBOutlet weak var buttonLater: RoundButton!
    
    @IBOutlet weak var label1: UILabel!
    @IBOutlet weak var label2: UILabel!
    lazy var labels = [label1, label2]
    
    private var fullAd : GADInterstitial?

    override func viewDidLoad() {
        super.viewDidLoad()

        fullAd = createAd()

        Styling.styleRedFilledButton(button: buttonSure)
        Styling.styleRedUnfilledButton(button: buttonLater)
        
        let smallesFontSize = labels.map{$0!.actualFontSize}.min()
        for label in labels {
            label?.font = label?.font.withSize(smallesFontSize!)
        }
    }
    

    @IBAction func tappedSureButton(_ sender: Any){
        let newViewController = UIStoryboard(name: "Profile", bundle: nil).instantiateViewController(withIdentifier: "ProfileLoaderViewController") as! ProfileLoaderViewController
        newViewController.modalPresentationStyle = .fullScreen
        present(newViewController, animated: true, completion: nil)
    }
    
    @IBAction func tappedLaterButton(_ sender: Any) {
        let newViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController
              newViewController.modalPresentationStyle = .fullScreen
        present(newViewController, animated: true, completion: nil)
    }
    
    private func createAd() -> GADInterstitial {
        let ad = GADInterstitial(adUnitID: Constants.profileAdId)
        ad.delegate = self
        ad.load(GADRequest())
        
        return ad
    }
}
