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
    var resetViewModel = ResetViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        customizeViewsInLoginScreen();
    }
    
    private func customizeViewsInLoginScreen(){
        resetBtn.layer.cornerRadius = 4
    }
    @IBAction func resetBtnClick(_ sender: UIButton) {
        let (title,message) = resetViewModel.isInputsValid(email: emailField.text)
        showAlert(title,message)
    }
    
    func showAlert(_ title: String,_ message : String){
        let okAction = UIAlertAction(title: "OK", style: .default,handler: { (action) in
            let storyboard = UIStoryboard(name: "Login", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "Login") as UIViewController
            self.present(vc, animated: true, completion: nil)
        })
        AlertService.showAlert(style: .actionSheet, title: title, message: message,actions: [okAction], completion: nil)
    }
}
