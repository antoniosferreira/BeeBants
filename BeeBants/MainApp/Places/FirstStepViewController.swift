//
//  FirstStepViewController.swift
//  BeeBants
//
//  Created by António Ferreira on 01/06/2020.
//  Copyright © 2020 BeeBants. All rights reserved.
//

import UIKit

class FirstStepViewController: UIViewController {

    @IBOutlet weak var subView: UIView!
    
    @IBOutlet weak var letsButton: UIButton!
    @IBOutlet weak var changeButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setUpBackground()
        setUpElements()
    }
    
    func setUpBackground() {
        let backgroundImage = UIImageView(frame: UIScreen.main.bounds)
        backgroundImage.image = UIImage(named: "TODELETE")
        backgroundImage.contentMode =  UIView.ContentMode.scaleAspectFill
        backgroundImage.alpha = 1

        
  
        let gradientMaskLayer = CAGradientLayer()
        gradientMaskLayer.frame = backgroundImage.bounds
        gradientMaskLayer.bounds = backgroundImage.bounds
        gradientMaskLayer.colors = [  UIColor.clear.cgColor,     UIColor.white.cgColor]
        gradientMaskLayer.locations = [0.0, 0.25]
        
        subView.layer.mask = gradientMaskLayer
        self.view.insertSubview(backgroundImage, at: 0)
    }
    

    func setUpElements() {
        Styling.styleRedFilledButton(button: letsButton)
        Styling.styleRedUnfilledButton(button: changeButton)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
