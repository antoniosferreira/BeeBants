//
//  Profilers.swift
//  BeeBants
//
//  Created by António Ferreira on 29/07/2020.
//  Copyright © 2020 BeeBants. All rights reserved.
//
import Foundation

public class BarProfile {
    
    var encodedProfile : [Int]
    
    //0, 1, 2
    var price : Int
    
    // Casual, Up-Market, Down & Dirty
    var style1 : Bool
    var style2 : Bool
    var style3 : Bool
    
    // Calm, Crowded, Banging
    var density1 : Bool
    var density2 : Bool
    var density3 : Bool

    // Day, Night
    var time1 : Bool
    var time2 : Bool
    
    init(_ encodedProfile: [Int]) {
        self.encodedProfile = encodedProfile
        self.price = encodedProfile[2]
        self.style1 = (encodedProfile[3] == 1) ? true : false
        self.style2 = (encodedProfile[4] == 1) ? true : false
        self.style3 = (encodedProfile[5] == 1) ? true : false
        self.density1 = (encodedProfile[6] == 1) ? true : false
        self.density2 = (encodedProfile[7] == 1) ? true : false
        self.density3 = (encodedProfile[8] == 1) ? true : false
        self.time1 = (encodedProfile[9] == 1) ? true : false
        self.time2 = (encodedProfile[10] == 1) ? true : false
    }
}


public class ResProfile {
    
    var encodedProfile : [Int]
    
    //0, 1, 2
    var price : Int
    
    // Vegan, Vegetarian, Halal, Pescetarian, Nothing
    var dietary1 : Bool
    var dietary2 : Bool
    var dietary3 : Bool
    var dietary4 : Bool
    var dietary5 : Bool

    // Cosy, Romantic, Lively
    var ambiance1 : Bool
    var ambiance2 : Bool
    var ambiance3 : Bool

    
    init(_ encodedProfile: [Int]) {
        
        self.encodedProfile = encodedProfile
        self.price = encodedProfile[2]
        self.dietary1 = (encodedProfile[3] == 1) ? true : false
        self.dietary2 = (encodedProfile[4] == 1) ? true : false
        self.dietary3 = (encodedProfile[5] == 1) ? true : false
        self.dietary4 = (encodedProfile[6] == 1) ? true : false
        self.dietary5 = (encodedProfile[7] == 1) ? true : false
        self.ambiance1 = (encodedProfile[8] == 1) ? true : false
        self.ambiance2 = (encodedProfile[9] == 1) ? true : false
        self.ambiance3 = (encodedProfile[10] == 1) ? true : false
    }
}
