//
//  LoginViewModel.swift
//  SpendWithBrain
//
//  Created by Maxim on 03/09/2020.
//  Copyright © 2020 Maxim. All rights reserved.
//

import Foundation
import Firebase

class LoginViewModel {
    var delegate : LoginNavProtocol?
    
    func isInputsValid(email: String?,password: String?) -> String {
        var errorMessage = ""
        if email != nil && Validations.emailValid(email: email!){
            //signin
            if password != nil && (password?.count)!>0 {
                Auth.auth().signIn(withEmail: email!, password: password!) { authResult, error in
                    if authResult != nil{
                        let id = authResult!.user.uid
                        Database.database().reference().child("users/\(id)/name").observe(.value) { (snapShot) in
                            let name = snapShot.value as! String
                            LocalDataBase.saveName(name)
                        }
                        self.delegate?.redirectToHome()
                    }else{
                        self.delegate?.showError("User with this email not exist or you get wrong password.")
                    }
                }
            }else{
                errorMessage = "Please enter password."
            }
        }else{
            errorMessage = "Please enter correct email format."
        }
        return errorMessage
    }
}

protocol LoginNavProtocol {
    func redirectToHome()
    func showError(_ errorMessage :String)
}
