//
//  PlacesHomeViewController.swift
//  BeeBants
//
//  Created by António Ferreira on 07/07/2020.
//  Copyright © 2020 BeeBants. All rights reserved.
//

import UIKit

class PlacesHomeViewController: UIViewController {

    // true: bar, false: restaurant
    var option : Bool?
    
    @IBSegueAction func pageControllerInstantiated(_ coder: NSCoder) -> PlacesPageViewController? {
        let pc = PlacesPageViewController(coder: coder)
        pc!.option = option!
        return pc
    }
    

}
