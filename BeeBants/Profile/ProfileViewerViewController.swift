//
//  ProfileViewerViewController.swift
//  BeeBants
//
//  Created by António Ferreira on 30/04/2020.
//  Copyright © 2020 BeeBants. All rights reserved.
//

import UIKit
import Firebase

class ProfileViewerViewController: UIViewController {

    @IBOutlet weak var barsView: UIView!
    @IBOutlet weak var resView: UIView!
    @IBOutlet weak var hiLabel: UILabel!
   
    
    
    @IBOutlet weak var barPriceLabel: UILabel!
    @IBOutlet weak var barStyleLabel: UILabel!
    @IBOutlet weak var barDensityLabel: UILabel!
    @IBOutlet weak var barTimeLabel: UILabel!
    
    @IBOutlet weak var resPriceLabel: UILabel!
    @IBOutlet weak var resDietLabel: UILabel!
    @IBOutlet weak var resAmbianceLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        barsView.layer.cornerRadius = 30
        resView.layer.cornerRadius = 30

      
        // Access to DB NAME
        let db = Firestore.firestore()
        let userRef = db.collection("users").document(Auth.auth().currentUser!.uid);
        
        userRef.getDocument { (document, error) in
            if let document = document, document.exists {
                let name = document.get("name") as! String
                self.hiLabel.text = name
            
            }
        }
      
        db.collection("profiles").document(Auth.auth().currentUser!.uid).getDocument { (document, error) in
            if let document = document, document.exists {
                
                self.barPriceLabel.text = ""
                if document.get("bar_money1") as! Bool {
                    self.barPriceLabel.text! += "£\n"
                }
                if document.get("bar_money2") as! Bool {
                    self.barPriceLabel.text! += "££\n"
                }
                if document.get("bar_money3") as! Bool {
                    self.barPriceLabel.text! += "£££\n"
                }
                
                self.barStyleLabel.text = ""
                if document.get("bar_style1") as! Bool {
                    self.barStyleLabel.text! += "Casual\n"
                }
                if document.get("bar_style2") as! Bool {
                    self.barStyleLabel.text! += "Up-market\n"
                }
                if document.get("bar_style3") as! Bool {
                    self.barStyleLabel.text! += "Down and Dirty\n"
                }
                
                self.barDensityLabel.text = ""
                if document.get("bar_density1") as! Bool {
                    self.barDensityLabel.text! += "Calm\n"
                }
                if document.get("bar_density2") as! Bool {
                    self.barDensityLabel.text! += "Crowded\n"
                }
                if document.get("bar_density3") as! Bool {
                    self.barDensityLabel.text! += "Banging\n"
                }
                
                self.barTimeLabel.text = ""
                if document.get("bar_time1") as! Bool {
                    self.barTimeLabel.text! += "Day\n"
                }
                if document.get("bar_time2") as! Bool {
                    self.barTimeLabel.text! += "Night\n"
                }
                
                
                self.resPriceLabel.text = ""
                if document.get("res_money1") as! Bool {
                    self.resPriceLabel.text! += "£\n"
                }
                if document.get("res_money2") as! Bool {
                    self.resPriceLabel.text! += "££\n"
                }
                if document.get("res_money3") as! Bool {
                    self.resPriceLabel.text! += "£££\n"
                }
                
                self.resDietLabel.text = ""
                if document.get("res_diet1") as! Bool {
                    self.resDietLabel.text! += "Vegan\n"
                }
                if document.get("res_diet2") as! Bool {
                    self.resDietLabel.text! += "Vegetarian\n"
                }
                if document.get("res_diet3") as! Bool {
                    self.resDietLabel.text! += "Halal\n"
                }
                if document.get("res_diet4") as! Bool {
                    self.resDietLabel.text! += "Pescetarian\n"
                }
                if document.get("res_diet5") as! Bool {
                    self.resDietLabel.text! += "Nothing\n"
                }
                
                self.resAmbianceLabel.text = ""
                if document.get("res_amb1") as! Bool {
                    self.resAmbianceLabel.text! += "Cosy\n"
                }
                if document.get("res_amb2") as! Bool {
                    self.resAmbianceLabel.text! += "Romantic\n"
                }
                if document.get("res_amb3") as! Bool {
                    self.resAmbianceLabel.text! += "Lively\n"
                }
            }
            
        }
    }
    


}
