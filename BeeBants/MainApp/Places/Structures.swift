//
//  Structures.swift
//  BeeBants
//
//  Created by António Ferreira on 20/08/2020.
//  Copyright © 2020 BeeBants. All rights reserved.
//

import Foundation

struct Spot: Decodable {
    enum Category: String, Decodable {
        case swift, combine, debugging, xcode
    }
    
    let id: String
    let displayName: String
    let displaySecret: String
    let displayDirections: String
    let dressCode: String
    let ambiance: String
    let speciality: String
    let bestTimes: String
    let outsideArea: Bool
    let locationID: String
    let latitude: String
    let longitude: String
    let version: Int
}

struct Location: Decodable {
    enum Category: String, Decodable {
         case swift, combine, debugging, xcode
    }
    
    let id: String
    let displayName: String
    let displayDescription: String
    let displayImgName: String
    
    
}

class Place {
    var spot : Spot
    var location : Location
    
    init(spot: Spot, location: Location) {
        self.spot = spot
        self.location = location
    }
}
