//
//  HomeViewController.swift
//  BeeBants
//
//  Created by António Ferreira on 27/04/2020.
//  Copyright © 2020 BeeBants. All rights reserved.
//

import UIKit
import FirebaseAuth

class HomeViewController: SOContainerViewController {
    
    @IBOutlet weak var barsButton: RoundButton!
    @IBOutlet weak var resButton: RoundButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        self.menuSide = .right
        self.sideViewController = self.storyboard?.instantiateViewController(withIdentifier: "menu")
        
        
        // Do any additional setup after loading the view.
        setUpElements()
    }
    
    
    
    func setUpElements() {
        Styling.styleRedFilledButton(button: barsButton)
        Styling.styleRedFilledButton(button: resButton)
    }
    
    @IBAction func openMenu(_ sender: Any) {
        if let container = self.so_containerViewController {
            container.isSideViewControllerPresented = true
        }
    }
    
    
    
    @IBAction func tappedBars(_ sender: Any) {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Places", bundle: nil)
        let newViewController = storyBoard.instantiateViewController(withIdentifier: "PlacesHomeViewController") as! PlacesHomeViewController
        newViewController.modalPresentationStyle = .fullScreen
        newViewController.isBar = true
        self.present(newViewController, animated: true, completion: nil)
    }
    @IBAction func tappedRestaurants(_ sender: Any) {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Places", bundle: nil)
        let newViewController = storyBoard.instantiateViewController(withIdentifier: "PlacesHomeViewController") as! PlacesHomeViewController
        newViewController.modalPresentationStyle = .fullScreen
        newViewController.isBar = false
        self.present(newViewController, animated: true, completion: nil)
    }
}
