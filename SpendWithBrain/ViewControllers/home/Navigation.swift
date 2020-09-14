//
//  Navigation.swift
//  SpendWithBrain
//
//  Created by Maxim on 21/08/2020.
//  Copyright © 2020 Maxim. All rights reserved.
//

import UIKit

class Navigation: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(goToConverter(_:)), name: Notification.Name(rawValue: "converterOpen"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(goToEdit(_:)), name: Notification.Name(rawValue: "editOpen"), object: nil)
    }
    
    @IBAction func clickOnMenuBurger(_ sender: UIBarButtonItem) {
        NotificationCenter.default.post(name: Notification.Name(rawValue: "openSideMenu"), object: nil)
    }
    
    @IBAction func clickOnAddBtn(_ sender: UIBarButtonItem) {
        let vc = UIStoryboard(name: "AddExpense", bundle: nil).instantiateViewController(withIdentifier: "AddExpense") as UIViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
 
    @objc func goToConverter(_ notification: Notification) {
        let vc = UIStoryboard(name: "Converter", bundle: nil).instantiateViewController(withIdentifier: "Converter") as UIViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func goToEdit(_ notification: Notification) {
        if let exp = notification.userInfo!["expense"] as? Expense{
            let vc = UIStoryboard(name: "Edit", bundle: nil).instantiateViewController(withIdentifier: "edit") as! EditViewController
            vc.expenseRecieve = exp
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    class func presentConverter() -> ConverterViewController {
        let vc = UIStoryboard(name: "Converter", bundle: nil).instantiateViewController(withIdentifier: "Converter") as! ConverterViewController
        return vc
    }
}
