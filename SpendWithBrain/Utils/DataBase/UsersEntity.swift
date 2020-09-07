//
//  UsersEntity.swift
//  SpendWithBrain
//
//  Created by Maxim on 07/09/2020.
//  Copyright © 2020 Maxim. All rights reserved.
//

import Foundation
import SQLite

class UsersEntity  {

    static let shared = UsersEntity()
    private let tblUsers = Table("users")
    
    private let emailId = Expression<String>("email_id")
    private let password = Expression<String>("password")
    private let fullName = Expression<String>("full_name")
    
    private init(){
        do{
            if let connection = DBHelper.shared.connection {
                try connection.run(tblUsers.create(temporary: false, ifNotExists: true, withoutRowid: false, block: { (table) in
                    table.column(self.emailId, primaryKey: true)
                    table.column(self.password)
                    table.column(self.fullName)
                }))
                print("DBHelpeer -> Create table [Users] successfully.")
            }else{
                print("DBHelpeer -> Create table [Users] failed. ")
            }
        } catch{
            let NSerror = error as NSError
            print("Cannot connect toDatabase.\(NSerror), \(NSerror.userInfo)")
        }
    }
    
    func getName() -> String {
        do{
            return try (DBHelper.shared.connection?.prepare(self.tblUsers.filter(self.emailId == LocalDataBase.getToken())).first(where: { (row) -> Bool in
                row[self.emailId].count>0
            })?[self.fullName])!
        } catch{
            let NSerror = error as NSError
            print("Cannot connect toDatabase.\(NSerror), \(NSerror.userInfo)")
            return ""
        }
    }
    
    func insert(email : String,password: String,name: String) -> Int64?{
        do{
            let insert = tblUsers.insert(self.emailId <- email,
                                         self.password <- password,
                                         self.fullName <- name)
            let insertedId = try DBHelper.shared.connection!.run(insert)
            return insertedId
        } catch{
            let NSerror = error as NSError
            print("Cannot connect toDatabase.\(NSerror), \(NSerror.userInfo)")
            return nil
        }
    }
    
    func getPassword(forEmail email: String)-> String? {
        do{
            return try DBHelper.shared.connection?.prepare(self.tblUsers.filter(self.emailId == email)).first(where: { (row) -> Bool in
                row[self.emailId].count>0
            })?[self.password]
        } catch{
            let NSerror = error as NSError
            print("Cannot connect toDatabase.\(NSerror), \(NSerror.userInfo)")
            return nil
        }
    }
    
    func chechIfUserExist(for email: String) -> Bool{
        do{
            let returnedValues : AnySequence<Row>? = try DBHelper.shared.connection?.prepare(self.tblUsers)
            if returnedValues != nil {
                return true
            }
        } catch{
            let NSerror = error as NSError
            print("Cannot connect toDatabase.\(NSerror), \(NSerror.userInfo)")
        }
        return true
    }
    
    func selectAll() -> AnySequence<Row>? {
        do{
            return try DBHelper.shared.connection?.prepare(self.tblUsers)
        } catch{
            let NSerror = error as NSError
            print("Cannot connect toDatabase.\(NSerror), \(NSerror.userInfo)")
            return nil
        }
    }
    
    func toString(user : Row){
        print("""
            User -> Email : \(user[self.emailId])
                 -> Password : \(user[self.password])
                 -> Name : \(user[self.fullName])
            """)
    }
    
}
