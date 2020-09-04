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
    
    var converterViewModel : ConverterViewModel!{
        didSet{
            leftDrop.text = Currency.getName(converterViewModel.leftSelectedCurrency.rawValue)
            rightDrop.text = Currency.getName(converterViewModel.rightSelectedCurrency.rawValue)
            lefticon.image = Rates.getImg(for: converterViewModel.leftSelectedCurrency.rawValue)
            rightIcon.image = Rates.getImg(for: converterViewModel.rightSelectedCurrency.rawValue)
            leftInput.text = converterViewModel.leftInput
            rightInput.text = converterViewModel.rightInput
        }
    }
    weak var delegate : setAmountFromConverter?
    
    var infoFromEdit : String?
    override func viewDidLoad() {
        super.viewDidLoad()
        customizeScreen()
        converterViewModel = ConverterViewModel()
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
    
    private func customizeScreen(){
        requestToBNR()
        self.title = "Converter"
        //left drop down setup
        leftDrop.optionArray = Rates.getStrArray()
        leftDrop.listDidDisappear{
            if let index = self.leftDrop.selectedIndex {
                self.converterViewModel.leftSelectedCurrency = Rates.getType(for: index)
            }
        }
        leftInput.addTarget(self, action: #selector(leftFieldDidChange(_:)), for: .editingChanged)
        
        //right drop down setup
        rightDrop.optionArray = Rates.getStrArray()
        rightDrop.listDidDisappear{
            if let index = self.rightDrop.selectedIndex {
                self.converterViewModel.rightSelectedCurrency = Rates.getType(for: index)
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
        }
    }
    
    @objc func rightFieldDidChange(_ textField: UITextField) {
        if ((textField.text?.count)!>0){
            converterViewModel.rightInput = textField.text!
            converterViewModel.didSetRight(str: textField.text!)
        }
        
    }
    
    @IBAction func rightDropShow(_ sender: Any) {
        rightDrop.showList()
    }
    @IBAction func rightDropHide(_ sender: Any) {
        rightDrop.hideList()
    }
    
    @IBAction func showDrop(_ sender: Any) {
        leftDrop.showList()
    }
    @IBAction func hideDrop(_ sender: Any) {
        leftDrop.hideList()
    }
    
    private func requestToBNR(){
        Alamofire.request("https://romanian-exchange-rate-bnr-api.herokuapp.com/api/latest", method: .get, parameters: ["access_key":"f7dbe1842278-43779b"]).responseJSON{ (response)-> Void in
            if response.result.value != nil {
                if let data = response.data{
                    let result = try! JSONDecoder().decode(Result.self, from: data)
                    self.converterViewModel.rates = result.rates
                }}else {
                self.alertErrorShow()
            }
        }
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


