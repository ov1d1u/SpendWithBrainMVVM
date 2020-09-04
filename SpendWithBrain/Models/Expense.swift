//
//  Expense.swift
//  SpendWithBrain
//
//  Created by Maxim on 19/08/2020.
//  Copyright © 2020 Maxim. All rights reserved.
//

import Foundation
import UIKit
struct Expense : Codable,CustomStringConvertible{
    var date : Date
    var amount : Float
    var category : CategoryEnum?
    var details : String
    var image : String
    
    var description: String{
        return "\(date)..\(amount)..\(String(describing: category))..\(details)..\(image)"
    }
    
    init(){
        date = Date()
        amount = 0.0
        category = nil
        details = ""
        image = ""
    }
}

enum CategoryEnum : String,Codable{
    case Income = "Income"
    case Food = "Food"
    case Car = "Car"
    case Clothes = "Clothes"
    case Savings = "Savings"
    case Health = "Health"
    case Beauty = "Beauty"
    case Travel = "Travel"
}
