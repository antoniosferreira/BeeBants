//
//  FinalViewController.swift
//  BeeBants
//
//  Created by António Ferreira on 05/08/2020.
//  Copyright © 2020 BeeBants. All rights reserved.
//

import UIKit

class FinalViewController: UIViewController {

    @IBOutlet weak var labelTitle1: UILabel!
    @IBOutlet weak var labelTitle2: UILabel!
    lazy var titles = [labelTitle1, labelTitle2]
    
    @IBOutlet weak var buttonNext: RoundButton!
    override func viewDidLoad() {
        super.viewDidLoad()

        setUpBackground()
        Styling.styleRedFilledButton(button: buttonNext)
        
        let smallestFontSize = titles.map{$0!.actualFontSize}.min()
        for label in titles {
            label?.font = label?.font.withSize(smallestFontSize!)
        }
        
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
    
    @IBAction func tappedNext(_ sender: Any) {
        
        // GOES TO HOW TO
        let vc = UIStoryboard(name: "HowTo", bundle: nil).instantiateViewController(withIdentifier: "HowToViewController") as! HowToViewController
        vc.modalPresentationStyle = .fullScreen
        vc.afterSignUp = true
        self.present(vc, animated: true, completion: nil)
    }
    
}
