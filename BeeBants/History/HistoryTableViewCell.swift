//
//  HistoryTableViewCell.swift
//  BeeBants
//
//  Created by António Ferreira on 25/01/2021.
//  Copyright © 2021 BeeBants. All rights reserved.
//

import UIKit
import FirebaseAuth
import Firebase
import FirebaseFirestoreSwift

class HistoryTableViewCell: UITableViewCell {

    @IBOutlet weak var infoPanel: UIView!

    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var locationImg: UIImageView!
    
    @IBOutlet weak var star1: UIImageView!
    @IBOutlet weak var star2: UIImageView!
    @IBOutlet weak var star3: UIImageView!
    @IBOutlet weak var star4: UIImageView!
    @IBOutlet weak var star5: UIImageView!
    
    var historyFile = ""
    
    lazy var stars = [star1, star2, star3, star4, star5]
    var ranking = 0
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        infoPanel.layer.cornerRadius = infoPanel.frame.size.height * 0.2
        infoPanel.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        
        let tap1 = UITapGestureRecognizer(target: self, action: #selector(self.handleTap1(_:)))
        star1.addGestureRecognizer(tap1)
        
        let tap2 = UITapGestureRecognizer(target: self, action: #selector(self.handleTap2(_:)))
        star2.addGestureRecognizer(tap2)
        
        let tap3 = UITapGestureRecognizer(target: self, action: #selector(self.handleTap3(_:)))
        star3.addGestureRecognizer(tap3)
        
        let tap4 = UITapGestureRecognizer(target: self, action: #selector(self.handleTap4(_:)))
        star4.addGestureRecognizer(tap4)
        
        let tap5 = UITapGestureRecognizer(target: self, action: #selector(self.handleTap5(_:)))
        star5.addGestureRecognizer(tap5)
    }
    
    @objc func handleTap1(_ value: UITapGestureRecognizer? = nil) {
        functionupdateFeedback(1)
    }
    
    @objc func handleTap2(_ value: UITapGestureRecognizer? = nil) {
        functionupdateFeedback(2)
    }
    
    @objc func handleTap3(_ value: UITapGestureRecognizer? = nil) {
        functionupdateFeedback(3)
    }
    @objc func handleTap4(_ value: UITapGestureRecognizer? = nil) {
        functionupdateFeedback(4)
    }
    @objc func handleTap5(_ value: UITapGestureRecognizer? = nil) {
        functionupdateFeedback(5)
    }
    
    func functionupdateFeedback(_ newRanking: Int) {
        for r in 0...4 {
            stars[r]?.image =
                UIImage(named: "Star_empty")
        }
        
        
        for r in 0...newRanking-1 {
            stars[r]?.image =
                UIImage(named: "Star_full")
        }
        ranking = newRanking
        
        let _: Void = Firestore.firestore().collection("History").document(historyFile).updateData(["review":ranking])
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        for r in 0...4 {
            stars[r]?.image = UIImage(named: "Star_empty")
        }
        
        if ranking != 0 {
            for r in 0...ranking-1 {
                stars[r]?.image = UIImage(named: "Star_full")
            }
        }
    }
}
