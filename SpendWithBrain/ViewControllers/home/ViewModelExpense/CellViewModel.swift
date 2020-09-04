//
//  cellViewModel.swift
//  SpendWithBrain
//
//  Created by Maxim on 02/09/2020.
//  Copyright © 2020 Maxim. All rights reserved.
//

import Foundation
import UIKit

struct CellViewModel {
    var day : String = ""
    var category : String = ""
    var amount : String = ""
    var type : String = ""
    var soldAfter : String = ""
    var imageCategory : UIImage = UIImage()
    var expense : Expense
    
    init(expense : Expense,soldAfterThis : Float = 0.0){
        self.expense = expense
        day = getDayString(date: expense.date)
        category = expense.category!.rawValue
        imageCategory = getCategoryImage(for: expense.category!)
        type = expense.category == .Income ? "Income" : "Expense"
        amount = expense.category == .Income ? "+\(expense.amount)" : "-\(expense.amount)"
        soldAfter = String(soldAfterThis.rounded(toPlaces: 2))
    }
    
    init(){
        self.expense = Expense()
    }
    
    private func getDayString(date : Date) -> String{
        if Calendar.current.isDateInToday(date){
            return "Today"
        }else if Calendar.current.isDateInYesterday(date){
            return "Yesterday"
        }else {
            let dateFormat = DateFormatter()
            dateFormat.dateFormat = "E d MMM"
            return  String(dateFormat.string(from: date))
        }
    }
    
    private func getCategoryImage(for category: CategoryEnum)->UIImage{
        switch category {
        case .Income: return #imageLiteral(resourceName: "money_icon.png")
        case .Food: return #imageLiteral(resourceName: "food_icon")
        case .Car: return #imageLiteral(resourceName: "car_icon")
        case .Clothes: return #imageLiteral(resourceName: "clothes")
        case .Savings: return #imageLiteral(resourceName: "savings_icon")
        case .Health: return #imageLiteral(resourceName: "health_icon")
        case .Beauty: return #imageLiteral(resourceName: "makeup_icon")
        case .Travel: return #imageLiteral(resourceName: "world")
        }
    }
    
    func getDateFormatForInfo()->String{
        let dateFormat = DateFormatter()
        dateFormat.dateFormat = "yyyy-MM-dd at HH:mm"
        return dateFormat.string(from: (expense.date))
    }
    
    func deleteThisExpense(){
        Utils.deleteDirectory(directoryName: expense.image)
        LocalDataBase.deleteExpense(expense.date)
        updateMainScreens()
    }
    
    private func updateMainScreens(){
        NotificationCenter.default.post(name: Notification.Name(rawValue: "refreshUserData"), object: nil)
        NotificationCenter.default.post(name: Notification.Name(rawValue: "refreshExpenseScreen"), object: nil)
    }
    
    func saveEditedExpense(_ date : Date){
        LocalDataBase.deleteExpense(date)
        addNewExpenseForUser()
    }
    
    func saveNewExpense(){
        addNewExpenseForUser()
    }
    
    private func addNewExpenseForUser(){
        var userInfo = LocalDataBase.getUserInfo()!
        userInfo.expenses.append(expense)
        if LocalDataBase.updateUserInfo(for: userInfo){
            updateMainScreens()
        }
    }
    
    func isExpenseValid() -> (String,String) {
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
        return ("Error",errorMesage)
    }
}
