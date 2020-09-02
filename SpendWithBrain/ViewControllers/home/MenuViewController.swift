//
//  MenuViewController.swift
//  SpendWithBrain
//
//  Created by Maxim on 20/08/2020.
//  Copyright © 2020 Maxim. All rights reserved.
//

import UIKit

class MenuViewController: UIViewController {
    
    @IBOutlet weak var mainBtn: UIButton!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var converterBtn: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        userName.text = "Hello "+LocalDataBase.getUserInfo()!.name
        converterBtn.layer.borderWidth = 1
        converterBtn.layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        mainBtn.layer.borderWidth = 1
        mainBtn.layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        
    }
    
    @IBAction func converterClick(_ sender: UIButton) {
        print("SideMenu ->Go to Converter screen")
        //let converter = Navigation.presentConverter()
        //self.navigationController?.pushViewController(converter, animated: true)
        NotificationCenter.default.post(name: Notification.Name(rawValue: "converterOpen"), object: nil)
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func logoutClick(_ sender: UIButton) {
        print("SideMenu ->Logout and go to Login Screen")
        LocalDataBase.removeUserToken()
        let vc = UIStoryboard(name: "Login", bundle: nil).instantiateViewController(withIdentifier: "Login") as UIViewController
        self.present(vc, animated: true, completion: nil)
    }
    
    @IBAction func main(_ sender: UIButton) {
       print("SideMenu ->Back to main screen")
        dismiss(animated: true, completion: nil)
    }
}
