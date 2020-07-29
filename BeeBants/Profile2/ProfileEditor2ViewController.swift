//
//  ProfileEditor2ViewController.swift
//  BeeBants
//
//  Created by António Ferreira on 02/05/2020.
//  Copyright © 2020 BeeBants. All rights reserved.
//

import UIKit
import Firebase

class ProfileEditor2ViewController: UIViewController {
    
    @IBOutlet weak var saveButton: RoundButton!
    
    var barData : BarData? = nil
    var data = ResData()
    
    @IBOutlet weak var buttonPrice1: UIImageView!
    @IBOutlet weak var buttonPrice2: UIImageView!
    @IBOutlet weak var buttonPrice3: UIImageView!
    
    @IBOutlet weak var buttonDiet1: UIImageView!
    @IBOutlet weak var buttonDiet2: UIImageView!
    @IBOutlet weak var buttonDiet3: UIImageView!
    @IBOutlet weak var buttonDiet4: UIImageView!
    @IBOutlet weak var buttonDiet5: UIImageView!
    
    @IBOutlet weak var buttonAmbiance1: UIImageView!
    @IBOutlet weak var buttonAmbiance2: UIImageView!
    @IBOutlet weak var buttonAmbiance3: UIImageView!
    
    let db = Firestore.firestore()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // READS BAR DATA
        let userRef = db.collection("profiles").document(Auth.auth().currentUser!.uid);
        
        userRef.getDocument { (document, error) in
            if let document = document, document.exists {
                self.data.money1 = document.get("res_money1") as! Bool
                self.data.money2 = document.get("res_money2") as! Bool
                self.data.money3 = document.get("res_money3") as! Bool
                
                self.data.diet1 = document.get("res_diet1") as! Bool
                self.data.diet2 = document.get("res_diet2") as! Bool
                self.data.diet3 = document.get("res_diet3") as! Bool
                self.data.diet4 = document.get("res_diet4") as! Bool
                self.data.diet5 = document.get("res_diet5") as! Bool
                
                self.data.ambiance1 = document.get("res_amb1") as! Bool
                self.data.ambiance2 = document.get("res_amb2") as! Bool
                self.data.ambiance1 = document.get("res_amb3") as! Bool
                
                self.swap(self.buttonPrice1, self.data.money1)
                self.swap(self.buttonPrice2, self.data.money2)
                self.swap(self.buttonPrice3, self.data.money3)
                self.swap(self.buttonDiet1, self.data.diet1)
                self.swap(self.buttonDiet2, self.data.diet2)
                self.swap(self.buttonDiet3, self.data.diet3)
                self.swap(self.buttonDiet4, self.data.diet4)
                self.swap(self.buttonDiet5, self.data.diet5)
                self.swap(self.buttonAmbiance1, self.data.ambiance1)
                self.swap(self.buttonAmbiance2, self.data.ambiance2)
                self.swap(self.buttonAmbiance3, self.data.ambiance3)
            }
        }
        
     
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        setUpElements()
    }
    
    
    func setUpElements() {
        Styling.styleRedFilledButton(button: saveButton)
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
        swap(buttonPrice1, data.money1)
    }
    
    @IBAction func money2Tapped(_ sender: Any) {
        data.money2 = !data.money2
        swap(buttonPrice2, data.money2)
    }
    @IBAction func money3Tapped(_ sender: Any) {
        data.money3 = !data.money3
         swap(buttonPrice3, data.money3)
    }
    @IBAction func diet1Tapped(_ sender: Any) {
             data.diet1 = !data.diet1
         swap(buttonDiet1, data.diet1)
    }
    @IBAction func diet2Tapped(_ sender: Any) {
              data.diet2 = !data.diet2
        swap(buttonDiet2, data.diet2)
    }
    @IBAction func diet3Tapped(_ sender: Any) {
        data.diet3 = !data.diet3
        swap(buttonDiet3, data.diet3)
    }
    @IBAction func diet4Tapped(_ sender: Any) {
                data.diet4 = !data.diet4
        swap(buttonDiet4, data.diet4)
    }
    @IBAction func diet5Tapped(_ sender: Any) {
                 data.diet5 = !data.diet5
        swap(buttonDiet5, data.diet5)
    }
    @IBAction func amb1Tapped(_ sender: Any) {
        data.ambiance1 = !data.ambiance1
        swap(buttonAmbiance1, data.ambiance1)
    }
    @IBAction func amb2Tapped(_ sender: Any) {
           data.ambiance2 = !data.ambiance2
        swap(buttonAmbiance2, data.ambiance2)
    }
    @IBAction func amb3Tapped(_ sender: Any) {
        data.ambiance3 = !data.ambiance3
        swap(buttonAmbiance3, data.ambiance3)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
       if  let vc = segue.destination as? ProfileViewerViewController {
            
            let userRef = db.collection("profiles").document(Auth.auth().currentUser!.uid);
            userRef.setData(prepareDoc())
        }
    }
    
    
    func prepareDoc() -> [String:Bool] {
        return [
            "bar_money1": barData!.money1,
            "bar_money2": barData!.money2,
            "bar_money3": barData!.money3,
            
            "bar_style1": barData!.style1,
            "bar_style2": barData!.style2,
            "bar_style3": barData!.style3,
            
            "bar_density1": barData!.density1,
            "bar_density2": barData!.density2,
            "bar_density3": barData!.density3,
            
            "bar_time1": barData!.time1,
            "bar_time2": barData!.time2,
            
            "res_money1": data.money1,
            "res_money2": data.money2,
            "res_money3": data.money3,
            
            "res_diet1": data.diet1,
            "res_diet2": data.diet2,
            "res_diet3": data.diet3,
            "res_diet4": data.diet4,
            "res_diet5": data.diet5,
            
            "res_amb1": data.ambiance1,
            "res_amb2": data.ambiance2,
            "res_amb3": data.ambiance3
        ]
    }
}

struct ResData {
    var money1 = true
    var money2 = true
    var money3 = true
    
    var diet1 = true
    var diet2 = true
    var diet3 = true
    var diet4 = true
    var diet5 = true
    
    var ambiance1 = true
    var ambiance2 = true
    var ambiance3 = true
}
