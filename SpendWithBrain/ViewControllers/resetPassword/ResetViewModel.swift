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
    
    func isInputsValid(email : String?) -> (String,String) {
        var title = ""
        var message = ""
        if email != nil, Validations.emailValid(email: email!){
            if UsersEntity.shared.chechIfUserExist(for: email!){
                title = email!
            }else{
                title = "Error"
            }
            if let pass = UsersEntity.shared.getPassword(forEmail: email!){
                message = String(pass)
            }else{
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
