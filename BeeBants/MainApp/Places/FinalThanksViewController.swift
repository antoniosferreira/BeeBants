//
//  FinalThanksViewController.swift
//  BeeBants
//
//  Created by António Ferreira on 25/01/2021.
//  Copyright © 2021 BeeBants. All rights reserved.
//

import UIKit

class FinalThanksViewController: UIViewController {

    var pageController : PlacesPageViewController!

    @IBOutlet weak var finalButton: RoundButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        Styling.styleRedFilledButton(button: finalButton)
    }
    
    @IBAction func finish(_ sender: Any) {
        self.view.window?.rootViewController?.dismiss(animated: true, completion: nil)

    }
    
}
