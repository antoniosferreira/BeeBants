//
//  ContactsViewController.swift
//  BeeBants
//
//  Created by António Ferreira on 29/04/2020.
//  Copyright © 2020 BeeBants. All rights reserved.
//

import UIKit

class ContactsViewController: UIViewController {

    @IBOutlet weak var mail: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func mailTapped(_ sender: Any) {
        let url = URL.init(string: "mailto:beebants@gmail.com?ContactFromApp-")
                       guard let link = url, UIApplication.shared.canOpenURL(link) else { return }
                       UIApplication.shared.open(link)
    }
    
    
    @IBAction func instaTapped(_ sender: Any) {
    let url = URL.init(string: "https://www.instagram.com/bee.bants/")
                          guard let link = url, UIApplication.shared.canOpenURL(link) else { return }
                          UIApplication.shared.open(link)
    }
    
    @IBAction func fbTapped(_ sender: Any) {
        let url = URL.init(string: "https://www.facebook.com/beebants/")
        guard let link = url, UIApplication.shared.canOpenURL(link) else { return }
        UIApplication.shared.open(link)
    }
    
    @IBAction func webTapped(_ sender: Any) {
        let url = URL.init(string: "https://beebants.wixsite.com/website")
        guard let link = url, UIApplication.shared.canOpenURL(link) else { return }
        UIApplication.shared.open(link)
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
