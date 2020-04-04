//
//  SU_DateNationViewController.swift
//  BeeBants
//
//  Created by António Ferreira on 02/04/2020.
//  Copyright © 2020 BeeBants. All rights reserved.
//

import UIKit

class SU_DateNationViewController: UIViewController {

    var signUp: SignUpViewController!
    var pageController : SignUpPageViewController!
    

    @IBOutlet weak var dateTextField: DateTextField!
 
    
    @IBOutlet weak var dateErrorLabel: UILabel!
    @IBOutlet weak var nationErrorLabel: UILabel!
    
    @IBOutlet weak var nextButton: RoundButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setUpElements()
    }
    
    func setUpElements() {
        Styling.styleRedField(field: dateTextField, placeholder: "date of birth")
        //Styling.styleRedField(field: nationTextField, placeholder: "nationality")
        Styling.styleRedFilledButton(button: nextButton)
        
        dateErrorLabel.alpha = 0
        nationErrorLabel.alpha = 0
        
        dateTextField.dateFormat = .dayMonthYear
        dateTextField.separator = "-"
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
