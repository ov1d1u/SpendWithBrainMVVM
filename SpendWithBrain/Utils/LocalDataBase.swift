//
//  LocalDataBase.swift
//  SpendWithBrain
//
//  Created by Maxim on 20/08/2020.
//  Copyright © 2020 Maxim. All rights reserved.
//

import Foundation

class LocalDataBase{
    private static let token = "token"
    private static let curentSessionTokenEmail = "curentTokenEmail"
    private static let curentSessionTokenPassword = "curentTokenPassword"
    private static let defaults = UserDefaults.standard
    
    static func getToken()->String{
        return defaults.string(forKey: curentSessionTokenEmail)!
    }
    //on autologin
    static func saveUserToken(for email: String,with password: String){
        print("LocalDB -> Save token in local storage(autologin) for \(email)")
        defaults.set(email, forKey: curentSessionTokenEmail)
        defaults.set(password, forKey: curentSessionTokenPassword)
        defaults.synchronize()
    }
    //off autologin
    static func removeUserToken(){
        print("LocalDB -> Remove autologin for \(String(describing: defaults.string(forKey: curentSessionTokenEmail)))")
        defaults.removeObject(forKey: curentSessionTokenEmail)
        defaults.removeObject(forKey: curentSessionTokenPassword)
        defaults.synchronize()
    }
    
    static func checkToken() -> Bool{
        if let userSavedEmail = defaults.string(forKey: curentSessionTokenEmail){
            print("LocalDB -> autologin with \(userSavedEmail)")
            return true
        }
        return false
    }
    
    static func saveName(_ name : String){
        defaults.set(name, forKey: "name")
    }
    
    static func getName() -> String{
        return defaults.string(forKey: "name")!
    }
    
}
