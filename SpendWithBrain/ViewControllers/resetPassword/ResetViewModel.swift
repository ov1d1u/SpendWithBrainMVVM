//
//  ResetViewModel.swift
//  SpendWithBrain
//
//  Created by Maxim on 03/09/2020.
//  Copyright © 2020 Maxim. All rights reserved.
//

import Foundation
import Firebase
protocol ShowResetAlert{
    func alert(_ title: String,_ message : String)
}
struct ResetViewModel{
    var delegate : ShowResetAlert?
    
    func isInputsValid(email : String?)  {
        if email != nil, Validations.emailValid(email: email!){
            Auth.auth().sendPasswordReset(withEmail: email!) {(error) in
                if error != nil {
                    //delegate show error
                    self.delegate?.alert("Error", error!.localizedDescription)
                }else{
                    //delegate show info
                    self.delegate?.alert("Reset password", "Check your inbox")
                }
            }
        }else{
            self.delegate?.alert("Error", "Wrong email format.")
        }
    }
}
