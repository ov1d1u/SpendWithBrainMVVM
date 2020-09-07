//
//  EditViewModel.swift
//  SpendWithBrain
//
//  Created by Maxim on 04/09/2020.
//  Copyright © 2020 Maxim. All rights reserved.
//

import Foundation

class EditViewModel {
    
    func isExpenseValid(id : Date,expense : Expense) -> String {
        var errorMesage = ""
        if expense.category == nil {
            errorMesage.append("Select one category.\n")
        }
        if !Validations.amountValid(String(expense.amount)){
            errorMesage.append("Get amount for this expense.\n")
        }
        if expense.details.count == 0 {
            errorMesage.append("Please, get some details about this expense.\n")
        }
        if errorMesage == ""{
            ExpenseEntity.shared.updateExpense(id: id, expense: expense)
            Utils.updateMainScreens()
        }
        return errorMesage
    }
    
    
    
}
