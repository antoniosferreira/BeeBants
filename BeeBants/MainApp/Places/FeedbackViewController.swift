//
//  FeedbackViewController.swift
//  BeeBants
//
//  Created by António Ferreira on 15/01/2021.
//  Copyright © 2021 BeeBants. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore
import FirebaseFunctions

class FeedbackViewController: UIViewController {

    var pageController : PlacesPageViewController!
    lazy var functions = Functions.functions()

    @IBOutlet weak var button_report: RoundButton!

    @IBOutlet weak var button_star_1: UIImageView!
    @IBOutlet weak var button_star_2: UIImageView!
    @IBOutlet weak var button_star_3: UIImageView!
    @IBOutlet weak var button_star_4: UIImageView!
    @IBOutlet weak var button_star_5: UIImageView!
    
    lazy var feedbackButtons = [button_star_1, button_star_2, button_star_3, button_star_4, button_star_5]

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpBackground()
        Styling.styleRedUnfilledButton(button: button_report)
        
        updateRankingStars(0)
        
        // Saves trip for MyHistory
        let tripData : [String:Any] = [
            "cityName": "Manchester",
            "spotName": pageController!.getPlace().spot.displayName,
            "locImg": pageController!.getPlace().location.displayImgName,
            "review": 0]
        functions.httpsCallable("storeTripData").call(tripData) {
            (result, _) in
            
            if let tripReference = (result?.data as? [String: Any])?["tripRef"] as? String {
                self.pageController.getPlace().historyFile = tripReference
            }
        }
    }
    
    
    func setUpBackground() {
        let backgroundImage = UIImageView(frame: UIScreen.main.bounds)
        backgroundImage.image = UIImage(named: "Main_BG")
        backgroundImage.contentMode =  UIView.ContentMode.scaleAspectFill
        backgroundImage.alpha = 0.8
        
        let gradientMaskLayer = CAGradientLayer()
        gradientMaskLayer.frame = backgroundImage.bounds
        gradientMaskLayer.bounds = backgroundImage.bounds
        gradientMaskLayer.colors = [UIColor.clear.cgColor, UIColor.white.cgColor]
        gradientMaskLayer.locations = [0.4, 1]
        
        backgroundImage.layer.mask = gradientMaskLayer
        view.addSubview(backgroundImage)
        
        self.view.insertSubview(backgroundImage, at: 0)
    }
    
    
    
    func updateRankingStars(_ ranking: Int) {
        for r in 0...4 {
            feedbackButtons[r]?.image =
                UIImage(named: "Star_empty")
        }
        
        if (ranking != 0) {
            for r in 0...ranking-1 {
                feedbackButtons[r]?.image =
                    UIImage(named: "Star_full")
            }
        }
        
        pageController.getPlace().ranking = ranking
        
        
        if (ranking > 0) {
            
            // Updates feedback value on previosuly saved trip history
            let _: Void = Firestore.firestore().collection("History").document(pageController.getPlace().historyFile).updateData(["review":ranking])

            pageController.displayFinal()
        }
        
    }
    
    
    @IBAction func tapped_goBack(_ sender: Any) {
        pageController.displaySpotFinalView()
    }
    
    @IBAction func tapped_report(_ sender: Any) {
        pageController.displayReportPage()
    }
    
    
    
    @IBAction func tapped_feed1(_ sender: Any) {
        updateRankingStars(1)
    }
    @IBAction func tapped_feed2(_ sender: Any) {
        updateRankingStars(2)
    }
    @IBAction func tapped_feed3(_ sender: Any) {
        updateRankingStars(3)
    }
    @IBAction func tapped_feed4(_ sender: Any) {
        updateRankingStars(4)
    }
    @IBAction func tapped_feed5(_ sender: Any) {
        updateRankingStars(5)
    }
}
