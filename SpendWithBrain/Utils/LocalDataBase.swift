//
//  LocalDataBase.swift
//  SpendWithBrain
//
//  Created by Maxim on 20/08/2020.
//  Copyright © 2020 Maxim. All rights reserved.
//

import Foundation

class LocalDataBase{
    private static let defaults = UserDefaults.standard
    
    static func saveName(_ name : String){
        defaults.set(name, forKey: "name")
    }
    
    static func getName() -> String{
        return defaults.string(forKey: "name") ?? ""
    }
    
    static func setSold(_ sold : Float) {
        let soldString = String(sold)
        defaults.set(soldString, forKey: "sold")
    }
    
    static func getSold()->String{
        return defaults.string(forKey: "sold") ?? "0.0"
    }
}
