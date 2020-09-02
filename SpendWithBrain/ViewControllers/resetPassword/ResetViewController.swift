//
//  ResetViewController.swift
//  SpendWithBrain
//
//  Created by Maxim on 19/08/2020.
//  Copyright © 2020 Maxim. All rights reserved.
//

import UIKit

class ResetViewController: UIViewController {

    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var resetBtn: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        customizeViewsInLoginScreen();
    }
    
    private func customizeViewsInLoginScreen(){
        //customize login button
        resetBtn.layer.cornerRadius = 4
    }
    @IBAction func resetBtnClick(_ sender: UIButton) {
        let email = emailField.text!
        if Validations.emailValid(email: email){
            if LocalDataBase.checkIfUserExist(for: email){
                alertErrorShow(email,LocalDataBase.getPasswordForLoginCheck(for: email))
            }else{
                AlertService.showAlert(style: .alert, title: "Error", message: "User with this email does not exist.")
            }
        }else{
            AlertService.showAlert(style: .alert, title: "Error", message: "Wrong email format.\nPlease enter correct email.")
        }
    }
    
    func alertErrorShow(_ email : String, _ pass : String?){
        let alertController = UIAlertController(title: "Reset password", message: "Password for \(email)\n\(pass ?? "Not exist")", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .default, handler: { (action : UIAlertAction!) in
            let storyboard = UIStoryboard(name: "Login", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "Login") as UIViewController
            self.present(vc, animated: true, completion: nil)
        })
        alertController.addAction(okAction)
        self.present(alertController,animated: true,completion: nil)
    }
}
