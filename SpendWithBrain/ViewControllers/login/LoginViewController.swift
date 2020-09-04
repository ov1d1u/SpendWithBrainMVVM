//
//  ViewController.swift
//  SpendWithBrain
//
//  Created by Maxim on 18/08/2020.
//  Copyright © 2020 Maxim. All rights reserved.
//

import UIKit
import TextFieldEffects

class LoginViewController: UIViewController {
    @IBOutlet weak var loginBtn: UIButton!
    @IBOutlet weak var emailField: HoshiTextField!
    @IBOutlet weak var passField: HoshiTextField!
    
    var loginViewModel : LoginViewModel?
    override func viewDidLoad() {
        super.viewDidLoad()
        customizeViewsInLoginScreen()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        checkAutologin()
    }
    
    
    private func customizeViewsInLoginScreen(){
        //customize login button
        loginBtn.layer.cornerRadius = 4
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
    
    private func checkAutologin(){
        if LocalDataBase.checkToken(){
            redirectToHome()
        }
    }
    @IBAction func loginBtn(_ sender: UIButton) {
        loginViewModel = LoginViewModel(email : emailField.text!,password: passField.text!)
        let errorMessage = loginViewModel!.isInputsValid()
        if errorMessage.count > 0 {
            AlertService.showAlert(style: .alert, title: "Error", message: errorMessage)
        }else{
            redirectToHome()
        }
    }
    
    private func redirectToHome(){
        let storyboard = UIStoryboard(name: "Home", bundle: nil)
        if let vc = storyboard.instantiateInitialViewController(){
            present(vc, animated: true, completion: nil)
        }
    }
}

