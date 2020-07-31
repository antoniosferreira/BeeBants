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

    var profileViewController : ProfileViewController?
    
    var resProfile : ResProfile?
    var oldResProfile : ResProfile?

    private var savePressed = false
    
    // LABELS TITLE
    @IBOutlet weak var labelPrice: UILabel!
    @IBOutlet weak var labelDietary: UILabel!
    @IBOutlet weak var labelAmbiance: UILabel!
    lazy var displayedTitles = [labelPrice, labelDietary, labelAmbiance]
    
    // LABELS DATA
    @IBOutlet weak var labelVegan: UILabel!
    @IBOutlet weak var labelVegetarian: UILabel!
    @IBOutlet weak var labelHalal: UILabel!
    @IBOutlet weak var labelPescetarian: UILabel!
    @IBOutlet weak var labelCosy: UILabel!
    @IBOutlet weak var labelRomantic: UILabel!
    @IBOutlet weak var labelLively: UILabel!
    lazy var displayedData = [labelVegan, labelVegetarian, labelHalal, labelPescetarian, labelCosy, labelRomantic, labelLively]
    
    
    // BOXES
    @IBOutlet weak var sliderPrice: UISlider!
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

        resProfile = ResProfile(profile: oldResProfile!)
        
        fixFontSize()
        Styling.styleRedFilledButton(button: saveButton)
        
        updateProfileInfo()

    }
    
    @IBAction func sliderChanged(_ sender: Any) {
        sliderPrice.setValue(round(sliderPrice.value * 1.0) / 1.0, animated: true)
        resProfile?.price = Int(sliderPrice.value)
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
    
    
    @IBAction func tappedSave(_ sender: Any) {
        if (savePressed == false) {
            
            savePressed = true
            
            // Confirms at least one diet is selected
            var dietOk = false
            for value in resProfile!.dietary {
                if value == true {
                    dietOk = true
                    break
                }
            }
            
            // Confirms at least one density is selected
            var ambOk = false
            for value in resProfile!.ambiance {
                if value == true {
                    ambOk = true
                    break
                }
            }
            
            
            if (!(ambOk && dietOk)) {
                savePressed = false
                let alert = ProfileBadValuesAlert(title: "Something missing!", message: "Make sure you select at least one option for each section", buttonTitle: "OK")
                self.present(alert.getAlert(), animated: true, completion: nil)
                return
            }
            
            
            
            // Updates Bar Doc
            
            let uid = Auth.auth().currentUser!.uid

            oldResProfile!.update(resProfile!)
            oldResProfile!.document!.setData([
                "uid": uid,
                "version": 0,
                "name": resProfile!.name,
                "diet1": resProfile!.dietary[0],
                "diet2": resProfile!.dietary[1],
                "diet3": resProfile!.dietary[2],
                "diet4": resProfile!.dietary[3],
                "amb1": resProfile!.ambiance[0],
                "amb2": resProfile!.ambiance[1],
                "amb3": resProfile!.ambiance[2],
                "price": resProfile!.price
            ])
            
            self.dismiss(animated: true, completion: {self.profileViewController?.updateDisplayedData()})
        }
    }
    
    
    
    
    private func updateProfileInfo() {
        sliderPrice.setValue(Float(resProfile!.price), animated: true)
        swap(boxVegan, resProfile!.dietary[0])
        swap(boxVegetarian, resProfile!.dietary[1])
        swap(boxHalal, resProfile!.dietary[2])
        swap(boxPescetarian, resProfile!.dietary[3])
        
        swap(boxCosy, resProfile!.ambiance[0])
        swap(boxRomantic, resProfile!.ambiance[1])
        swap(boxLively, resProfile!.ambiance[2])
    }
    
    private func swap(_ button: UIImageView, _ value: Bool) {
        if value {
            button.image = UIImage(named: "selectionbox_selected")!
        } else {
            button.image = UIImage(named: "selectionbox_empty")!
        }
    }
    
    
    @IBAction func tappedVegan(_ sender: Any) {
        resProfile!.dietary[0] = !resProfile!.dietary[0]
        swap(boxVegan, resProfile!.dietary[0])
    }
    
    @IBAction func tappedVegetarian(_ sender: Any) {
        resProfile!.dietary[1] = !resProfile!.dietary[1]
        swap(boxVegetarian, resProfile!.dietary[1])
    }
    @IBAction func tappedHalal(_ sender: Any) {
        resProfile!.dietary[2] = !resProfile!.dietary[2]
        swap(boxHalal, resProfile!.dietary[2])
    }
    @IBAction func tappedPesc(_ sender: Any) {
        resProfile!.dietary[3] = !resProfile!.dietary[3]
        swap(boxPescetarian, resProfile!.dietary[3])
    }
    
    @IBAction func tappedCosy(_ sender: Any) {
        resProfile!.ambiance[0] = !resProfile!.ambiance[0]
        swap(boxCosy, resProfile!.ambiance[0])
    }
    @IBAction func tappedRomantic(_ sender: Any) {
        resProfile!.ambiance[1] = !resProfile!.ambiance[1]
        swap(boxRomantic, resProfile!.ambiance[1])
    }
    
    @IBAction func tappedLively(_ sender: Any) {
        resProfile!.ambiance[2] = !resProfile!.ambiance[2]
        swap(boxLively, resProfile!.ambiance[2])
    }
    
    @IBAction func tapGoBack(_ sender: Any) {
        self.dismiss(animated: true, completion: {self.profileViewController?.updateDisplayedData()})
    }
}
