//
//  RegisterViewModel.swift
//  SpendWithBrain
//
//  Created by Maxim on 03/09/2020.
//  Copyright © 2020 Maxim. All rights reserved.
//

import Foundation
import FirebaseDatabase
import Firebase

struct RegisterViewModel {
    
    func isInputsValid(email : String?,password: String?,name: String?) -> (String,String) {
        var errorMessage = ""
        if email != nil && !Validations.emailValid(email: email!){
            errorMessage.append("Please,enter correct email format.\n")
        }
        if name != nil && !Validations.nameValid(name: name!){
            errorMessage.append("Name must contains only letters and spaces.\n")
        }
        if password != nil && !Validations.passValid(pass: password!){
            errorMessage.append("Password must contains minimum 1 small letter,1 uppercase letter,1 digit,1 special caracter,length of password must be bigger(or equal) than 8\n")
        }
        
        if errorMessage.count==0 {
            Auth.auth().createUser(withEmail: email!, password: password!) { authResult, error in
                if authResult != nil {
                    let userID = authResult!.user.uid
                    _ = Database.database().reference().child("users/\(userID)/name").setValue(name)
                }
                if error != nil {
                    errorMessage = error!.localizedDescription
                }
            }
        }
        return ("Error",errorMessage)
    }
    
}
