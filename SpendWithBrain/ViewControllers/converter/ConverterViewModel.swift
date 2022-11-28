//
//  ConverterViewModel.swift
//  SpendWithBrain
//
//  Created by Maxim on 03/09/2020.
//  Copyright © 2020 Maxim. All rights reserved.
//

import Foundation
import Alamofire

class ConverterViewModel {
    let currencyConverter: CurrencyConverter!
    
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
    
    var rates : [Rate]?
    
    var currentRate : Double {
        get{
            if rates != nil {
                return (rates!.getValue(for: rightSelectedCurrency)) / (rates!.getValue(for: leftSelectedCurrency))
            }else{
                return 1
            }
        }
    }
    
    init(currencyConverter: CurrencyConverter!) {
        self.currencyConverter = currencyConverter
    }
    
    func getRates(_ completion: @escaping ((DataSet?) -> Void)) {
        currencyConverter.getRates { dataSet in
            if let dataSet = dataSet {
                self.rates = dataSet.rates
            }
            DispatchQueue.main.async {
                completion(dataSet)
            }
        }
    }
    
    func didSetRight(str :String){
        if str.count>0{
            self.leftInput = String(abs((Double(str)!*currentRate)).rounded(toPlaces: 3))
        }else{
            self.rightInput =  "0"
        }
    }
    
    func didSetLeft(str :String){
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
