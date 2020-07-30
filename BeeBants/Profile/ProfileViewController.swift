//
//  ProfileViewController.swift
//  BeeBants
//
//  Created by António Ferreira on 28/07/2020.
//  Copyright © 2020 BeeBants. All rights reserved.
//

import UIKit
import FirebaseAuth
import Firebase

class ProfileViewController: UIViewController {
    
    
    private var barProfiling : BarProfile?
    private var resProfiling : ResProfile?
    
    @IBOutlet weak var labelUserName: UILabel!
    
    // VIEWS
    @IBOutlet weak var viewBarsHeader: UIView!
    @IBOutlet weak var viewBarsInfo: UIView!
    
    @IBOutlet weak var viewResHeader: UIView!
    @IBOutlet weak var viewResInfo: UIView!
    
    @IBOutlet weak var buttonBarsOpen: UIImageView!
    @IBOutlet weak var viewBarSubheader: UIView!
    private lazy var constraintBarsZeroHeight: NSLayoutConstraint = viewBarsInfo.heightAnchor.constraint(equalToConstant: 0)
    
    
    @IBOutlet weak var buttonResOpen: UIImageView!
    @IBOutlet weak var viewResSubheader: UIView!
    private lazy var constraintResZeroHeight: NSLayoutConstraint = viewResInfo.heightAnchor.constraint(equalToConstant: 0)
    
    
    // LABELS
    @IBOutlet weak var labelBarsHeader: UILabel!
    @IBOutlet weak var labelResHeader: UILabel!
    lazy var displayedData = [labelBarsHeader, labelResHeader]
       
    
    @IBOutlet weak var labelBarsPrice: UILabel!
    @IBOutlet weak var labelBarsStyle: UILabel!
    @IBOutlet weak var labelBarsDensity: UILabel!
    @IBOutlet weak var labelBarsTime: UILabel!
    @IBOutlet weak var labelResPrice: UILabel!
    @IBOutlet weak var labelResDietary: UILabel!
    @IBOutlet weak var labelResAmbiance: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setUpBackground()
        
        viewBarSubheader.alpha = 0
        viewResSubheader.alpha = 0
        
        viewBarsHeader.layer.cornerRadius = viewBarsHeader.frame.size.height / 4
        viewResHeader.layer.cornerRadius = viewResHeader.frame.size.height / 4

        viewBarsInfo.layer.cornerRadius = viewBarsInfo.frame.size.height / 8
        viewBarsInfo.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        viewResInfo.layer.cornerRadius = viewResInfo.frame.size.height / 8
        viewResInfo.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]

        buttonBarsOpen.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi))
        buttonResOpen.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi))

        constraintBarsZeroHeight.isActive = true
        constraintResZeroHeight.isActive = true
        
        let smallestFontSize = displayedData.map{$0!.actualFontSize}.min()
        for label in displayedData {
            label?.font = label?.font.withSize(smallestFontSize!)
        }
        
        view.layoutIfNeeded()
        loadData()
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
    
    

    @IBAction func tapOpenBars(_ sender: Any) {
        let isOpen = (viewBarsInfo.frame.height != 0) ? 0 : 1
        var rotationAngle = CGFloat(0)
        
        if (isOpen == 0) {
            rotationAngle = CGFloat(Double.pi)
            constraintBarsZeroHeight.isActive = true
        } else {
            viewBarSubheader.alpha = CGFloat(1)
            constraintBarsZeroHeight.isActive = false
        }
        
        UIView.animate(withDuration: 0.5, animations: {
            self.buttonBarsOpen.transform = CGAffineTransform(rotationAngle: rotationAngle)
            self.view.layoutIfNeeded()
        }, completion: {(finished) in self.viewBarSubheader.alpha = CGFloat(isOpen)})
    }
    
    
    @IBAction func tapResOpen(_ sender: Any) {
        let isOpen = (viewResInfo.frame.height != 0) ? 0 : 1
        var rotationAngle = CGFloat(0)

        if (isOpen == 0) {
            rotationAngle = CGFloat(Double.pi)
            constraintResZeroHeight.isActive = true
        } else {
            viewResSubheader.alpha = CGFloat(1)
            constraintResZeroHeight.isActive = false
        }
        
        UIView.animate(withDuration: 0.5, animations: {
            self.buttonResOpen.transform = CGAffineTransform(rotationAngle: rotationAngle)
            self.view.layoutIfNeeded()
        }, completion: {(finished) in self.viewResSubheader.alpha = CGFloat(isOpen)})
    }
    
    
    private func loadData() {
        let db = Firestore.firestore()
        let userRef = db.collection("users").document(Auth.auth().currentUser!.uid);
        
        userRef.getDocument { (document, error) in

            if let error = error {
                print(error)
            }
            if let document = document, document.exists {

                if let name = document.get("name") as? String {
                    if let barsProfile = document.get("barprofile") as? [Int] {
                        if let resProfile = document.get("resprofile") as? [Int] {
                            self.labelUserName.text = name
                            self.barProfiling = BarProfile(barsProfile)
                            self.resProfiling = ResProfile(resProfile)
                            self.displayData()
                            return
                        }
                    }
                }
                
                // SOMETHING WENT WRONG
                let alert = UIAlertController(title: "Something went wrong", message: "Impossible to load profile data", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Try again", style: .destructive, handler: {
                    (alert) in
                    // Goes to main
                    let storyBoard: UIStoryboard = UIStoryboard(name: "Home", bundle: nil)
                    let newViewController = storyBoard.instantiateViewController(withIdentifier: "MAIN_SB") as! HomeViewController
                    newViewController.modalPresentationStyle = .fullScreen
                    self.present(newViewController, animated: true, completion: nil)}))
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
    
    private func displayData() {
        
        // BAR RELATED DATA
        switch (barProfiling?.price) {
        case 0 : labelBarsPrice.text = "$"
        case 1 : labelBarsPrice.text = "$$"
        case 2 : labelBarsPrice.text = "$$$"
        default: break
        }
        var style = ""
        if (barProfiling!.style1) {style += "Casual\n"}
        if (barProfiling!.style2) {style += "Up-market\n"}
        if (barProfiling!.style3) {style += "Down and Dirty\n"}
        labelBarsStyle.text = String(style.dropLast())
        var density = ""
        if (barProfiling!.density1) {density += "Calm\n"}
        if (barProfiling!.density2) {density += "Crowded\n"}
        if (barProfiling!.density3) {density += "Banging\n"}
        labelBarsDensity.text = String(density.dropLast())
        var time = ""
        if (barProfiling!.time1) {time += "Day\n"}
        if (barProfiling!.time2) {time += "Night\n"}
        labelBarsTime.text = String(time.dropLast())
        
        
        // RES RELATED DATA
        switch (resProfiling?.price) {
        case 0 : labelResPrice.text = "$"
        case 1 : labelResPrice.text = "$$"
        case 2 : labelResPrice.text = "$$$"
        default: break
        }
        var dietary = ""
        if (resProfiling!.dietary1) {dietary += "Vegan\n"}
        if (resProfiling!.dietary2) {dietary += "Vegetarian\n"}
        if (resProfiling!.dietary3) {dietary += "Halal\n"}
        if (resProfiling!.dietary4) {dietary += "Pescetarian\n"}
        if (resProfiling!.dietary5) {dietary += "Nothing\n"}
        labelResDietary.text = String(dietary.dropLast())
        var ambiance = ""
        if (resProfiling!.ambiance1) {ambiance += "Cosy\n"}
        if (resProfiling!.ambiance2) {ambiance += "Romantic\n"}
        if (resProfiling!.ambiance3) {ambiance += "Lively\n"}
        labelResAmbiance.text = String(ambiance.dropLast())
    }
    
    
    
    @IBAction func tapEditBars(_ sender: Any) {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Profile", bundle: nil)
        let newViewController = storyBoard.instantiateViewController(withIdentifier: "BarEditorViewController") as! BarEditorViewController
        newViewController.modalPresentationStyle = .fullScreen
        newViewController.barProfiling = barProfiling
        self.present(newViewController, animated: true, completion: nil)
        
    }
    
    @IBAction func tapEditRes(_ sender: Any) {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Profile", bundle: nil)
        let newViewController = storyBoard.instantiateViewController(withIdentifier: "ResEditorViewController") as! ResEditorViewController
        newViewController.modalPresentationStyle = .fullScreen
        newViewController.resProfiling = resProfiling
        self.present(newViewController, animated: true, completion: nil)
    }
}
