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
    private static let curentSessionToken = "curentToken"
    private static let defaults = UserDefaults.standard
    //on autologin
    static func saveUserToken(for email: String){
        print("LocalDB -> Save token in local storage(autologin) for \(email)")
        defaults.set(email, forKey: curentSessionToken)
        defaults.synchronize()
    }
    //off autologin
    static func removeUserToken(){
        print("LocalDB -> Remove autologin for \(String(describing: defaults.string(forKey: curentSessionToken)))")
        defaults.removeObject(forKey: curentSessionToken)
        defaults.synchronize()
    }
    
    static func createUser(for email : String,userData : User)->Bool{
        if defaults.string(forKey: token) != nil{
            //this user already exists
            return false;
        }else{
            print("LocalDB -> Create account for \(email)")
            defaults.set(encodeUser(userData),forKey:email)
            defaults.synchronize()
            return true
        }
    }
    
    static func isEmailAlreadyExist(for email:String)->Bool{
        let userDefaultsKeys = defaults.dictionaryRepresentation().keys
        for thisKey in userDefaultsKeys{
            if thisKey == email {
                return true
            }
        }
        return false
    }
    static func getPasswordForLoginCheck(for email:String) -> String?{
        if let userJson = defaults.string(forKey: email){
            let user = decodeUser(userJson)
            print("LocalDB -> Getting password for check input password for \(email)")
            return user.password
        }
        return nil
    }
    
    static func checkIfUserExist(for email:String)->Bool{
        print("LocalDB -> Check if user with \(email) exist")
        return defaults.string(forKey: email) != nil
    }
    
    static func getUserInfo()->User?{
        if let userEmail = defaults.string(forKey: curentSessionToken){
            if let userJson = defaults.string(forKey: userEmail){
                print("LocalDB -> Getting info about \(userEmail)")
                return decodeUser(userJson)
            }
        }
        return nil
    }
    
    static func updateUserInfo(for userData: User)->Bool{
        if getUserInfo() != nil {
            let email = defaults.string(forKey: curentSessionToken)!
            defaults.set(encodeUser(userData),forKey:email)
            defaults.synchronize()
            return true;
        }else{
            return false;
        }
    }
    
    static func checkToken() -> Bool{
        if let userSavedEmail = defaults.string(forKey: curentSessionToken){
            print("LocalDB -> autologin with \(userSavedEmail)")
            return true
        }
        return false
    }
    
    static func deleteExpense(_ date : Date){
        var currUser = getUserInfo()
        var id = 0
        for index in currUser!.expenses.indices{
            if currUser!.expenses[index].date == date{
                id = index
                break
            }
        }
        currUser?.expenses.remove(at: id)
        if updateUserInfo(for: currUser!){
            print("LocalDB -> expense was deleted.")
        }
    }
    
    //
    //
    //encode/decode methods
    private static func encodeUser(_ user :User)->String?{
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        
        do {
            let jsonData = try encoder.encode(user)
            if let jsonString = String(data: jsonData, encoding: .utf8) {
                return jsonString
            }
        } catch {
            print(error.localizedDescription)
        }
        return nil
    }
    
    private static func decodeUser(_ jsonString : String)->User{
        let jsonData = jsonString.data(using: .utf8)!
        let user = try! JSONDecoder().decode(User.self, from: jsonData)
        return user
    }
}
