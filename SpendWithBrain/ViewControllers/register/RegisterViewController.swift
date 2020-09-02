//
//  RegisterViewController.swift
//  SpendWithBrain
//
//  Created by Maxim on 19/08/2020.
//  Copyright © 2020 Maxim. All rights reserved.
//

import UIKit

class RegisterViewController: UIViewController {

    @IBOutlet weak var registerBtn: UIButton!
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        customizeViewsInLoginScreen();
    }
    
    private func customizeViewsInLoginScreen(){
        //customize login button
        registerBtn.layer.cornerRadius = 4
        //password input
        passField.isSecureTextEntry = true
        let showBtn = UIButton(type: .custom)
        showBtn.setImage(#imageLiteral(resourceName: "show_password"), for: .normal)
        showBtn.imageEdgeInsets = UIEdgeInsets(top: 0, left: -16, bottom: 0, right: 0)
        showBtn.frame = CGRect(x: CGFloat(passField.frame.size.width - 25), y: CGFloat(5), width: CGFloat(25), height: CGFloat(25))
        showBtn.addTarget(self, action: #selector(self.toggleViewPass), for: .touchUpInside)
        passField.rightView = showBtn
        passField.rightViewMode = .always
    }
    
    @objc private func toggleViewPass(){
        passField.isSecureTextEntry = !passField.isSecureTextEntry
    }

    @IBAction func registerUser(_ sender: UIButton) {
        if checkInptus() {
            let newUser = User(password: passField.text!, name: nameField.text!)
            let email = emailField.text!
            if(LocalDataBase.createUser(for: email, userData: newUser)){
                let storyboard = UIStoryboard(name: "Login", bundle: nil)
                let vc = storyboard.instantiateViewController(withIdentifier: "Login") as UIViewController
                present(vc, animated: true, completion: nil)
            }else{
                print("register error")
            }
            
        }else{
            print("invalid data")
        }
    }
    
    private func checkInptus() -> Bool{
        var ok = true
        var errorMessage = ""
        if !Validations.nameValid(name: nameField.text!){
            ok = false
            errorMessage.append("Name can only contains letters.\n")
        }
        if !Validations.emailValid(email: emailField.text!){
            ok = false
            errorMessage.append("Get correct email.\n")
        }
        if !Validations.passValid(pass: passField.text!){
            ok = false
            errorMessage.append("The password must contain a small letter, a capital letter, a digit and a special sign(Contain more than 8 character)")
        }
        if errorMessage.count>0{
            AlertService.showAlert(style: .alert, title: "Error", message: errorMessage)
        }
        return ok
    }
}
