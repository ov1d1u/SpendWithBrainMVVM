//
//  RegisterViewModel.swift
//  SpendWithBrain
//
//  Created by Maxim on 03/09/2020.
//  Copyright © 2020 Maxim. All rights reserved.
//

import Foundation

struct RegisterViewModel {
    
    func isInputsValid(email : String?,password: String?,name: String?) -> (String,String) {
        var errorMessage = ""
        if email != nil && !Validations.emailValid(email: email!){
            errorMessage.append("Please,enter correct email format.\n")
        }else if UsersEntity.shared.getPassword(forEmail: email!) != nil{
            errorMessage.append("User with this email already exist, try to reset your password.\n")
        }
        if name != nil && !Validations.nameValid(name: name!){
            errorMessage.append("Name must contains only letters and spaces.\n")
        }
        if password != nil && !Validations.passValid(pass: password!){
            errorMessage.append("Password must contains minimum 1 small letter,1 uppercase letter,1 digit,1 special caracter,length of password must be bigger(or equal) than 8\n")
        }
        
        if errorMessage.count==0 {
            _ = UsersEntity.shared.insert(email: email!, password: password!, name: name!)
        }
        return ("Error",errorMessage)
    }
    
}
