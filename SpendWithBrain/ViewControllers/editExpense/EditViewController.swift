//
//  EditViewController.swift
//  SpendWithBrain
//
//  Created by Maxim on 27/08/2020.
//  Copyright © 2020 Maxim. All rights reserved.
//

import UIKit
import TextFieldEffects

class EditViewController: UIViewController , setAmountFromConverter {
    var cell : CellViewModel?
    
    @IBOutlet weak var amount: HoshiTextField!
    @IBOutlet var categoryViewArray: [UIView]!
    @IBOutlet weak var dataPicker: UIDatePicker!
    @IBOutlet weak var detailsInput: UITextField!
    private var currentCategory : CategoryEnum?
    @IBOutlet weak var imageView: UIImageView!
    private var imagePath : String?
    private var converterResponse : String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func setAmount(_ amountFromConverter: String) {

        converterResponse = amountFromConverter
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        customizeScreen()
        fillData()
    }
    private func customizeScreen(){
        self.title = "Edit action"
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save",style: .plain,target: self,action: #selector(saveClick))
        dataPicker.maximumDate = Date()
        setupCategoriesViews()
    }
    private func setupCategoriesViews(){
        for item in categoryViewArray {
            item.layer.cornerRadius = 4
            item.layer.borderWidth = 1
            item.layer.borderColor = #colorLiteral(red: 0.1019607843, green: 0.662745098, blue: 0.4470588235, alpha: 1)
            let tapGest = UITapGestureRecognizer(target: self, action: #selector(selectOneCategory(_:)))
            item.addGestureRecognizer(tapGest)
        }
    }
    
    private func fillData() {
        dataPicker.date = (cell?.expense.date)!
        amount.text = converterResponse ?? String(cell!.expense.amount)
        currentCategory = (cell?.category).map { CategoryEnum(rawValue: $0) }!
        selectCurrentCategory()
        detailsInput.text = cell?.expense.details
        imagePath = cell?.expense.image
        imageView.image = Utils.getImage(imageName: (imagePath)!)
    }
    
    @IBAction func converterClick(_ sender: UIButton) {
        let vc = Navigation.presentConverter()
        vc.setData(amount.text ?? "0")
        vc.delegate = self
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func selectPhotoClick(_ sender: UIButton) {
        showImagePickerControllerActionSheet()
    }
    
    @IBAction func savePhotoClick(_ sender: UIButton) {
        print("cu salvarea locala nu am nevoie de tine, thx")
    }
    
    @IBAction func deleteSelectedPhotoClick(_ sender: UIButton) {
        imagePath = "Fara poza"
        imageView.image = #imageLiteral(resourceName: "chitanta")
    }
    
    func selectCurrentCategory(){
        for item in categoryViewArray{
            if let textLabel = item.subviews[1] as? UILabel{
                if textLabel.text! == currentCategory?.rawValue {
                    item.layer.borderColor = #colorLiteral(red: 0.7450980544, green: 0.1568627506, blue: 0.07450980693, alpha: 1)
                }
            }
        }
    }
    
    @objc func selectOneCategory(_ sender:UITapGestureRecognizer){
        let thisView = sender.view
        for item in categoryViewArray{
            if item == thisView {
                item.layer.borderColor = #colorLiteral(red: 0.7450980544, green: 0.1568627506, blue: 0.07450980693, alpha: 1)
                if let label = item.subviews[1] as? UILabel{
                    switch label.text! {
                    case "Income" : currentCategory = .Income
                    case "Food" : currentCategory = .Food
                    case "Car" : currentCategory = .Car
                    case "Clothes" : currentCategory = .Clothes
                    case "Savings" : currentCategory = .Savings
                    case "Health" : currentCategory = .Health
                    case "Beauty" : currentCategory = .Beauty
                    case "Travel" : currentCategory = .Travel
                    default:
                        currentCategory = .Income
                    }
                    print("AddExpense -> User selected \(currentCategory!) for this expense")
                }
            }else{
                item.layer.borderColor = #colorLiteral(red: 0.1019607843, green: 0.662745098, blue: 0.4470588235, alpha: 1)
            }
        }
    }
    
    @objc private func saveClick(){
        if checkInputs() {
            let newExpense = Expense(date:dataPicker.date ,amount:Float(amount.text!)!,category:currentCategory!,details:detailsInput.text!,image:imagePath ?? "Fara poza")
            //LocalDataBase.deleteExpense(cell!.date!)
            var userInfo = LocalDataBase.getUserInfo()
            if userInfo != nil{
                userInfo!.expenses.append(newExpense)
                if LocalDataBase.updateUserInfo(for: userInfo!){
                    print("AddExpense -> Succesfull update info for \(userInfo!.name)")
                    NotificationCenter.default.post(name: Notification.Name(rawValue: "refreshUserData"), object: nil)
                    NotificationCenter.default.post(name: Notification.Name(rawValue: "refreshExpenseScreen"), object: nil)
                    _ = navigationController?.popToRootViewController(animated: true)
                }else{
                    print("AddExpense -> Didnt update info for \(userInfo!.name)")
                }
            }else{
                print("AddExpense -> I dont recieve info about current user , sorry")
            }
            _ = navigationController?.popViewController(animated: true)
        }
    }
    
    private func checkInputs() -> Bool{
        var allowSave = true
        var errorMesage = ""
        if currentCategory == nil {
            allowSave = false
            errorMesage.append("Select one category.\n")
        }
        if !Validations.amountValid(amount.text!){
            allowSave = false
            errorMesage.append("Get amount for this expense.\n")
        }
        if detailsInput.text!.count == 0 {
            allowSave = false
            errorMesage.append("Please, get some details about this expense.\n")
        }
        if errorMesage.count > 0 {
            AlertService.showAlert(style: .alert, title: "Error", message: errorMesage)
        }
        return allowSave
    }
    
}

extension EditViewController : UIImagePickerControllerDelegate , UINavigationControllerDelegate{
    func showImagePickerControllerActionSheet(){
        let photoLibAction = UIAlertAction(title: "Choose from library", style: .default, handler: { (action) in
            self.showImagePickerController(sourceType: .photoLibrary)
        })
        let cameraAction = UIAlertAction(title: "Take from camera", style: .default, handler: { (action) in
            self.showImagePickerController(sourceType: .camera)
        })
        let cancelAction = UIAlertAction(title: "Cancel", style: .default,handler: nil)
        AlertService.showAlert(style: .actionSheet, title: "Choose your image", message: nil,actions: [photoLibAction,cameraAction,cancelAction], completion: nil)
    }
    
    func showImagePickerController(sourceType : UIImagePickerController.SourceType){
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.allowsEditing = true
        imagePickerController.sourceType = sourceType
        present(imagePickerController, animated: true,completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let editedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage{
            print("incarc imaginea din edited")
            imageView.image = editedImage
            imagePath = Utils.saveImageToDocumentDirectory(image : editedImage)
            
        }else if let originalImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage{
            print("incarc imaginea din original")
            imageView.image = originalImage
            imagePath = Utils.saveImageToDocumentDirectory(image : originalImage)
        }
        print(imagePath!)
        dismiss(animated: true)
    }
    
    ///
    
    
}
