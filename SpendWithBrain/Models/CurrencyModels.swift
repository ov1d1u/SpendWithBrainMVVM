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

enum Currency {
    case RON
    case EUR
    case USD
    case RUB
    case UAH
    case MDL
}
