//
//  PlaceStructure.swift
//  BeeBants
//
//  Created by António Ferreira on 02/07/2020.
//  Copyright © 2020 BeeBants. All rights reserved.
//

import Foundation
import UIKit

class SpotStructure {
    
    var place_name : String
    var place_ambiance: String
    var place_bestTimes : String
    var place_dressCode : String
    var place_outsideArea : Bool
    var place_secret : String
    var place_speciality : String
    var place_directions : String
    var place_latitude : String
    var place_longitude : String
    var location : String

    init(placeName : String, placeSecret: String, placeAmbiance: String,
         placeBestTimes: String, placeDressCode: String,
         placeOutsideArea: Bool, placeSpeciality : String,
         placeLocation : String, placeDirections: String,
         placeLatitude: String, placeLongitude: String) {
        
        self.place_name = placeName;
        self.place_secret = placeSecret;
        self.place_ambiance = placeAmbiance;
        self.place_bestTimes = placeBestTimes;
        
        self.place_dressCode = placeDressCode;
        self.place_outsideArea = placeOutsideArea;
        self.place_speciality = placeSpeciality;
        self.place_directions = placeDirections;
        self.location = placeLocation;
        self.place_latitude = placeLatitude;
        self.place_longitude = placeLongitude;
    }
}


class LocationStructure {
    
    var name : String
    var description: String
    var img : UIImage
    
    init(name: String, desc: String, img: UIImage) {
        self.name = name
        self.description = desc
        self.img = img
    }
}

class Place {
    var spot : Spot
    var location : Location
    
    init(spot: Spot, location: Location) {
        self.spot = spot
        self.location = location
    }
}
