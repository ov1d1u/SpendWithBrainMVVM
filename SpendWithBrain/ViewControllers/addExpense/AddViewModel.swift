//
//  AddViewModel.swift
//  SpendWithBrain
//
//  Created by Maxim on 04/09/2020.
//  Copyright © 2020 Maxim. All rights reserved.
//

import Foundation

class AddViewModel  {
    func isExpenseValid(expense : Expense) -> String {
        var message = ""
        if expense.category == nil {
            message.append("Select one category.\n")
        }
        if !Validations.amountValid(String(expense.amount)){
            message.append("Get amount for this expense.\n")
        }
        if expense.details.count == 0 {
            message.append("Please, get some details about this expense.\n")
        }
        if message == ""{
           _ = ExpenseEntity.shared.insert(date: expense.date,
                                           amount: Double(expense.amount),
                                           category: expense.category!,
                                           details: expense.details,
                                           image: expense.image,
                                           userEmail: LocalDataBase.getToken())
            Utils.updateMainScreens()
        }
        return message
    }
    
}
