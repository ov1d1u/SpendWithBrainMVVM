//
//  Validations.swift
//  SpendWithBrain
//
//  Created by Maxim on 19/08/2020.
//  Copyright © 2020 Maxim. All rights reserved.
//

import Foundation
import ValidationComponents


class Validations{
    static func nameValid(name :String) -> Bool{
        let nameVal = NSPredicate(format: "SELF MATCHES %@ ", "^[\\p{L}'][\\p{L}' -]{1,25}$")
        return nameVal.evaluate(with:name)
    }
    
    static func emailValid(email :String) -> Bool{
        let emailPredicate = EmailValidationPredicate()
        return emailPredicate.evaluate(with:email)
    }
    
    static func passValid(pass :String) -> Bool{
        let passwordValidation = NSPredicate(format: "SELF MATCHES %@ ", "^(?=.*[a-z])(?=.*[0-9])(?=.*[A-Z])(?=.*[$@$#!%*?&]).{8,}$")
        return passwordValidation.evaluate(with:pass)
    }
    
    static func amountValid(_ amount :String) ->Bool{
        if let numberFromAmount = Double(amount) {
            return numberFromAmount>0
        }
        return false
    }
    
    static func cnpValid(_ cnp: String) -> Bool {
        func checksum(for partialNumber: String) -> Int? {
            let checkString = "279146358279"
            var sum = 0
            
            for (i, char) in partialNumber.enumerated() {
                guard let digit = Int(String(char)) else { return nil }
                let checkDigit = Int(String(checkString[i]))!
                sum += digit * checkDigit
            }
            
            let checksum = sum % 11
            return checksum == 10 ? 1 : checksum
        }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyMMdd"
        
        let validSexes = ["1", "2"]
        let validCounties = ["01", "02", "03", "04", "05", "06", "07", "08", "09", "10",
                             "11", "12", "13", "14", "15", "16", "17", "18", "19", "20",
                             "21", "22", "23", "24", "25", "26", "27", "28", "29", "30",
                             "31", "32", "33", "34", "35", "36", "37", "38", "39", "40",
                             "41", "42", "43", "44", "45", "46", "51", "52"]
        
        guard cnp.count == 13 else { return false }
        guard cnp.isNumber else { return false }
        
        let sex = String(cnp[0])
        let year = String(cnp[1...2])
        let month = String(cnp[3...4])
        let day = String(cnp[5...6])
        let county = String(cnp[7...8])
        let ordNum = String(cnp[9...11])
        let checkNum = Int(String(cnp[12]))!
        
        if !validSexes.contains(sex) { return false }
        if dateFormatter.date(from: "\(year)\(month)\(day)") == nil { return false }
        if !validCounties.contains(county) { return false }
        if let ordNum = Int(ordNum), ordNum == 0 && ordNum > 999 { return false }
        guard let computedCheckNum = checksum(for: String(cnp[0...11])) else { return false }
        if checkNum != computedCheckNum { return false }
        
        return true
    }
}
