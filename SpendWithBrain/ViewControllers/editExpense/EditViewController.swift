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
    var cellRecieve : CellViewModel?
    var cell : CellViewModel!{
        didSet{
            dataPicker.date = (cell?.expense.date)!
            amount.text = String(cell!.expense.amount)
            currentCategory = cell.expense.category
            selectCurrentCategory()
            detailsInput.text = cell?.expense.details
            imageView.image = Utils.getImage(imageName: (cell.expense.image))
        }
    }
    
    @IBOutlet weak var amount: HoshiTextField!
    @IBOutlet var categoryViewArray: [UIView]!
    @IBOutlet weak var dataPicker: UIDatePicker!
    @IBOutlet weak var detailsInput: UITextField!
    private var currentCategory : CategoryEnum?
    @IBOutlet weak var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        cell = cellRecieve!
    }
    
    func setAmount(_ amountFromConverter: String) {
        cell.expense.amount = Float(amountFromConverter)!
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        customizeScreen()
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
        cell.expense.image = "Fara poza"
    }
    
    func selectCurrentCategory(){
        for item in categoryViewArray{
            if let textLabel = item.subviews[1] as? UILabel{
                if textLabel.text! == cell.expense.category!.rawValue {
                    item.layer.borderColor = #colorLiteral(red: 0.7450980544, green: 0.1568627506, blue: 0.07450980693, alpha: 1)
                }
            }
        }
    }
    @IBAction func amountChange(_ sender: HoshiTextField) {
        if((sender.text?.count)!>0){
            cell.expense.amount = Float(sender.text!)!
        }
    }
    
    @IBAction func dateChanged(_ sender: UIDatePicker) {
        cell.expense.date = dataPicker.date
    }
    
    @IBAction func detailsChanged(_ sender: UITextField) {
        cell.expense.details = sender.text!
    }
    @objc func selectOneCategory(_ sender:UITapGestureRecognizer){
        let thisView = sender.view
        for item in categoryViewArray{
            if item == thisView {
                item.layer.borderColor = #colorLiteral(red: 0.7450980544, green: 0.1568627506, blue: 0.07450980693, alpha: 1)
                if let label = item.subviews[1] as? UILabel{
                    cell.expense.category = CategoryEnum(rawValue: label.text!)!
                    print("AddExpense -> User selected \(currentCategory!) for this expense")
                }
            }else{
                item.layer.borderColor = #colorLiteral(red: 0.1019607843, green: 0.662745098, blue: 0.4470588235, alpha: 1)
            }
        }
    }
    
    @objc private func saveClick(){
        let (errorTitle,errorMessage) = cell.isExpenseValid()
        if errorMessage.count<1 {
            cell.saveEditedExpense((cellRecieve?.expense.date)!)
            _ = navigationController?.popViewController(animated: true)
        }else{
            AlertService.showAlert(style: .alert, title: errorTitle, message: errorMessage)
        }
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
            cell.expense.image = Utils.saveImageToDocumentDirectory(image : editedImage)
        }else if let originalImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage{
            cell.expense.image = Utils.saveImageToDocumentDirectory(image : originalImage)
        }
        dismiss(animated: true)
    }
}
