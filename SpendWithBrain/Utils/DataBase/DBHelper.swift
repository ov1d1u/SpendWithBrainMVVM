//
//  DBHelper.swift
//  SpendWithBrain
//
//  Created by Maxim on 07/09/2020.
//  Copyright © 2020 Maxim. All rights reserved.
//

import Foundation
import SQLite

class DBHelper {
    static let shared = DBHelper()
    public let connection : Connection?
    public let databaseFileName = "table.db"
    private init(){
        let dbPaht = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first as String!
        do{
            connection = try Connection("\(dbPaht!)\(databaseFileName)")
        }catch{
            connection = nil
            let NSerror = error as NSError
            print("Cannot connect toDatabase.\(NSerror), \(NSerror.userInfo)")
        }
    }
}
