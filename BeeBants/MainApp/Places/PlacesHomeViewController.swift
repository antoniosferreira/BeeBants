//
//  PlacesHomeViewController.swift
//  BeeBants
//
//  Created by António Ferreira on 07/07/2020.
//  Copyright © 2020 BeeBants. All rights reserved.
//

import UIKit

class PlacesHomeViewController: UIViewController {

    var isBar : Bool = true
    var specific : Int = 0
    
    @IBSegueAction func pageControllerInstantiated(_ coder: NSCoder) -> PlacesPageViewController? {
        let pc = PlacesPageViewController(coder: coder)
        pc!.isBar = isBar
        pc!.specific = specific
        return pc
    }
    

}
