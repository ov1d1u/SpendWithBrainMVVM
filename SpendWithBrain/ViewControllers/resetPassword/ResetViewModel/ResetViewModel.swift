//
//  ResetViewModel.swift
//  SpendWithBrain
//
//  Created by Maxim on 03/09/2020.
//  Copyright © 2020 Maxim. All rights reserved.
//

import Foundation
import UIKit

struct ResetViewModel{
    var email : String = ""
    
    func isInputsValid() -> (String,String) {
        var title = ""
        var message = ""
        if Validations.emailValid(email: email){
            if LocalDataBase.checkIfUserExist(for: email){
                title = email
                message = LocalDataBase.getPasswordForLoginCheck(for: email)!
            }else{
                title = "Error"
                message = "User with this email doesn't exist."
            }
        }else{
            title = "Error"
            message = "Wrong email format."
        }
        return (title,message)
    }
    
    func alertErrorShow(_ title: String,_ message: String,_ vcFrom : UIViewController){
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .default, handler: { (action : UIAlertAction!) in
            let storyboard = UIStoryboard(name: "Login", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "Login") as UIViewController
            vcFrom.present(vc,animated: true)
        })
        alertController.addAction(okAction)
    }
}
