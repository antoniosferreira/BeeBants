//
//  SU_FinalViewController.swift
//  BeeBants
//
//  Created by António Ferreira on 07/04/2020.
//  Copyright © 2020 BeeBants. All rights reserved.
//

import UIKit

class SU_FinalViewController: UIViewController {

    var signUp: SignUpViewController!
   
    @IBOutlet weak var nextButton: RoundButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Styling.styleRedFilledButton(button: nextButton)
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
