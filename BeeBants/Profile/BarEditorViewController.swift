//
//  BarEditorViewController.swift
//  BeeBants
//
//  Created by António Ferreira on 29/07/2020.
//  Copyright © 2020 BeeBants. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class BarEditorViewController: UIViewController {

    var barProfiling : BarProfile?
    var newBarProfiling : [Int]?
    var savePressed : Bool = false
    
    // LABELS TITLE
    @IBOutlet weak var labelPrice: UILabel!
    @IBOutlet weak var labelStyle: UILabel!
    @IBOutlet weak var labelDensity: UILabel!
    @IBOutlet weak var labelTime: UILabel!
    lazy var displayedTitles = [labelPrice, labelStyle, labelDensity, labelTime]
    
    // LABELS DATA
    @IBOutlet weak var labelCasual: UILabel!
    @IBOutlet weak var labelUp: UILabel!
    @IBOutlet weak var labelDown: UILabel!
    @IBOutlet weak var labelCalm: UILabel!
    @IBOutlet weak var labelCrowded: UILabel!
    @IBOutlet weak var labelBanging: UILabel!
    @IBOutlet weak var labelDay: UILabel!
    @IBOutlet weak var labelNight: UILabel!
    lazy var displayedData = [labelCasual, labelUp, labelDown, labelCalm, labelCrowded, labelBanging, labelDay, labelNight]
    
    
    // BOXES
    @IBOutlet weak var sliderPrice: UISlider!
    @IBOutlet weak var boxCasual: UIImageView!
    @IBOutlet weak var boxUp: UIImageView!
    @IBOutlet weak var boxDown: UIImageView!
    @IBOutlet weak var boxCalm: UIImageView!
    @IBOutlet weak var boxCrowded: UIImageView!
    @IBOutlet weak var boxBanging: UIImageView!
    @IBOutlet weak var boxDay: UIImageView!
    @IBOutlet weak var boxNight: UIImageView!
    
    
    
    @IBOutlet weak var buttonSave: RoundButton!
    override func viewDidLoad() {
        super.viewDidLoad()

        
        newBarProfiling = barProfiling!.encodedProfile
        
        fixFontSize()
        Styling.styleRedFilledButton(button: buttonSave)
        // Do any additional setup after loading the view.
        
        updateProfileInfo()
    }

    @IBAction func sliderChanged(_ sender: Any) {
        sliderPrice.setValue(round(sliderPrice.value * 1.0) / 1.0, animated: true)
   
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
    
    
    private func updateProfileInfo() {
        sliderPrice.setValue(Float(barProfiling!.price), animated: true)
        swap(boxCasual, barProfiling!.style1)
        swap(boxUp, barProfiling!.style2)
        swap(boxDown, barProfiling!.style3)
        
        swap(boxCalm, barProfiling!.density1)
        swap(boxCrowded, barProfiling!.density2)
        swap(boxBanging, barProfiling!.density3)

        swap(boxDay, barProfiling!.time1)
        swap(boxNight, barProfiling!.time2)
    }
    
    private func swap(_ button: UIImageView, _ value: Bool) {
        if value {
            button.image = UIImage(named: "selectionbox_selected")!
        } else {
            button.image = UIImage(named: "selectionbox_empty")!
        }
    }
    
    @IBAction func tappedCasual(_ sender: Any) {
        newBarProfiling![3] = alternate(value: newBarProfiling![3])
        swap(boxCasual, toBool(value: newBarProfiling![3]))
    }

    @IBAction func tappedUp(_ sender: Any) {
        newBarProfiling![4] = alternate(value: newBarProfiling![4])
        swap(boxUp, toBool(value: newBarProfiling![4]))
    }
    
    @IBAction func tappedDown(_ sender: Any) {
        newBarProfiling![5] = alternate(value: newBarProfiling![5])
        swap(boxDown, toBool(value: newBarProfiling![5]))
    }
    
    @IBAction func tappedCalm(_ sender: Any) {
        newBarProfiling![6] = alternate(value: newBarProfiling![6])
        swap(boxCalm, toBool(value: newBarProfiling![6]))
        
    }
    
    @IBAction func tappedCrowded(_ sender: Any) {
        newBarProfiling![7] = alternate(value: newBarProfiling![7])
        swap(boxCrowded, toBool(value: newBarProfiling![7]))
    }
    
    @IBAction func tappedBanging(_ sender: Any) {
        newBarProfiling![8] = alternate(value: newBarProfiling![8])
        swap(boxBanging, toBool(value: newBarProfiling![8]))
    }
    
    @IBAction func tappedDay(_ sender: Any) {
        newBarProfiling![9] = alternate(value: newBarProfiling![9])
        swap(boxDay, toBool(value: newBarProfiling![9]))
    }
    
    @IBAction func tappedNight(_ sender: Any) {
        newBarProfiling![10] = alternate(value: newBarProfiling![10])
        swap(boxNight, toBool(value: newBarProfiling![10]))
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
    
    
    
    @IBAction func saveButton(_ sender: Any) {
        if (savePressed == false) {
            savePressed = true
            
            newBarProfiling![2] = Int(sliderPrice.value)
            
            Firestore.firestore().collection("users").document(Auth.auth().currentUser!.uid).updateData([
                "barprofile": newBarProfiling!
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


