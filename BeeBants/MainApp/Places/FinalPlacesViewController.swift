//
//  FinalViewController.swift
//  BeeBants
//
//  Created by António Ferreira on 28/01/2021.
//  Copyright © 2021 BeeBants. All rights reserved.
//

import UIKit

class FinalPlacesViewController: UIViewController {

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        let seconds = 2.5
        DispatchQueue.main.asyncAfter(deadline: .now() + seconds) {
            self.view.window?.rootViewController?.dismiss(animated: true, completion: nil)
        }
    }


}
