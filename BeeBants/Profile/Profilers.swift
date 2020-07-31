//
//  Profilers.swift
//  BeeBants
//
//  Created by António Ferreira on 29/07/2020.
//  Copyright © 2020 BeeBants. All rights reserved.
//
import Foundation
import Firebase

public class BarProfile {
    
    var document : DocumentReference?
    var name : String
    let version = 0
    
    //0, 1, 2
    var price : Int
    
    // Casual, Up-Market, Down & Dirty
    var style = [false, false, false]
    
    // Calm, Crowded, Banging
    var density = [false, false, false]
    
    // Day, Night
    var time = [false, false]
    
    init(document: DocumentSnapshot, documentReference: DocumentReference) throws {
        
        self.document = documentReference
        // Confirms no conflict of profile versions
        if (version == (document.get("version") as! Int)) {
            name = document.get("name") as! String
            price = document.get("price") as! Int
            style[0] = document.get("style1") as! Bool
            style[1] = document.get("style2") as! Bool
            style[2] = document.get("style3") as! Bool
            density[0] = document.get("density1") as! Bool
            density[1] = document.get("density2") as! Bool
            density[2] = document.get("density3") as! Bool
            time[0] = document.get("time1") as! Bool
            time[1] = document.get("time2") as! Bool
            
            return
        }
        
        throw ProfileExceptions.incompatibleVersion
    }
    
    init(profile: BarProfile) {
        self.document = profile.document
        self.name = profile.name
        self.price = profile.price
        self.style = profile.style
        self.density = profile.density
        self.time = profile.time

    }
    
    func update(_ profile: BarProfile) {
        self.document = profile.document
        self.name = profile.name
        self.price = profile.price
        self.style = profile.style
        self.density = profile.density
        self.time = profile.time
    }
    
}


public class ResProfile {
    
    var document : DocumentReference?

    var name : String
    let version = 0
    
    //0, 1, 2
    var price : Int
    
    // Vegan, Vegetarian, Halal, Pescetarian
    var dietary = [false, false, false, false]

    // Cosy, Romantic, Lively
    var ambiance = [false, false, false]

    
    init(document: DocumentSnapshot, documentReference: DocumentReference) throws {
        self.document = documentReference

        // Confirms no conflict of profile versions
        if (version == (document.get("version") as! Int)) {
            name = document.get("name") as! String
            price = document.get("price") as! Int
            dietary[0] = document.get("diet1") as! Bool
            dietary[1] = document.get("diet2") as! Bool
            dietary[2] = document.get("diet3") as! Bool
            dietary[3] = document.get("diet4") as! Bool
            ambiance[0] = document.get("amb1") as! Bool
            ambiance[1] = document.get("amb2") as! Bool
            ambiance[2] = document.get("amb3") as! Bool
            
            return
        }
        
        throw ProfileExceptions.incompatibleVersion
    }
    
    init(profile: ResProfile) {
        self.document = profile.document
        self.name = profile.name
        self.price = profile.price
        self.ambiance = profile.ambiance
        self.dietary = profile.dietary
    }
    
    func update(_ profile: ResProfile) {
        self.document = profile.document
        self.name = profile.name
        self.price = profile.price
        self.dietary = profile.dietary
        self.ambiance = profile.ambiance
    }
    
}
