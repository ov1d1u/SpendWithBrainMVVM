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
    
    
}
