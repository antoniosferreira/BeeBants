//
//  MenuViewController.swift
//  BeeBants
//
//  Created by António Ferreira on 27/04/2020.
//  Copyright © 2020 BeeBants. All rights reserved.
//

import UIKit
import FirebaseAuth
import Firebase

class MenuViewController: UIViewController {
    
    @IBOutlet weak var profileHi: UILabel!
    
    @IBOutlet weak var profileLabel: UILabel!
    @IBOutlet weak var hiLabel: UILabel!
    @IBOutlet weak var historyLabel: UILabel!
    @IBOutlet weak var guideLabel: UILabel!
    @IBOutlet weak var aboutLabel: UILabel!
    @IBOutlet weak var contactsLabel: UILabel!
    
    @IBOutlet weak var whiteView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        whiteView.layer.cornerRadius = 50
        setUpElements()
        
        hiLabel.adjustsFontSizeToFitWidth = true
        
        // Access to DB NAME
        let db = Firestore.firestore()
        let userRef = db.collection("Users").document(Auth.auth().currentUser!.uid);
        
        userRef.getDocument { (document, error) in
            if let document = document, document.exists {
                let firstName = document.get("name") as! String
                self.profileHi.text = firstName
                Styling.styleHiTextLabel(label: self.profileHi)
            }
        }
    }
    
    func setUpElements() {
        view.setNeedsLayout()
        view.layoutIfNeeded()
        let smallestSize = min(profileLabel.actualFontSize, historyLabel.actualFontSize, guideLabel.actualFontSize, aboutLabel.actualFontSize, contactsLabel.actualFontSize)
        profileLabel.font = profileLabel.font.withSize(smallestSize)
        historyLabel.font = historyLabel.font.withSize(smallestSize)
        guideLabel.font = guideLabel.font.withSize(smallestSize)
        aboutLabel.font = aboutLabel.font.withSize(smallestSize)
        contactsLabel.font = contactsLabel.font.withSize(smallestSize)
        
    }
    
    
    @IBAction func tappedGuide(_ sender: Any) {
        let newViewController = UIStoryboard(name: "HowTo", bundle: nil).instantiateViewController(withIdentifier: "HowToViewController") as! HowToViewController
        newViewController.afterSignUp = false
        newViewController.modalPresentationStyle = .fullScreen
        present(newViewController, animated: true, completion: nil)
        
    }
    
}

extension UILabel {
    var actualFontSize: CGFloat {
        guard let attributedText = attributedText else { return font.pointSize }
        let text = NSMutableAttributedString(attributedString: attributedText)
        text.setAttributes([.font: font as Any], range: NSRange(location: 0, length: text.length))
        let context = NSStringDrawingContext()
        context.minimumScaleFactor = minimumScaleFactor
        text.boundingRect(with: frame.size, options: .usesLineFragmentOrigin, context: context)
        let adjustedFontSize: CGFloat = font.pointSize * context.actualScaleFactor
        return adjustedFontSize
    }
}
