//
//  HistoryViewController.swift
//  BeeBants
//
//  Created by António Ferreira on 25/01/2021.
//  Copyright © 2021 BeeBants. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore
import Firebase


class HistoryViewController: UIViewController {

    @IBOutlet weak var stackView: UIStackView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    @IBAction func tapped_goback(_ sender: Any) {
        self.view.window?.rootViewController?.dismiss(animated: true, completion: nil)
    
    }
    

}
