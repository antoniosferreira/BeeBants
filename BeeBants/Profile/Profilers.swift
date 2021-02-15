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
    
    //0, 1, 2
    var price : Int
    // Casual, Up-Market, Down & Dirty
    var style = [false, false, false]
    // Calm, Crowded, Banging
    var density = [false, false, false]
    // Day, Night
    var time = [false, false]
    
    
    init(initData : [String:Any]) {
        
        price = initData["price"] as! Int
        
        style[0] = initData["style1"] as! Bool
        style[1] = initData["style2"] as! Bool
        style[2] = initData["style3"] as! Bool
        
        density[0] = initData["density1"] as! Bool
        density[1] = initData["density2"] as! Bool
        density[2] = initData["density3"] as! Bool
            
        time[0] = initData["time1"] as! Bool
        time[1] = initData["time2"] as! Bool
        
    }
    
    init (initProfile : BarProfile) {
        price = initProfile.price
        style[0] = initProfile.style[0]
        style[1] = initProfile.style[1]
        style[2] = initProfile.style[2]
        
        density[0] = initProfile.density[0]
        density[1] = initProfile.density[1]
        density[2] = initProfile.density[2]
        
        time[0] = initProfile.time[0]
        time[1] = initProfile.time[1]
    }
    
}


public class ResProfile {
    
    //0, 1, 2
    var price : Int
    // Vegan, Vegetarian, Halal, Pescetarian
    var dietary = [false, false, false, false]
    // Cosy, Romantic, Lively
    var ambiance = [false, false, false]

    
    init(initData : [String:Any]) {
        
        price = initData["price"] as! Int
        
        ambiance[0] = initData["amb1"] as! Bool
        ambiance[1] = initData["amb2"] as! Bool
        ambiance[2] = initData["amb3"] as! Bool
        
        dietary[0] = initData["diet1"] as! Bool
        dietary[1] = initData["diet2"] as! Bool
        dietary[2] = initData["diet3"] as! Bool
        dietary[3] = initData["diet4"] as! Bool
    }
    
    init (initProfile : ResProfile) {
        price = initProfile.price
        
        dietary[0] = initProfile.dietary[0]
        dietary[1] = initProfile.dietary[1]
        dietary[2] = initProfile.dietary[2]
        dietary[3] = initProfile.dietary[3]
        
        ambiance[0] = initProfile.ambiance[0]
        ambiance[1] = initProfile.ambiance[1]
        ambiance[2] = initProfile.ambiance[2]
        
    }
    
}
