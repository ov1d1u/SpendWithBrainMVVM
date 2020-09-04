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
    
    
    init(_ date : Date,_ amount: Float,_ category : CategoryEnum?,_ details : String,_ image : String) {
        self.date = date
        self.amount = amount
        self.category = category
        self.details = details
        self.image = image
    }
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
    
    static func getCategoryImage(for category: CategoryEnum)->UIImage{
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
}
