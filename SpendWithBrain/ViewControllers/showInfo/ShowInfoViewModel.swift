//
//  ShowInfoViewModel.swift
//  SpendWithBrain
//
//  Created by Maxim on 04/09/2020.
//  Copyright © 2020 Maxim. All rights reserved.
//

import Foundation
import Firebase
import FirebaseDatabase

class ShowInfoViewModel {
    
    func getDateFormatForInfo(date: Date)->String{
        let dateFormat = DateFormatter()
        dateFormat.dateFormat = "yyyy-MM-dd at HH:mm"
        return dateFormat.string(from: (date))
    }
    
    func deleteThisExpense(expense : Expense){
        Database.database().reference().child("users/\(Auth.auth().currentUser!.uid)/expenses/\(expense.id!)").removeValue()
        let uid = Auth.auth().currentUser!.uid
        Storage.storage().reference().child("\(uid)/\(expense.image)").delete { (error) in
            if error != nil {
                print("Wrong instruction")
            }
        }
    }
}
