//
//  AddExpenseViewController.swift
//  SpendWithBrain
//
//  Created by Maxim on 21/08/2020.
//  Copyright © 2020 Maxim. All rights reserved.
//

import UIKit
import TextFieldEffects
class AddExpenseViewController: UIViewController{

    @IBOutlet var categoryViewArray: [UIView]!
    @IBOutlet weak var dataPicker: UIDatePicker!
    @IBOutlet weak var amountInput: HoshiTextField!
    @IBOutlet weak var detailsInput: UITextField!
    private var currentCategory : CategoryEnum?
    @IBOutlet weak var imageView: UIImageView!
    private var imagePath : String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        customizeScreen()
    }
    
    
    private func customizeScreen(){
        self.title = "Add action"
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save",style: .plain,target: self,action: #selector(saveClick))
        dataPicker.maximumDate = Date()
        imageView.image = #imageLiteral(resourceName: "chitanta")
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
    
    @IBAction func addImageClick(_ sender: UIButton) {
        showImagePickerControllerActionSheet()
    }
    
    @IBAction func removeImage(_ sender: UIButton) {
        imagePath = nil
        imageView.image = #imageLiteral(resourceName: "chitanta")
    }
    
    private func checkAllInputs()-> Bool{
        var allowSave = true
        var errorMesage = ""
        if currentCategory == nil {
            allowSave = false
            errorMesage.append("Select one category.\n")
        }
        if !Validations.amountValid(amountInput.text!){
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
        if checkAllInputs(){
            let newExpense = Expense(date:dataPicker.date ,amount:Float(amountInput.text!)!,category:currentCategory!,details:detailsInput.text!,image:imagePath ?? "Fara poza")
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
            
        }else{
            print("AddExpense -> Please get amount , details and select category for expense")
        }
    }

}


extension AddExpenseViewController : UIImagePickerControllerDelegate , UINavigationControllerDelegate{
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
            imageView.image = editedImage
            imagePath = Utils.saveImageToDocumentDirectory(image : editedImage)
            
        }else if let originalImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage{
            imageView.image = originalImage
            imagePath = Utils.saveImageToDocumentDirectory(image : originalImage)
        }
        print(imagePath!)
        dismiss(animated: true)
    }
}
