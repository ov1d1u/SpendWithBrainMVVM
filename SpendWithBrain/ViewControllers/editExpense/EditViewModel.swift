//
//  EditViewModel.swift
//  SpendWithBrain
//
//  Created by Maxim on 04/09/2020.
//  Copyright © 2020 Maxim. All rights reserved.
//

import Foundation
import FirebaseDatabase
import Firebase
class EditViewModel {
    
    func isExpenseValid(expense : Expense,img : UIImage) -> String {
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
            let rootPath = Auth.auth().currentUser!.uid
            Database.database().reference().child("users/\(rootPath)/expenses/\(expense.id!)").updateChildValues(["date":expense.date.description,
                                                                                                  "amount":expense.amount,
                                                                                                  "category":expense.category!.rawValue,
                                                                                                  "details":expense.details,
                                                                                                  "image":expense.image])
            let Ref = Storage.storage().reference().child("\(rootPath)/\(expense.image)")
            Ref.putData(img.pngData()!)
        }
        return errorMesage
    }
}
