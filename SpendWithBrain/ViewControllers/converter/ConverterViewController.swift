//
//  ConverterViewController.swift
//  SpendWithBrain
//
//  Created by Maxim on 21/08/2020.
//  Copyright © 2020 Maxim. All rights reserved.
//

import UIKit
import iOSDropDown
import Alamofire

class ConverterViewController: UIViewController {
    
    @IBOutlet weak var rightIcon: UIImageView!
    @IBOutlet weak var lefticon: UIImageView!
    @IBOutlet weak var leftDrop: DropDown!
    @IBOutlet weak var rightDrop: DropDown!
    @IBOutlet weak var leftInput: UITextField!
    @IBOutlet weak var rightInput: UITextField!
    @IBOutlet weak var topLabel: UILabel!
    
    weak var delegate : setAmountFromConverter?
    var infoFromEdit : String?
    var converterViewModel : ConverterViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        customizeScreen()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if infoFromEdit != nil{
            converterViewModel.leftInput = infoFromEdit!
            leftFieldDidChange(leftInput)
        }
        self.navigationItem.hidesBackButton = true
        let newBackButton = UIBarButtonItem(title: "Back", style: UIBarButtonItem.Style.plain, target: self, action: #selector(back(sender:)))
        self.navigationItem.leftBarButtonItem = newBackButton
    }
    
    @objc func back(sender : UIBarButtonItem){
        delegate?.setAmount(converterViewModel.rightInput)
        _ = navigationController?.popViewController(animated: true)
    }
    
    func setData(_ amountTxt : String){
        infoFromEdit = amountTxt
    }
    
    private func updateUI() {
        self.leftDrop.text = self.converterViewModel.leftSelectedCurrency.rawValue
        self.rightDrop.text = self.converterViewModel.rightSelectedCurrency.rawValue
        self.lefticon.image = self.converterViewModel.leftSelectedCurrency.getImg()
        self.rightIcon.image = self.converterViewModel.rightSelectedCurrency.getImg()
        self.leftInput.text = self.converterViewModel.leftInput
        self.rightInput.text = self.converterViewModel.rightInput
    }
    
    private func customizeScreen() {
        converterViewModel.getRates { dataSet in
            if dataSet == nil {
                self.alertErrorShow()
            }
            
            self.updateUI()
        }
        self.title = "Converter"
        
        //left drop down setup
        leftDrop.optionArray = Currency.allCases.map { $0.rawValue }
        leftDrop.listDidDisappear{
            if let index = self.leftDrop.selectedIndex {
                self.converterViewModel.leftSelectedCurrency = Currency(rawValue: self.leftDrop.optionArray[index]) ?? .RON
            }
        }
        leftInput.addTarget(self, action: #selector(leftFieldDidChange(_:)), for: .editingChanged)
        
        //right drop down setup
        rightDrop.optionArray = Currency.allCases.map { $0.rawValue }
        rightDrop.listDidDisappear{
            if let index = self.rightDrop.selectedIndex {
                self.converterViewModel.rightSelectedCurrency = Currency(rawValue: self.rightDrop.optionArray[index]) ?? .RON
            }
        }
        rightInput.addTarget(self, action: #selector(rightFieldDidChange(_:)), for: .editingChanged)
        
        
        //set top text
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let dateString = dateFormatter.string(from: Date())
        topLabel.text = "Converted using BNR at date \(dateString)"
        
    }
    
    @objc func leftFieldDidChange(_ textField: UITextField) {
        if ((textField.text?.count)!>0){
            converterViewModel.leftInput = textField.text!
            converterViewModel.didSetLeft(str: textField.text!)
            updateUI()
        }
    }
    
    @objc func rightFieldDidChange(_ textField: UITextField) {
        if ((textField.text?.count)!>0){
            converterViewModel.rightInput = textField.text!
            converterViewModel.didSetRight(str: textField.text!)
            updateUI()
        }
        
    }
    
    @IBAction func rightDropShow(_ sender: Any) {
        rightDrop.showList()
    }
    @IBAction func rightDropHide(_ sender: Any) {
        rightDrop.hideList()
        updateUI()
    }
    
    @IBAction func showDrop(_ sender: Any) {
        leftDrop.showList()
    }
    @IBAction func hideDrop(_ sender: Any) {
        leftDrop.hideList()
        updateUI()
    }
    
    func alertErrorShow(){
        let alertController = UIAlertController(title: "Error", message: "BRN didn't send necessary information.", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .default, handler: { (action : UIAlertAction!) in
            _ = self.navigationController?.popToRootViewController(animated: true)
        })
        alertController.addAction(okAction)
        self.present(alertController,animated: true,completion: nil)
    }
}


