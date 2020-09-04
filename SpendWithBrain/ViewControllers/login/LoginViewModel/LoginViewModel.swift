//
//  LoginViewModel.swift
//  SpendWithBrain
//
//  Created by Maxim on 03/09/2020.
//  Copyright © 2020 Maxim. All rights reserved.
//

import Foundation

struct LoginViewModel {
    var email : String = ""
    var password : String = ""
    
    
    func isInputsValid() -> String {
        var errorMessage = ""
        if Validations.emailValid(email: email){
            if let passInBD = LocalDataBase.getPasswordForLoginCheck(for: email){
                if(passInBD == password){
                    LocalDataBase.saveUserToken(for: email)
                }else{
                    errorMessage = "Please enter correct password for this email."
                }
            }else{
                errorMessage = "You get wrong email or user with this email not exist."
            }
        }else{
            errorMessage = "Please enter correct email format."
        }
        return errorMessage
    }
}
