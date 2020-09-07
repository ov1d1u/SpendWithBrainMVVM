//
//  ShowInfoViewModel.swift
//  SpendWithBrain
//
//  Created by Maxim on 04/09/2020.
//  Copyright © 2020 Maxim. All rights reserved.
//

import Foundation

class ShowInfoViewModel {
    
    func getDateFormatForInfo(date: Date)->String{
        let dateFormat = DateFormatter()
        dateFormat.dateFormat = "yyyy-MM-dd at HH:mm"
        return dateFormat.string(from: (date))
    }
    
    func deleteThisExpense(expense : Expense){
        Utils.deleteDirectory(directoryName: expense.image)
        ExpenseEntity.shared.deleteExpense(id: expense.date)
        Utils.updateMainScreens()
    }
    
}
