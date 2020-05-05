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
    
    @IBAction func bars(_ sender: Any) {
        if let container = self.so_containerViewController {
             container.isSideViewControllerPresented = true
         }
    }
    
    func setUpElements() {
        Styling.styleRedFilledButton(button: barsButton)
        Styling.styleRedFilledButton(button: resButton)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    @IBAction func logout(_ sender: Any) {
        let firebaseAuth = Auth.auth()
        do {
          try firebaseAuth.signOut()
        } catch let signOutError as NSError {
          print ("Error signing out: %@", signOutError)
        }
    }
}
