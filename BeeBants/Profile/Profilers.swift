//
//  Profilers.swift
//  BeeBants
//
//  Created by António Ferreira on 29/07/2020.
//  Copyright © 2020 BeeBants. All rights reserved.
//
import Foundation

public class BarProfile {
    
    //0, 1, 2
    var price : Int
    
    // Casual, Up-Market, Down & Dirty
    var style1 : Int
    var style2 : Int
    var style3 : Int
    
    // Calm, Crowded, Banging
    var density1 : Int
    var density2 : Int
    var density3 : Int

    // Day, Night
    var time1 : Int
    var time2 : Int
    
    init(_ price : Int, _ style1 : Int,_ style2 : Int, _ style3 : Int,
         _ density1 : Int, _ density2 : Int, _ density3 : Int,
         _ time1 : Int, _ time2 : Int) {
        self.price = price
        self.style1 = style1
        self.style2 = style2
        self.style3 = style3
        self.density1 = density1
        self.density2 = density2
        self.density3 = density3
        self.time1 = time1
        self.time2 = time2
    }
}


public class ResProfile {
    
    //0, 1, 2
    var price : Int
    
    // Vegan, Vegetarian, Halal, Pescetarian, Nothing
    var dietary1 : Int
    var dietary2 : Int
    var dietary3 : Int
    var dietary4 : Int
    var dietary5 : Int

    // Cosy, Romantic, Lively
    var ambiance1 : Int
    var ambiance2 : Int
    var ambiance3 : Int

    
    init(_ price : Int, _ dietary1 : Int,_ dietary2 : Int, _ dietary3 : Int,
         _ dietary4 : Int, _ dietary5 : Int, _ ambiance1 : Int,
         _ ambiance2 : Int, _ ambiance3 : Int) {
        
        self.price = price
        self.dietary1 = dietary1
        self.dietary2 = dietary2
        self.dietary3 = dietary3
        self.dietary4 = dietary4
        self.dietary5 = dietary5
        self.ambiance1 = ambiance1
        self.ambiance2 = ambiance2
        self.ambiance3 = ambiance3
    }
}
