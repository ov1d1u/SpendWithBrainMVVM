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
        return defaults.string(forKey: "name")!
    }
}
