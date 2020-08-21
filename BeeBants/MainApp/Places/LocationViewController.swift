//
//  LocationViewController.swift
//  BeeBants
//
//  Created by António Ferreira on 03/07/2020.
//  Copyright © 2020 BeeBants. All rights reserved.
//

import UIKit

class LocationViewController: UIViewController {
    
    var pageController : PlacesPageViewController!

    @IBOutlet weak var labelName: UILabel!
    @IBOutlet weak var buttonNext: RoundButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        labelName.text = pageController.getPlace().location.displayName
        Styling.styleRedFilledButton(button: buttonNext)
    }
    
    @IBAction func tappedNextButton(_ sender: Any) {
        pageController.goPlace()
        
    }
    
    @IBAction func tappedBackButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
}
