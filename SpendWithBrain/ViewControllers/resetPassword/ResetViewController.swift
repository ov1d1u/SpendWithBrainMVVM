//
//  ResetViewController.swift
//  SpendWithBrain
//
//  Created by Maxim on 19/08/2020.
//  Copyright © 2020 Maxim. All rights reserved.
//

import UIKit

class ResetViewController: UIViewController, ShowResetAlert{

    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var resetBtn: UIButton!
    var resetViewModel = ResetViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        customizeViewsInLoginScreen();
        resetViewModel.delegate = self
    }
    
    private func customizeViewsInLoginScreen(){
        resetBtn.layer.cornerRadius = 4
    }
    
    @IBAction func resetBtnClick(_ sender: UIButton) {
        resetViewModel.isInputsValid(email: emailField.text)
    }
    
    func alert(_ title: String,_ message : String) {
        let okAction = UIAlertAction(title: "OK", style: .default,handler: { (action) in
            let storyboard = UIStoryboard(name: "Login", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "Login") as UIViewController
            self.present(vc, animated: true, completion: nil)
        })
        AlertService.showAlert(style: .actionSheet, title: title, message: message,actions: [okAction], completion: nil)
    }
}
