//
//  ResetViewModel.swift
//  SpendWithBrain
//
//  Created by Maxim on 03/09/2020.
//  Copyright © 2020 Maxim. All rights reserved.
//

import Foundation
import Firebase

struct ResetViewModel{
    
    func isInputsValid(email : String?) -> (String,String) {
        var title = "Error"
        var message = ""
        if email != nil, Validations.emailValid(email: email!){
            Auth.auth().sendPasswordReset(withEmail: email!) {(error) in
                if error != nil {
                    message = error!.localizedDescription
                }else{
                    title = "Reset password"
                    message = "Check you e-mail inbox."
                }
            }
        }else{
            message = "Wrong email format."
        }
        return (title,message)
    }
}
