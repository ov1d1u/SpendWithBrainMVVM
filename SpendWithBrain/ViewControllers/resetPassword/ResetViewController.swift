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
    var resetViewModel : ResetViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        customizeViewsInLoginScreen();
    }
    
    private func customizeViewsInLoginScreen(){
        resetBtn.layer.cornerRadius = 4
    }
    @IBAction func resetBtnClick(_ sender: UIButton) {
        resetViewModel = ResetViewModel(email :emailField.text!)
        let (title,message) = (resetViewModel?.isInputsValid())!
        AlertService.showAlert(style: .alert, title: title, message: message)
    }
    
    
}
