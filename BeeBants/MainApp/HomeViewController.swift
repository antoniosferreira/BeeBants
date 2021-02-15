//
//  HomeViewController.swift
//  BeeBants
//
//  Created by António Ferreira on 27/04/2020.
//  Copyright © 2020 BeeBants. All rights reserved.
//

import UIKit
import FirebaseAuth

class HomeViewController: SOContainerViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    @IBOutlet weak var blurView: UIView!
    @IBOutlet weak var specificsView: UIView!
    
    @IBOutlet weak var barsButton: RoundButton!
    @IBOutlet weak var resButton: RoundButton!
    
    @IBOutlet weak var specificsButton: RoundButton!
    @IBOutlet weak var pickerView: UIPickerView!
    
    let barSpecifics = ["I'm up for anything!", "Sports", "Gin Night", "Whisky Bar", "Stand-up Comedy", "Live Music", "Proihibiton Bar", "Cocktail", "Tequila", "Real Beer", "Wine Bar", "Games Night", "LGBTQ+", "Drag", "Outside Area", "Irish", "Karaoke"]
    
    let resSpecifics = ["I'm up for anything!", "Indian/Nepalese", "Chinese", "Thai", "Japanese", "Fish & Chips", "Mexican", "Italian", "Pizza", "Tapas", "Seafood", "Hangover Breakfast", "South American", "Caribbean", "Vietnamese", "Polish", "Greek", "French", "Vegan", "Brunch", "African", "Middle Eastern", "Korean", "American", "Ukranian"]

    lazy var specifics = resSpecifics
    lazy var isBar = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.pickerView.delegate = self
        self.pickerView.dataSource = self
        
        self.menuSide = .right
        self.sideViewController = self.storyboard?.instantiateViewController(withIdentifier: "menu")
        
        
        // Do any additional setup after loading the view.
        setUpElements()
    }
    
    
    
    func setUpElements() {
        Styling.styleRedFilledButton(button: specificsButton)
        Styling.styleRedFilledButton(button: barsButton)
        Styling.styleRedFilledButton(button: resButton)
        
        specificsView.layer.cornerRadius = specificsView.frame.size.height / 10
        specificsView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner, .layerMinXMaxYCorner, .layerMaxXMaxYCorner]
    }
    
    @IBAction func openMenu(_ sender: Any) {
        if let container = self.so_containerViewController {
            container.isSideViewControllerPresented = true
        }
    }
    
    
    
    @IBAction func tappedBars(_ sender: Any) {
        UIView.animate(withDuration: 0.45) {
            self.specifics = self.barSpecifics
            self.pickerView.reloadAllComponents()
            self.blurView.alpha = 0.5
            self.specificsView.alpha = 1
            self.isBar = true
        }
        
        
    }
    
    
    @IBAction func tappedRestaurants(_ sender: Any) {
        UIView.animate(withDuration: 0.45) {

            self.specifics = self.resSpecifics
            self.pickerView.reloadAllComponents()
            self.blurView.alpha = 0.5
            self.specificsView.alpha = 1
            self.isBar = false
        }
        
    }
    
    override func didReceiveMemoryWarning() {
         super.didReceiveMemoryWarning()
         // Dispose of any resources that can be recreated.
     }

     // Number of columns of data
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
         return 1
     }
     
     // The number of rows of data
     func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
         return specifics.count
     }
     
     // The data to return fopr the row and component (column) that's being passed in
     func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
         return specifics[row]
     }
    
    @IBAction func tapped_dismissSpecifics(_ sender: Any) {
        UIView.animate(withDuration: 0.45) {
            self.blurView.alpha = 0
            self.specificsView.alpha = 0
        }

    }
    
    
    @IBAction func tapped_startExperience(_ sender: Any) {
        if isBar {
            
            let storyBoard: UIStoryboard = UIStoryboard(name: "Places", bundle: nil)
            let newViewController = storyBoard.instantiateViewController(withIdentifier: "PlacesHomeViewController") as! PlacesHomeViewController
            newViewController.modalPresentationStyle = .fullScreen
            newViewController.isBar = true
            newViewController.specific = pickerView.selectedRow(inComponent: 0)
            
            self.present(newViewController, animated: true, completion: nil)
        } else {
            
            let storyBoard: UIStoryboard = UIStoryboard(name: "Places", bundle: nil)
            let newViewController = storyBoard.instantiateViewController(withIdentifier: "PlacesHomeViewController") as! PlacesHomeViewController
            newViewController.modalPresentationStyle = .fullScreen
            newViewController.isBar = false
            newViewController.specific = pickerView.selectedRow(inComponent: 0)
            
            self.present(newViewController, animated: true, completion: nil)
        }
        
    }
}
