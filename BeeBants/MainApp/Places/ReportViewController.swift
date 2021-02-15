//
//  ReportViewController.swift
//  BeeBants
//
//  Created by António Ferreira on 25/01/2021.
//  Copyright © 2021 BeeBants. All rights reserved.
//

import UIKit
import MessageUI

class ReportViewController: UIViewController, MFMailComposeViewControllerDelegate {

    var pageController : PlacesPageViewController!


    @IBOutlet weak var report1: RoundButton!
    @IBOutlet weak var report2: RoundButton!
    @IBOutlet weak var report3: RoundButton!
    @IBOutlet weak var report4: RoundButton!
    @IBOutlet weak var report5: RoundButton!
    @IBOutlet weak var report6: RoundButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        Styling.styleRedUnfilledButton(button: report1)
        Styling.styleRedUnfilledButton(button: report2)
        Styling.styleRedUnfilledButton(button: report3)
        Styling.styleRedUnfilledButton(button: report4)
        Styling.styleRedUnfilledButton(button: report5)
        Styling.styleRedUnfilledButton(button: report6)
    }
    

    @IBAction func tap_goback(_ sender: Any) {
        
    }
    
    @IBAction func report_1(_ sender: Any) {
        let body = "The location " + pageController!.getPlace().spot.displayName + " was closed"
        sendEmail("[R1] The Venue was closed", body)
    }

    @IBAction func report_2(_ sender: Any) {
        let body = "The location " + pageController!.getPlace().spot.displayName + " was packed"
        sendEmail("[R2] There was a queue", body)
    }
    @IBAction func report_3(_ sender: Any) {
        let body = "The staff at " + pageController!.getPlace().spot.displayName + " were terrible"
        sendEmail("[R3] The Staff were terrible", body)
    }
    @IBAction func report_4(_ sender: Any) {
        let body = "The location " + pageController!.getPlace().spot.displayName + " was more expensive than desired"
        sendEmail("[R4] The prices were too high", body)
    }
    @IBAction func report_5(_ sender: Any) {
        let body = "An unexpected entry fee at " + pageController!.getPlace().spot.displayName + "???"
        sendEmail("[R5] There was an entry fee", body)
    }
    @IBAction func report_6(_ sender: Any) {
        let body = "The location " + pageController!.getPlace().spot.displayName + " was closed"
        sendEmail("[R6] Other Problem - " + pageController!.getPlace().spot.displayName, body)
    }
    
    func sendEmail(_ subject: String, _ body: String) {
        // Modify following variables with your text / recipient
        let recipientEmail = "beebants@gmail.com"
                
        // Show default mail composer
        if MFMailComposeViewController.canSendMail() {
            let mail = MFMailComposeViewController()
            mail.mailComposeDelegate = self
            mail.setToRecipients([recipientEmail])
            mail.setSubject(subject)
            mail.setMessageBody(body, isHTML: false)
                    
            present(mail, animated: true)
                
        // Show third party email composer if default Mail app is not present
        } else if let emailUrl = createEmailUrl(to: recipientEmail, subject: subject, body: body) {
            UIApplication.shared.open(emailUrl)
        }
    }
    
    private func createEmailUrl(to: String, subject: String, body: String) -> URL? {
        let subjectEncoded = subject.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        let bodyEncoded = body.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
            
        let gmailUrl = URL(string: "googlegmail://co?to=\(to)&subject=\(subjectEncoded)&body=\(bodyEncoded)")
        let outlookUrl = URL(string: "ms-outlook://compose?to=\(to)&subject=\(subjectEncoded)")
        let yahooMail = URL(string: "ymail://mail/compose?to=\(to)&subject=\(subjectEncoded)&body=\(bodyEncoded)")
        let sparkUrl = URL(string:"readdle-spark://compose?recipient=\(to)&subject=\(subjectEncoded)&body=\(bodyEncoded)")
        let defaultUrl = URL(string: "mailto:\(to)?subject=\(subjectEncoded)&body=\(bodyEncoded)")
                
        if let gmailUrl = gmailUrl, UIApplication.shared.canOpenURL(gmailUrl) {
            return gmailUrl
        } else if let outlookUrl = outlookUrl, UIApplication.shared.canOpenURL(outlookUrl) {
            return outlookUrl
        } else if let yahooMail = yahooMail, UIApplication.shared.canOpenURL(yahooMail) {
            return yahooMail
            
        } else if let sparkUrl = sparkUrl, UIApplication.shared.canOpenURL(sparkUrl) {
            return sparkUrl
            
        }
        return defaultUrl
        
    }
    
    
}
