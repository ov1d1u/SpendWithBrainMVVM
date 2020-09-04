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
    var registerViewModel : RegisterViewModel?
    
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
        registerViewModel = RegisterViewModel(name: nameField.text!,email: emailField.text!,password : passField.text!)
        let (errorTitle,errorMessage) = (registerViewModel?.isInputsValid())!
        if errorMessage.count > 0 {
            AlertService.showAlert(style: .alert, title: errorTitle, message: errorMessage)
        }else{
            let storyboard = UIStoryboard(name: "Login", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "Login") as UIViewController
            present(vc, animated: true, completion: nil)
        }
    }
}
