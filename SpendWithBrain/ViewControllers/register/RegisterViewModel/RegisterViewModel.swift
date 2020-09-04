//
//  RegisterViewModel.swift
//  SpendWithBrain
//
//  Created by Maxim on 03/09/2020.
//  Copyright © 2020 Maxim. All rights reserved.
//

import Foundation

struct RegisterViewModel {
    var name : String = ""
    var email : String = ""
    var password : String = ""
    
    func isInputsValid() -> (String,String) {
        var errorMessage = ""
        if !Validations.emailValid(email: email){
            errorMessage.append("Please,enter correct email format.\n")
        }else if LocalDataBase.isEmailAlreadyExist(for: email){
            errorMessage.append("User with this email already exist, try to reset your password.\n")
        }
        if !Validations.nameValid(name: name){
            errorMessage.append("Name must contains only letters and spaces.\n")
        }
        if !Validations.passValid(pass: password){
            errorMessage.append("Password must contains minimum 1 small letter,1 uppercase letter,1 digit,1 special caracter,length of password must be bigger(or equal) than 8\n")
        }
        return ("Error",errorMessage)
    }
}
