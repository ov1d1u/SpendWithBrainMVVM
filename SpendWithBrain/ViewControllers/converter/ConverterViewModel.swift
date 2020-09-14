//
//  ConverterViewModel.swift
//  SpendWithBrain
//
//  Created by Maxim on 03/09/2020.
//  Copyright © 2020 Maxim. All rights reserved.
//

import Foundation
import Alamofire

struct ConverterViewModel {
    
    var leftInput : String = ""
    var rightInput : String = ""
    
    var leftSelectedCurrency = Currency.EUR{
        didSet{
            didSetRight(str: rightInput)
        }
    }
    
    var rightSelectedCurrency = Currency.RON{
        didSet{
            didSetLeft(str: leftInput)
        }
    }
    
    var rates : Rates?
    
    var currentRate : Double {
        get{
            if rates != nil {
                return (rates!.getValue(for: rightSelectedCurrency)) / (rates!.getValue(for: leftSelectedCurrency))
            }else{
                return 1
            }
        }
    }
    
    mutating func didSetRight(str :String){
        if str.count>0{
            self.leftInput = String(abs((Double(str)!*currentRate)).rounded(toPlaces: 3))
        }else{
            self.rightInput =  "0"
        }
    }
    
    mutating func didSetLeft(str :String){
        if str.count>0{
            self.rightInput = String(abs((Double(str)!/currentRate)).rounded(toPlaces: 3))
        }else{
            self.rightInput =  "0"
        }
    } 
}

extension Double {
    func rounded(toPlaces places:Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
}
