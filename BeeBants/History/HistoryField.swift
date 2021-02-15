//
//  HistoryField.swift
//  BeeBants
//
//  Created by António Ferreira on 26/01/2021.
//  Copyright © 2021 BeeBants. All rights reserved.
//

import Foundation
import Firebase

public class HistoryField {
    
    var spotName : String
    var location : UIImage
    
    var date : String
    var ranking : Int
    var stamp : Date
    
    var historyFile: String
    
    init(name: String, img: UIImage, timestamp: Timestamp, review: Int, fileName: String) {
        
        spotName = name
        ranking = review
        location = img
        historyFile = fileName
        
        stamp = Date(timeIntervalSince1970: TimeInterval(timestamp.seconds))
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "d, MMM"
        date = dateFormatter.string(from: stamp)
        
    }
}
