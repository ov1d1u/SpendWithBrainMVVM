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
    private var leftSelectedCurrency = Currency.RON {
        didSet{
            if rates != nil {
                currRate = rates!.getValue(for: leftSelectedCurrency) / rates!.getValue(for: rightSelectedCurrency)
            }
        }
    }
    private var rightSelectedCurrency = Currency.EUR{
        didSet{
            if rates != nil {
                currRate = rates!.getValue(for: leftSelectedCurrency) / rates!.getValue(for: rightSelectedCurrency)
            }
        }
    }
    private var rates : Rates?
    private var currRate : Double = 0
    private let nrOfDigitAfterDot = 3
    override func viewDidLoad() {
        super.viewDidLoad()
        customizeScreen()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if infoFromEdit != nil{
            leftInput.text = infoFromEdit
            rightInput.text = String((Double(infoFromEdit!)!*currRate).rounded(toPlaces: nrOfDigitAfterDot))
        }
        self.navigationItem.hidesBackButton = true
        let newBackButton = UIBarButtonItem(title: "Back", style: UIBarButtonItem.Style.plain, target: self, action: #selector(back(sender:)))
        self.navigationItem.leftBarButtonItem = newBackButton
    }
    
    @objc func back(sender : UIBarButtonItem){
        delegate?.setAmount(rightInput.text ?? "0")
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
                self.lefticon.image = Rates.getImg(for: index)
                self.leftSelectedCurrency = Rates.getType(for: index)
            }
            self.rightFieldDidChange(self.rightInput)
        }
        leftDrop.selectedIndex = 0
        leftDrop.text = "RON"
        lefticon.image = Rates.getImg(for: 0)
        leftInput.addTarget(self, action: #selector(leftFieldDidChange(_:)), for: .editingChanged)
        
        //right drop down setup
        rightDrop.optionArray = Rates.getStrArray()
        rightDrop.listDidDisappear{
            if let index = self.rightDrop.selectedIndex {
                self.rightIcon.image = Rates.getImg(for: index)
                self.rightSelectedCurrency = Rates.getType(for: index)
            }
            self.leftFieldDidChange(self.leftInput)
        }
        rightDrop.selectedIndex = 1
        rightDrop.text = "EUR"
        rightIcon.image = Rates.getImg(for: 1)
        rightInput.addTarget(self, action: #selector(rightFieldDidChange(_:)), for: .editingChanged)
        
        
        //set top text
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let dateString = dateFormatter.string(from: Date())
        topLabel.text = "Converted using BNR at date \(dateString)"
        
    }
    
    @objc func leftFieldDidChange(_ textField: UITextField) {
        if let leftText = textField.text, var leftValue = Double(leftText) {
            if leftValue < 0 {
                leftValue = -leftValue
            }
            if currRate > 0{
                rightInput.text = String((leftValue*currRate).rounded(toPlaces: nrOfDigitAfterDot))
            }
        }else{
            rightInput.placeholder = "0"
        }
    }
    
    @objc func rightFieldDidChange(_ textField: UITextField) {
        if let rightText = textField.text, var rightValue = Double(rightText) {
            if rightValue < 0 {
                rightValue = -rightValue
            }
            if currRate > 0{
                leftInput.text = String((rightValue/currRate).rounded(toPlaces: nrOfDigitAfterDot))
            }
            }else{
            leftInput.placeholder = "0"
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
                    self.rates = result.rates
                    self.currRate = self.rates!.RON / self.rates!.EUR
                }}else {
                self.alertErrorShow()
            }
        }
    }
    
    func alertErrorShow(){
        let alertController = UIAlertController(title: "Error", message: "BRN didn't send necessary information.", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .default, handler: { (action : UIAlertAction!) in
            //_ = self.navigationController?.popToRootViewController(animated: true)
        })
        alertController.addAction(okAction)
        self.present(alertController,animated: true,completion: nil)
    }
}
extension Double {
    func rounded(toPlaces places:Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
}

