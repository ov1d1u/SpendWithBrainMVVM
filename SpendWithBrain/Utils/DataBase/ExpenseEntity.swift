//
//  ExpenseEntity.swift
//  SpendWithBrain
//
//  Created by Maxim on 07/09/2020.
//  Copyright © 2020 Maxim. All rights reserved.
//

import Foundation
import SQLite

class ExpenseEntity {
    static let shared = ExpenseEntity()
    
    private let tblExpense = Table("tblExpense")
    
    private let date = Expression<Date>("date")
    private let amount = Expression<Double>("amount")
    private let category = Expression<String>("category")
    private let details = Expression<String>("details")
    private let image = Expression<String>("image")
    private let userId = Expression<String>("userId")
    
    private init(){
        do{
            if let connection = DBHelper.shared.connection {
                try connection.run(tblExpense.create(temporary: false, ifNotExists: true, withoutRowid: false, block: { (table) in
                    table.column(self.date, primaryKey: true)
                    table.column(self.amount)
                    table.column(self.category)
                    table.column(self.details)
                    table.column(self.image)
                    table.column(self.userId)
                }))
                print("DBHelpeer -> Create table [Expense] successfully.")
            }else{
                print("DBHelpeer -> Create table [Expense] failed. ")
            }
        } catch{
            let NSerror = error as NSError
            print("Cannot connect toDatabase.\(NSerror), \(NSerror.userInfo)")
        }
    }
    
    func insert(date : Date,amount : Double, category: CategoryEnum,details: String,image: String,userEmail: String) -> Int64?{
        do{
            let insert = tblExpense.insert(self.date <- date,
                                           self.amount <- amount,
                                           self.category <- category.rawValue,
                                           self.details <- details,
                                           self.image <- image,
                                           self.userId <- userEmail)
            let insertedId = try DBHelper.shared.connection!.run(insert)
            return insertedId
        } catch{
            let NSerror = error as NSError
            print("Cannot connect toDatabase.\(NSerror), \(NSerror.userInfo)")
            return nil
        }
    }
    
    func getAllExpense() -> [Expense] {
        do{
            if let expenses = try DBHelper.shared.connection?.prepare(self.tblExpense.filter(self.userId == LocalDataBase.getToken())){
                var returnValues : [Expense] = []
                for exp in expenses{
                    returnValues.append(Expense(exp[self.date],
                                        Float(exp[self.amount]),
                                        CategoryEnum(rawValue: exp[self.category]),
                                        exp[self.details],
                                        exp[self.image]))
                }
                return returnValues
            }
        } catch{
            let NSerror = error as NSError
            print("Cannot connect toDatabase.\(NSerror), \(NSerror.userInfo)")
            return []
        }
        return []
    }
    
    func updateExpense(id : Date, expense : Expense) -> Bool {
        let tblFlterExpense = tblExpense.filter(self.date == id)
        do {
            let update = tblFlterExpense.update([
                self.date <- expense.date,
                self.amount <- Double(expense.amount),
                self.category <- expense.category!.rawValue,
                self.details <- expense.details,
                self.image <- expense.image,
                ])
            if try DBHelper.shared.connection!.run(update) > 0 {
                return true
            }
        } catch {
            print("DBHelper -> Update expense failed: \(error)")
        }
        return false
    }
    
    func deleteExpense(id : Date) -> Bool {
        let tblFilterExpense = tblExpense.filter(self.date == id)
        do {
            let delete = tblFilterExpense.delete()
            if try DBHelper.shared.connection!.run(delete) > 0 {
                return true
            }
        } catch {
            print("DBHelper -> Delete expense failed: \(error)")
        }
        return false
    }
    
    func toString(expense : Row){
        print("""
            Expense -> Email : \(expense[self.userId])
                    -> Amount : \(expense[self.amount])
                    -> Date : \(expense[self.date])
                    -> Category : \(expense[self.category])
                    -> Details : \(expense[self.details])
                    -> Image : \(expense[self.image])
            """)
    }
}
