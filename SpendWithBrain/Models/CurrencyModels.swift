//
//  CurrencyModels.swift
//  SpendWithBrain
//
//  Created by Manea Dumitru on 22/08/2020.
//  Copyright © 2020 Maxim. All rights reserved.
//

import XMLMapper
import UIKit

struct DataSet: XMLMappable {
    var nodeName: String!
    var body: Body!
    
    init?(map: XMLMap) {}
    
    mutating func mapping(map: XMLMap) {
        body <- map["Body"]
    }
    
    var rates: [Rate] {
        return body.cube.rates
    }
}

struct Body: XMLMappable {
    var nodeName: String!
    var cube: Cube!
    
    init?(map: XMLMap) {}
    
    mutating func mapping(map: XMLMap) {
        cube <- map["Cube"]
    }
}

struct Cube: XMLMappable {
    var nodeName: String!
    var rates: [Rate]!
    
    init?(map: XMLMap) {}
    
    mutating func mapping(map: XMLMap) {
        rates <- map["Rate"]
    }
}

struct Rate: XMLMappable {
    var nodeName: String!
    var currency: String!
    var value: Double!
    
    init?(map: XMLMap) {}
    
    mutating func mapping(map: XMLMap) {
        currency <- map.attributes["currency"]
        value <- map.innerText
    }
}

enum Currency : String, CaseIterable {
    case RON = "RON"
    case EUR = "EUR"
    case USD = "USD"
    case MDL = "MDL"
    case UAH = "UAH"
    case RUB = "RUB"
    
    func getImg() -> UIImage {
        switch self {
            case .RON: return #imageLiteral(resourceName: "ron_icon")
            case .EUR: return #imageLiteral(resourceName: "euro_icon")
            case .USD: return #imageLiteral(resourceName: "dollar_icon")
            case .MDL: return #imageLiteral(resourceName: "mdl_icon")
            case .UAH: return #imageLiteral(resourceName: "uah_icon")
            case .RUB: return #imageLiteral(resourceName: "rub_icon")
        }
    }
}

extension Array where Element == Rate {
    func getValue(for type : Currency) -> Double {
        if type == .RON {
            return 1
        } else {
            return first(where: { $0.currency == type.rawValue })?.value ?? 0.0
        }
    }
}
