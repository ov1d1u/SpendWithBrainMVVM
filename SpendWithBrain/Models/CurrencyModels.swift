//
//  CurrencyModels.swift
//  SpendWithBrain
//
//  Created by Manea Dumitru on 22/08/2020.
//  Copyright © 2020 Maxim. All rights reserved.
//

import Foundation
import UIKit

struct Result : Decodable {
    var base : String
    var date : String
    var rates : Rates
}
struct Rates : Decodable {
    let EUR : Double
    let USD : Double
    let RUB : Double
    let UAH : Double
    let MDL : Double
    let RON = 1.0
    static func getStrArray() -> [String]{
        return ["RON","EUR","USD","MDL","UAH","RUB"]
    }
    
    
    
    static func getImg(for curr : Int) -> UIImage {
        let array = getStrArray()
        switch array[curr] {
        case "RON": return #imageLiteral(resourceName: "ron_icon")
        case "EUR": return #imageLiteral(resourceName: "euro_icon")
        case "USD": return #imageLiteral(resourceName: "dollar_icon")
        case "MDL": return #imageLiteral(resourceName: "mdl_icon")
        case "UAH": return #imageLiteral(resourceName: "uah_icon")
        case "RUB": return #imageLiteral(resourceName: "rub_icon")
        default:  return #imageLiteral(resourceName: "exchange_icon")
        }
    }
    
    static func getType(for curr : Int) -> Currency{
        let array = getStrArray()
        switch array[curr] {
        case "RON": return .RON
        case "EUR": return .EUR
        case "USD": return .USD
        case "MDL": return .MDL
        case "UAH": return .UAH
        case "RUB": return .RUB
        default:  return .RON
    }
    }
    
    func getValue(for type : Currency) -> Double{
        switch type {
        case .RON: return 1
        case .EUR: return EUR
        case .MDL: return MDL
        case .UAH: return UAH
        case .RUB: return RUB
        case .USD: return USD
        }
    }
}

enum Currency : Int {
    case RON = 0
    case EUR = 1
    case USD = 2
    case MDL = 3
    case UAH = 4
    case RUB = 5
    
    static func getName(_ nr : Int) -> String {
        switch nr {
        case 0: return "RON"
        case 1: return "EUR"
        case 2: return "USD"
        case 3: return "MDL"
        case 4: return "UAH"
        case 5: return "RUB"
        default:
            return ""
        }
    }
}
