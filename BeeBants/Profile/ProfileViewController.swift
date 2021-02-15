//
//  ProfileViewController.swift
//  BeeBants
//
//  Created by António Ferreira on 28/07/2020.
//  Copyright © 2020 BeeBants. All rights reserved.
//

import UIKit
import FirebaseAuth

class ProfileViewController: UIViewController {
    
    var barProfile : BarProfile?
    var resProfile : ResProfile?
    var userName : String = ""
    
    // Display Elements
    @IBOutlet weak var labelUserName: UILabel!
    
    // Collapsable Views
    @IBOutlet weak var viewBarsHeader: UIView!
    @IBOutlet weak var viewBarsInfo: UIView!
    
    @IBOutlet weak var viewResHeader: UIView!
    @IBOutlet weak var viewResInfo: UIView!
    
    // Collapbsable Views Buttons
    @IBOutlet weak var buttonBarsOpen: UIImageView!
    @IBOutlet weak var viewBarSubheader: UIView!
    @IBOutlet weak var buttonResOpen: UIImageView!
    @IBOutlet weak var viewResSubheader: UIView!


    // LABELS
    @IBOutlet weak var labelBarsHeader: UILabel!
    @IBOutlet weak var labelResHeader: UILabel!
    lazy var profileTitles = [labelBarsHeader, labelResHeader]
    
    @IBOutlet weak var labelBarsPriceTitle: UILabel!
    @IBOutlet weak var labelBarsPrice: UILabel!
    @IBOutlet weak var labelBarsStyleTitle: UILabel!
    @IBOutlet weak var labelBarsStyle: UILabel!
    @IBOutlet weak var labelBarsDensityTitle: UILabel!
    @IBOutlet weak var labelBarsDensity: UILabel!
    @IBOutlet weak var labelBarsTimeTitle: UILabel!
    @IBOutlet weak var labelBarsTime: UILabel!
    
    @IBOutlet weak var labelResPriceTitle: UILabel!
    @IBOutlet weak var labelResPrice: UILabel!
    @IBOutlet weak var labelResDietaryTitle: UILabel!
    @IBOutlet weak var labelResDietary: UILabel!
    @IBOutlet weak var labelResAmbianceTitle: UILabel!
    @IBOutlet weak var labelResAmbiance: UILabel!
    lazy var labelProfileData = [labelBarsPriceTitle, labelBarsStyleTitle, labelBarsDensityTitle, labelBarsTimeTitle, labelResPriceTitle, labelResDietaryTitle, labelResAmbianceTitle, labelBarsPrice, labelBarsStyle, labelBarsDensity, labelBarsTime, labelResPrice, labelResDietary, labelResAmbiance]
    
    // Constraints for collapsing
    private lazy var constraintBarsZeroHeight: NSLayoutConstraint = viewBarsInfo.heightAnchor.constraint(equalToConstant: 0)
    private lazy var constraintResZeroHeight: NSLayoutConstraint = viewResInfo.heightAnchor.constraint(equalToConstant: 0)
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.viewDidLayoutSubviews()
        
        setUpBackground()
        updateDisplayedData()
        
        // STYLING
        viewBarSubheader.alpha = 0
        viewResSubheader.alpha = 0
        
        viewBarsHeader.layer.masksToBounds = false
        viewBarsHeader.clipsToBounds = true
        viewResHeader.layer.masksToBounds = false
        viewResHeader.clipsToBounds = true
        
        buttonBarsOpen.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi))
        buttonResOpen.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi))
        
        constraintBarsZeroHeight.isActive = true
        constraintResZeroHeight.isActive = true
        
        view.layoutIfNeeded()
        
        viewBarsHeader.layer.cornerRadius = viewBarsHeader.layer.bounds.height * 0.49
        viewResHeader.layer.cornerRadius = viewResHeader.layer.bounds.height * 0.49
        
        viewBarsInfo.layer.cornerRadius = 25
        viewBarsInfo.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        viewResInfo.layer.cornerRadius = 25
        viewResInfo.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        
        fixFontSizes()
        view.layoutIfNeeded()
    }
    
    
    private func setUpBackground() {
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
    
    
    private func fixFontSizes() {
        let fontTitles = profileTitles.map{$0!.actualFontSize}.min()
        for label in profileTitles {
            label?.font = label?.font.withSize(fontTitles!)
            label?.setNeedsDisplay()
        }
        for label in profileTitles {
            label?.adjustsFontSizeToFitWidth = true
            label?.minimumScaleFactor = 0.1
            label?.setNeedsDisplay()
            label?.textAlignment = .left
            label?.numberOfLines = 1
            label?.lineBreakMode = .byClipping
            label?.baselineAdjustment = .alignCenters
            
            label?.sizeToFit()
        }
       
        for label in labelProfileData {
            label?.adjustsFontSizeToFitWidth = true
            label?.minimumScaleFactor = 0.5
            label?.setNeedsDisplay()
        }
        let fontDataTitles = labelProfileData.map{$0!.actualFontSize}.min()
        for label in labelProfileData {
            label?.font = label?.font.withSize(fontDataTitles!)
            label?.setNeedsDisplay()
        }
    }
    
    
    func updateDisplayedData() {
        labelUserName.text = userName
        
        // BAR RELATED DATA
        switch (barProfile!.price) {
            case 0 : labelBarsPrice.text = "£"
            case 1 : labelBarsPrice.text = "££"
            case 2 : labelBarsPrice.text = "£££"
            
            default: break
        }
        
        var style = ""
        if (barProfile!.style[0]) {style += "Casual\n"}
        if (barProfile!.style[1]) {style += "Up-market\n"}
        if (barProfile!.style[2]) {style += "Down and Dirty\n"}
        labelBarsStyle.text = String(style.dropLast())
        
        var density = ""
        if (barProfile!.density[0]) {density += "Calm\n"}
        if (barProfile!.density[1]) {density += "Crowded\n"}
        if (barProfile!.density[2]) {density += "Banging\n"}
        labelBarsDensity.text = String(density.dropLast())
        
        var time = ""
        if (barProfile!.time[0]) {time += "Day\n"}
        if (barProfile!.time[1]) {time += "Night\n"}
        labelBarsTime.text = String(time.dropLast())
        
        // RESTAURANTS RELATED DATA
        switch (resProfile?.price) {
            case 0 : labelResPrice.text = "£"
            case 1 : labelResPrice.text = "££"
            case 2 : labelResPrice.text = "£££"
            default: break
        }
        
        var dietary = ""
        if (resProfile!.dietary[0]) {dietary += "Vegan\n"}
        if (resProfile!.dietary[1]) {dietary += "Vegetarian\n"}
        if (resProfile!.dietary[2]) {dietary += "Halal\n"}
        if (resProfile!.dietary[3]) {dietary += "Pescetarian\n"}
        if dietary == "" {dietary = "None\n"}
        labelResDietary.text = String(dietary.dropLast())
        
        var ambiance = ""
        if (resProfile!.ambiance[0]) {ambiance += "Cosy\n"}
        if (resProfile!.ambiance[1]) {ambiance += "Romantic\n"}
        if (resProfile!.ambiance[2]) {ambiance += "Lively\n"}
        labelResAmbiance.text = String(ambiance.dropLast())
    }
    
    
    @IBAction func tapOpenBars(_ sender: Any) {
        let isOpen = (viewBarsInfo.frame.height != 0) ? 0 : 1
        var rotationAngle = CGFloat(0)
        
        if (isOpen == 0) {
            rotationAngle = CGFloat(Double.pi)
            constraintBarsZeroHeight.isActive = true
        } else {
            constraintBarsZeroHeight.isActive = false
        }
        
        UIView.animate(withDuration: 0.5, animations: {
            self.buttonBarsOpen.transform = CGAffineTransform(rotationAngle: rotationAngle)
            self.view.layoutIfNeeded()
            self.viewBarSubheader.alpha = CGFloat(1)
        }, completion: {(finished) in self.viewBarSubheader.alpha = CGFloat(isOpen)})
    }
    
    
    @IBAction func tapOpenRes(_ sender: Any) {
        let isOpen = (viewResInfo.frame.height != 0) ? 0 : 1
        var rotationAngle = CGFloat(0)
        
        if (isOpen == 0) {
            rotationAngle = CGFloat(Double.pi)
            constraintResZeroHeight.isActive = true
        } else {
            constraintResZeroHeight.isActive = false
        }
        
        
        UIView.animate(withDuration: 0.5, animations: {
            self.buttonResOpen.transform = CGAffineTransform(rotationAngle: rotationAngle)
            self.view.layoutIfNeeded()
            self.viewResSubheader.alpha = CGFloat(1)
        }, completion: {(finished) in self.viewResSubheader.alpha = CGFloat(isOpen)})
    }
    
    
    
    @IBAction func tapEditBars(_ sender: Any) {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Profile", bundle: nil)
        let newViewController = storyBoard.instantiateViewController(withIdentifier: "BarEditorViewController") as! BarEditorViewController
        
        newViewController.modalPresentationStyle = .fullScreen
        newViewController.oldBarProfile = barProfile
        newViewController.profileViewController = self
        
        self.present(newViewController, animated: true, completion: nil)
    }
    
    
    @IBAction func tapEditRes(_ sender: Any) {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Profile", bundle: nil)
        let newViewController = storyBoard.instantiateViewController(withIdentifier: "ResEditorViewController") as! ResEditorViewController
        
        newViewController.modalPresentationStyle = .fullScreen
        newViewController.oldResProfile = resProfile
        newViewController.profileViewController = self
        
        self.present(newViewController, animated: true, completion: nil)
    }
    
    
    @IBAction func tapEditAccount(_ sender: Any) {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Profile", bundle: nil)
        let newViewController = storyBoard.instantiateViewController(withIdentifier: "ProfileEditAccountViewController") as! ProfileEditAccountViewController
        
        newViewController.modalPresentationStyle = .fullScreen
        
        self.present(newViewController, animated: true, completion: nil)
    }
    
    
    @IBAction func tappedGoBack(_ sender: Any) {
        self.view.window?.rootViewController?.dismiss(animated: true, completion: nil)
    }
    
}
