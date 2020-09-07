//
//  LoginViewModel.swift
//  SpendWithBrain
//
//  Created by Maxim on 03/09/2020.
//  Copyright © 2020 Maxim. All rights reserved.
//

import Foundation

struct LoginViewModel {
    
    func isInputsValid(email: String?,password: String?) -> String {
        var errorMessage = ""
        if email != nil && Validations.emailValid(email: email!){
            if password != nil, let passInBD = UsersEntity.shared.getPassword(forEmail: email!){
                if(passInBD == password){
                    LocalDataBase.saveUserToken(for: email!,with: password!)
                }else{
                    errorMessage = "Please enter correct password for this email."
                }
            }else{
                errorMessage = "You get wrong email or user with this email not exist."
            }
        }else{
            errorMessage = "Please enter correct email format."
        }
        if errorMessage.count == 0{
            LocalDataBase.saveUserToken(for: email!, with: password!)
        }
        return errorMessage
    }
}
