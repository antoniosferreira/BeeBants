//
//  SpotSelectorViewController.swift
//  BeeBants
//
//  Created by António Ferreira on 01/06/2020.
//  Copyright © 2020 BeeBants. All rights reserved.
//

import UIKit
import CTSlidingUpPanel

class SpotSelectorViewController: UIViewController {
        
    var pageController : PlacesPageViewController!
    
    // Displayed Labels
    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var labelSubtitle: UILabel!
    @IBOutlet weak var labelSecret: UILabel!
    
    @IBOutlet weak var labelTitleDesc1: UILabel!
    @IBOutlet weak var labelValueDesc1: UILabel!
    
    @IBOutlet weak var labelTitleDesc2: UILabel!
    @IBOutlet weak var labelValueDesc2: UILabel!
    
    @IBOutlet weak var labelTitleDesc3: UILabel!
    @IBOutlet weak var labelValueDesc3: UILabel!
    
    @IBOutlet weak var labelTitleDesc4: UILabel!
    @IBOutlet weak var labelValueDesc4: UILabel!
    
    @IBOutlet weak var labelTitleDesc5: UILabel!
    @IBOutlet weak var labelValueDesc5: UILabel!
    
    lazy var displayedData = [labelTitleDesc1, labelValueDesc1,
                          labelTitleDesc2, labelValueDesc2,
                          labelTitleDesc3, labelValueDesc3,
                          labelTitleDesc4, labelValueDesc4,
                          labelTitleDesc5, labelValueDesc5,
                          labelSecret]
    
    // Interface Related Views
    @IBOutlet var mainView: UIView!
    @IBOutlet weak var slidePanelView: UIView!
    @IBOutlet weak var buttonsView: UIView!
    @IBOutlet weak var titleView: UIView!
    
    var slideController:CTBottomSlideController?
    @IBOutlet weak var slidingPanelTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var slidingPanelHeightConstraint: NSLayoutConstraint!
    
    // Buttons
    @IBOutlet weak var nextButton: RoundButton!
    @IBOutlet weak var changeButton: RoundButton!
    @IBOutlet weak var buttonShowMore: UIImageView!

    
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Slide Panel Management
        slideController = CTBottomSlideController(topConstraint: slidingPanelTopConstraint,
            heightConstraint: slidingPanelHeightConstraint,
            parent: view,
            bottomView: slidePanelView,
            tabController: self.tabBarController,
            navController: self.navigationController,
            visibleHeight: 0.52 * mainView.bounds.size.height
        )
        //visibleHeight: (self.buttonsView.bounds.size.height + (self.titleView.bounds.size.height * 2))
        slideController?.setSlideEnabled(true)
        
        // Animation of ShowMore Button
        slideController?.onPanelCollapsed = {
            self.buttonShowMore.alpha=1;
            UIView.animate(withDuration: 0.5, animations: {
                self.buttonShowMore.transform = CGAffineTransform(rotationAngle: 0)
            })
        }
        
        // Updates Slide Panel Information
        labelTitle.text = pageController.getPlace().location.name
        labelSubtitle.text = pageController.getPlace().location.description
        
        labelSecret.text = pageController.getPlace().spot.place_secret
        labelValueDesc1.text = pageController.getPlace().spot.place_dressCode
        labelValueDesc2.text = pageController.getPlace().spot.place_ambiance
        labelValueDesc3.text = pageController.getPlace().spot.place_speciality
        labelValueDesc4.text = pageController.getPlace().spot.place_bestTimes
        if (pageController.getPlace().spot.place_outsideArea == true) {
            labelValueDesc5.text = "yes"
        } else {
            labelValueDesc5.text = "no"
        }
    }

    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setUpBackground()
        setUpElements()

        // Unformizes all text fonts to display
        let smallestFontSize = displayedData.map{$0!.actualFontSize}.min()
        for label in displayedData {
            label?.font = label?.font.withSize(smallestFontSize!)
        }
    }
    
    
    func setUpBackground() {
        let backgroundImage = UIImageView(frame: UIScreen.main.bounds)
        backgroundImage.image = pageController.getPlace().location.img
        backgroundImage.contentMode =  UIView.ContentMode.scaleAspectFill
        backgroundImage.alpha = 1
        self.view.insertSubview(backgroundImage, at: 0)
    }
    

    func setUpElements() {
        Styling.styleRedFilledButton(button: nextButton)
        Styling.styleRedUnfilledButton(button: changeButton)
        
        // Round corners on slide view
        titleView.layer.cornerRadius = titleView.frame.size.height / 2
        titleView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
    }
    
    @IBAction func nextButtonTapped(_ sender: Any) {
        pageController.goLocation()
    }
    
    @IBAction func changeButtonTapped(_ sender: Any) {
        slideController?.hidePanel()
        pageController.changeSpot()
    }
    
    @IBAction func showInfo(_ sender: Any) {
        slideController?.expandPanel()
        UIView.animate(withDuration: 0.5, animations: {
            self.buttonShowMore.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi))
        })
        buttonShowMore.alpha = 0
    }
}