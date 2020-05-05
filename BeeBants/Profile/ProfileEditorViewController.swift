//
//  ProfileEditorViewController.swift
//  BeeBants
//
//  Created by António Ferreira on 01/05/2020.
//  Copyright © 2020 BeeBants. All rights reserved.
//

import UIKit
import Firebase

class ProfileEditorViewController: UIViewController {

    @IBOutlet weak var nextButton: RoundButton!
    
    @IBOutlet weak var buttonMoney1: UIImageView!
    @IBOutlet weak var buttonMoney2: UIImageView!
    @IBOutlet weak var buttonMoney3: UIImageView!
    
    
    @IBOutlet weak var buttonStyle1: UIImageView!
    @IBOutlet weak var buttonStyle2: UIImageView!
    @IBOutlet weak var buttonStyle3: UIImageView!
    
    @IBOutlet weak var buttonDensity1: UIImageView!
    @IBOutlet weak var buttonDensity2: UIImageView!
    @IBOutlet weak var buttonDensity3: UIImageView!
    
    @IBOutlet weak var buttonTime1: UIImageView!
    @IBOutlet weak var buttonTime2: UIImageView!
    
    var data = BarData()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // READS BAR DATA
        let db = Firestore.firestore()
        let userRef = db.collection("profiles").document(Auth.auth().currentUser!.uid);
        
        userRef.getDocument { (document, error) in
            if let document = document, document.exists {
                self.data.money1 = document.get("bar_money1") as! Bool
                self.data.money2 = document.get("bar_money2") as! Bool
                self.data.money3 = document.get("bar_money3") as! Bool
                
                self.data.style1 = document.get("bar_style1") as! Bool
                self.data.style2 = document.get("bar_style2") as! Bool
                self.data.style3 = document.get("bar_style3") as! Bool
                
                self.data.density1 = document.get("bar_density1") as! Bool
                self.data.density2 = document.get("bar_density2") as! Bool
                self.data.density3 = document.get("bar_density3") as! Bool
                
                self.data.time1 = document.get("bar_time1") as! Bool
                self.data.time2 = document.get("bar_time2") as! Bool
                
                self.swap(self.buttonMoney1, self.data.money1)
                self.swap(self.buttonMoney2, self.data.money2)
                self.swap(self.buttonMoney3, self.data.money3)
                self.swap(self.buttonStyle1, self.data.style1)
                self.swap(self.buttonStyle2, self.data.style2)
                self.swap(self.buttonStyle3, self.data.style3)
                self.swap(self.buttonDensity1, self.data.density1)
                self.swap(self.buttonDensity2, self.data.density2)
                self.swap(self.buttonDensity3, self.data.density3)
                self.swap(self.buttonTime1, self.data.time1)
                self.swap(self.buttonTime2, self.data.time2)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setUpElements()
    }
    
    func setUpElements() {
        Styling.styleRedFilledButton(button: nextButton)
    }
    
    
    func swap(_ button: UIImageView, _ value: Bool) {
        if value {
            button.image = UIImage(named: "selectionbox_selected")!
        } else {
            button.image = UIImage(named: "selectionbox_empty")!
        }
    }
    
    @IBAction func money1Tapped(_ sender: Any) {
        data.money1 = !data.money1
        swap(buttonMoney1, data.money1)
    }
    
    
    @IBAction func money2Tapped(_ sender: Any) {
        data.money2 = !data.money2
        swap(buttonMoney2, data.money2)
    }
    
    @IBAction func money3Tapped(_ sender: Any) {
        data.money3 = !data.money3
        swap(buttonMoney3, data.money3)
    }
    
    @IBAction func style1Tapped(_ sender: Any) {
         data.style1 = !data.style1
        swap(buttonStyle1, data.style1)
    }
    
    @IBAction func style2Tapped(_ sender: Any) {
        data.style2 = !data.style2
         swap(buttonStyle2, data.style2)
    }
    @IBAction func style3Tapped(_ sender: Any) {
        data.style3 = !data.style3
        swap(buttonStyle3, data.style3)
    }
    
    @IBAction func density1Tapped(_ sender: Any) {
        data.density1 = !data.density1
        swap(buttonDensity1, data.density1)
    }
    
    @IBAction func density2Tapped(_ sender: Any) {
        data.density2 = !data.density2
        swap(buttonDensity2, data.density2)
    }
    @IBAction func density3Tapped(_ sender: Any) {
        data.density3 = !data.density3
        swap(buttonDensity3, data.density3)
    }
    @IBAction func time1Tapped(_ sender: Any) {
        data.time1 = !data.time1
        swap(buttonTime1, data.time1)
    }
    
    @IBAction func time2Tapped(_ sender: Any) {
        data.time2 = !data.time2
        swap(buttonTime2, data.time2)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if  let vc = segue.destination as? ProfileEditor2ViewController {
            vc.barData = data
        }
     }
    
}


struct BarData {
    var money1 = true
    var money2 = true
    var money3 = true
    
    var style1 = true
    var style2 = true
    var style3 = true
    
    var density1 = true
    var density2 = true
    var density3 = true
    
    var time1 = true
    var time2 = true
    var time3 = true
}
