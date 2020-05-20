//
//  LastPageViewController.swift
//  BeeBants
//
//  Created by António Ferreira on 18/05/2020.
//  Copyright © 2020 BeeBants. All rights reserved.
//

import UIKit

class LastPageViewController: UIViewController {

    @IBOutlet weak var sureButton: RoundButton!
    @IBOutlet weak var laterButton: RoundButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        styleUpElements()
    }
    
    func styleUpElements() {
        Styling.styleRedFilledButton(button: sureButton)
        Styling.styleRedUnfilledButton(button: laterButton)
    }

    @IBAction func goToProfile(_ sender: Any) {
        let profile = UIStoryboard(name: "Profile", bundle: nil).instantiateViewController(withIdentifier: "profile_1") as! ProfileEditorViewController
        profile.modalPresentationStyle = .fullScreen
        present(profile, animated: true)
        return
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
