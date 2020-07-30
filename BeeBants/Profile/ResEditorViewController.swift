//
//  ResEditorViewController.swift
//  BeeBants
//
//  Created by António Ferreira on 30/07/2020.
//  Copyright © 2020 BeeBants. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth


class ResEditorViewController: UIViewController {

    var savePressed = false
    var resProfiling : ResProfile?
    var newResProfiling : [Int]?
    @IBOutlet weak var sliderPrice: UISlider!
    
    // Data Labels
    @IBOutlet weak var labelVegan: UILabel!
    @IBOutlet weak var labelVegetarian: UILabel!
    @IBOutlet weak var labelHalal: UILabel!
    @IBOutlet weak var labelPescetarian: UILabel!
    @IBOutlet weak var labelCosy: UILabel!
    @IBOutlet weak var labelRomantic: UILabel!
    @IBOutlet weak var labelLively: UILabel!
    lazy var displayedData = [labelVegan, labelVegetarian, labelHalal, labelPescetarian, labelCosy, labelRomantic, labelLively]
    
    // Titles Labels
    @IBOutlet weak var labelPrice: UILabel!
    @IBOutlet weak var labelDietary: UILabel!
    @IBOutlet weak var labelAmbiance: UILabel!
    lazy var displayedTitles = [labelPrice, labelDietary, labelAmbiance]
    
    // DATA BOXES
    @IBOutlet weak var boxVegan: UIImageView!
    @IBOutlet weak var boxVegetarian: UIImageView!
    @IBOutlet weak var boxHalal: UIImageView!
    @IBOutlet weak var boxPescetarian: UIImageView!
    @IBOutlet weak var boxCosy: UIImageView!
    @IBOutlet weak var boxRomantic: UIImageView!
    @IBOutlet weak var boxLively: UIImageView!
    
    @IBOutlet weak var saveButton: RoundButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        newResProfiling = resProfiling!.encodedProfile

        fixFontSize()
        Styling.styleRedFilledButton(button: saveButton)
        
        updateProfileInfo()

    }
    @IBAction func sliderChanged(_ sender: Any) {
        sliderPrice.setValue(round(sliderPrice.value * 1.0) / 1.0, animated: true)

    }
    
    private func updateProfileInfo() {
        sliderPrice.setValue(Float(resProfiling!.price), animated: true)
        swap(boxVegan, resProfiling!.dietary1)
        swap(boxVegetarian, resProfiling!.dietary2)
        swap(boxHalal, resProfiling!.dietary3)
        swap(boxPescetarian, resProfiling!.dietary4)
        
        swap(boxCosy, resProfiling!.ambiance1)
        swap(boxRomantic, resProfiling!.ambiance2)
        swap(boxLively, resProfiling!.ambiance3)
    }
    
    private func swap(_ button: UIImageView, _ value: Bool) {
        if value {
            button.image = UIImage(named: "selectionbox_selected")!
        } else {
            button.image = UIImage(named: "selectionbox_empty")!
        }
    }
    
    private func fixFontSize() {
        let smallestFontSizeData = displayedData.map{$0!.actualFontSize}.min()
        for label in displayedData {
            label?.font = label?.font.withSize(smallestFontSizeData!)
        }
        
        let smallestFontSizeDataTitle = displayedTitles.map{$0!.actualFontSize}.min()
        for label in displayedTitles {
            label?.font = label?.font.withSize(smallestFontSizeDataTitle!)
        }
    }
    
    
    @IBAction func tappedVegan(_ sender: Any) {
        newResProfiling![3] = alternate(value: newResProfiling![3])
        swap(boxVegan, toBool(value: newResProfiling![3]))
    }
    
    @IBAction func tappedVegetarian(_ sender: Any) {
        newResProfiling![4] = alternate(value: newResProfiling![4])
        swap(boxVegetarian, toBool(value: newResProfiling![4]))
    }
    @IBAction func tappedHalal(_ sender: Any) {
        newResProfiling![5] = alternate(value: newResProfiling![5])
        swap(boxHalal, toBool(value: newResProfiling![5]))
    }
    @IBAction func tappedPesc(_ sender: Any) {
        newResProfiling![6] = alternate(value: newResProfiling![6])
        swap(boxPescetarian, toBool(value: newResProfiling![6]))
    }
    
    @IBAction func tappedCosy(_ sender: Any) {
        newResProfiling![8] = alternate(value: newResProfiling![8])
        swap(boxCosy, toBool(value: newResProfiling![8]))
    }
    @IBAction func tappedRomantic(_ sender: Any) {
        newResProfiling![9] = alternate(value: newResProfiling![9])
        swap(boxRomantic, toBool(value: newResProfiling![9]))
    }
    
    @IBAction func tappedLively(_ sender: Any) {
        newResProfiling![10] = alternate(value: newResProfiling![10])
        swap(boxLively, toBool(value: newResProfiling![10]))
    }
    private func alternate(value : Int) -> Int
       {
           if (value == 0) {return 1}
           else {return 0}
       }
       
       private func toBool(value : Int) -> Bool
       {
           if (value == 0) {return false}
           else {return true}
       }
       
    
    @IBAction func tappedSave(_ sender: Any) {
        if (savePressed == false) {
            savePressed = true
            
            newResProfiling![2] = Int(sliderPrice.value)
            
            Firestore.firestore().collection("users").document(Auth.auth().currentUser!.uid).updateData([
                "resprofile": newResProfiling!
            ]) { err in
                if let error = err {
                    
                    // SOMETHING WENT WRONG
                    let alert = UIAlertController(title: "Something went wrong", message: error.localizedDescription, preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Try again", style: .destructive, handler: {
                        (alert) in
                        
                        // Goes to main
                        let storyBoard: UIStoryboard = UIStoryboard(name: "Home", bundle: nil)
                        let newViewController = storyBoard.instantiateViewController(withIdentifier: "MAIN_SB") as! HomeViewController
                        newViewController.modalPresentationStyle = .fullScreen
                        self.present(newViewController, animated: true, completion: nil)
                    }))
                    self.present(alert, animated: true, completion: nil)
                } else {
                    
                    // ALL OK
                    let storyBoard: UIStoryboard = UIStoryboard(name: "Profile", bundle: nil)
                    let newViewController = storyBoard.instantiateViewController(withIdentifier: "ProfileMain") as! ProfileViewController
                    newViewController.modalPresentationStyle = .fullScreen
                    self.present(newViewController, animated: true, completion: nil)
                }
            }
        }
    }
    
}
