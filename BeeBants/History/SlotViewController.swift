//
//  SlotViewController.swift
//  BeeBants
//
//  Created by António Ferreira on 25/01/2021.
//  Copyright © 2021 BeeBants. All rights reserved.
//

import UIKit

class SlotViewController: UIViewController {

    @IBOutlet weak var label: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
    }
    
    public func change(_ alo : String) {
        label.text = alo
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
