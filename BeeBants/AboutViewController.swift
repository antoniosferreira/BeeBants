//
//  AboutViewController.swift
//  BeeBants
//
//  Created by António Ferreira on 29/04/2020.
//  Copyright © 2020 BeeBants. All rights reserved.
//

import UIKit

class AboutViewController: UIViewController {
    
    @IBOutlet weak var scrollView: UIView!
    @IBOutlet weak var textLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        textLabel.textColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1)
        textLabel.font = UIFont(name: "Poppins-Light", size: 18)
        textLabel.numberOfLines = 0
        textLabel.lineBreakMode = .byWordWrapping
        let paragraphStyle = NSMutableParagraphStyle()
        //paragraphStyle.lineHeightMultiple = 0.67
        
         textLabel.attributedText = NSMutableAttributedString(string: "Aren’t you fed up of spending hours deciding where to go? So are we! Which is why we came up with Bee Bants. An app that makes the decision for you. Build your own profile and have us choose the perfect location for you! Get in touch with your adventurous side! \n\nAre you a frequent traveller? Looking for a new experience? With no idea where to go and zero desire to waste time looking? Bee Bants offers the best, funnest way to discover a city and all of its secret spots that even the locals don’t know about!", attributes: [NSAttributedString.Key.paragraphStyle: paragraphStyle])
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
