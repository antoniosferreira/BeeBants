//
//  GuideContentViewController.swift
//  BeeBants
//
//  Created by António Ferreira on 18/05/2020.
//  Copyright © 2020 BeeBants. All rights reserved.
//

import UIKit

class GuideContentViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    var index = 0
    
    var img = "howto1"
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        imageView.image  = UIImage(named: img)
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
