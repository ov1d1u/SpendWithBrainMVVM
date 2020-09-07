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
    @IBOutlet weak var imageView: UIImageView!
    
    private var currentCategory : CategoryEnum?
    private var imagePath : String = ""
    
    var addViewModel = AddViewModel()
    
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
        imagePath = "Fara poza"
        imageView.image = #imageLiteral(resourceName: "chitanta")
    }
    
    @objc func selectOneCategory(_ sender:UITapGestureRecognizer){
        let thisView = sender.view
        for item in categoryViewArray{
            if item == thisView {
                item.layer.borderColor = #colorLiteral(red: 0.7450980544, green: 0.1568627506, blue: 0.07450980693, alpha: 1)
                if let label = item.subviews[1] as? UILabel{
                    currentCategory = CategoryEnum(rawValue: label.text!)
                    print("AddExpense -> User selected \(String(describing: currentCategory?.rawValue)) for this expense")
                }
            }else{
                item.layer.borderColor = #colorLiteral(red: 0.1019607843, green: 0.662745098, blue: 0.4470588235, alpha: 1)
            }
        }
    }
    
    @objc private func saveClick(){
        var floatValueOfAmount : Float
        if amountInput.text!.count > 0 {
            floatValueOfAmount = Float(amountInput.text!)!
        }else{
            floatValueOfAmount = -1
        }
        let detailsText = detailsInput.text ?? ""
        let expense = Expense(dataPicker.date, floatValueOfAmount, currentCategory, detailsText, imagePath)
        let message = addViewModel.isExpenseValid(expense: expense)
        if message.count<1 {
            _ = navigationController?.popViewController(animated: true)
        }else{
            AlertService.showAlert(style: .alert, title: "Error", message: message)
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
            imagePath = Utils.saveImageToDocumentDirectory(image: editedImage)
            
        }else if let originalImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage{
            imagePath = Utils.saveImageToDocumentDirectory(image: originalImage)
        }
        imageView.image = Utils.getImage(imageName: imagePath)
        dismiss(animated: true)
    }
}
