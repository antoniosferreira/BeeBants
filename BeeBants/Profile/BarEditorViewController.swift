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
import FirebaseFunctions

class BarEditorViewController: UIViewController {

    var profileViewController : ProfileViewController?
    var barProfile : BarProfile?
    var oldBarProfile : BarProfile?
    private var savePressed : Bool = false
    
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

        barProfile = BarProfile(initProfile: oldBarProfile!)
        fixFontSize()
        Styling.styleRedFilledButton(button: buttonSave)
        
        updateProfileInfo()
    }

    
    @IBAction func sliderChanged(_ sender: Any) {
        sliderPrice.setValue(round(sliderPrice.value * 1.0) / 1.0, animated: true)
        barProfile?.price = Int(sliderPrice.value)
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
    
    @IBAction func saveButton(_ sender: Any) {
        if (savePressed == false) {
            savePressed = true

            
            let newProfile : [String:Any] = [
                "price": barProfile!.price,
                "style1": barProfile!.style[0],
                "style2": barProfile!.style[1],
                "style3": barProfile!.style[2],
                
                "density1": barProfile!.density[0],
                "density2": barProfile!.density[1],
                "density3": barProfile!.density[2],

                "time1": barProfile!.time[0],
                "time2": barProfile!.time[1]
            ]
    
            
            Functions.functions().httpsCallable("updateBarProfile").call(newProfile) {
                (result, error) in
                
                if let error = error {
                    let alert = UIAlertController(title: "Something went wrong", message: error.localizedDescription, preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Try again", style: .destructive, handler:nil))
                    self.present(alert, animated: true, completion: nil)
                    self.savePressed = false

                } else {
                    self.dismiss(animated: true, completion: {self.profileViewController?.barProfile=self.barProfile ;self.profileViewController?.updateDisplayedData()})
                }
            }
        }
    
    }
    
    private func updateProfileInfo() {
        sliderPrice.setValue(Float(barProfile!.price), animated: true)
        swap(boxCasual, barProfile!.style[0])
        swap(boxUp, barProfile!.style[1])
        swap(boxDown, barProfile!.style[2])
        
        swap(boxCalm, barProfile!.density[0])
        swap(boxCrowded, barProfile!.density[1])
        swap(boxBanging, barProfile!.density[2])

        swap(boxDay, barProfile!.time[0])
        swap(boxNight, barProfile!.time[1])
    }
    
    
    private func swap(_ button: UIImageView, _ value: Bool) {
        if value {
            button.image = UIImage(named: "selectionbox_selected")!
        } else {
            button.image = UIImage(named: "selectionbox_empty")!
        }
    }
    
    @IBAction func tappedCasual(_ sender: Any) {
        barProfile!.style[0] = !barProfile!.style[0]
        swap(boxCasual, barProfile!.style[0])
    }

    @IBAction func tappedUp(_ sender: Any) {
        barProfile!.style[1] = !barProfile!.style[1]
        swap(boxUp, barProfile!.style[1])
    }
    
    @IBAction func tappedDown(_ sender: Any) {
        barProfile!.style[2] = !barProfile!.style[2]
        swap(boxDown, barProfile!.style[2])
    }
    
    @IBAction func tappedCalm(_ sender: Any) {
        barProfile!.density[0] = !barProfile!.density[0]
        swap(boxCalm, barProfile!.density[0])
    }
    
    @IBAction func tappedCrowded(_ sender: Any) {
        barProfile!.density[1] = !barProfile!.density[1]
        swap(boxCrowded, barProfile!.density[1])
    }
    
    @IBAction func tappedBanging(_ sender: Any) {
        barProfile!.density[2] = !barProfile!.density[2]
        swap(boxBanging, barProfile!.density[2])
    }
    
    @IBAction func tappedDay(_ sender: Any) {
        barProfile!.time[0] = !barProfile!.time[0]
        swap(boxDay, barProfile!.time[0])
    }
    
    @IBAction func tappedNight(_ sender: Any) {
        barProfile!.time[1] = !barProfile!.time[1]
        swap(boxNight, barProfile!.time[1])
    }
    
    @IBAction func tapGoBack(_ sender: Any) {
        self.dismiss(animated: true, completion: {self.profileViewController?.updateDisplayedData()})
    }
    

}


