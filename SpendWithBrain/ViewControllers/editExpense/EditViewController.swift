//
//  EditViewController.swift
//  SpendWithBrain
//
//  Created by Maxim on 27/08/2020.
//  Copyright © 2020 Maxim. All rights reserved.
//

import UIKit
import TextFieldEffects
import Firebase

class EditViewController: UIViewController , setAmountFromConverter {
    var expenseRecieve : Expense?
    
    @IBOutlet weak var amount: HoshiTextField!
    @IBOutlet var categoryViewArray: [UIView]!
    @IBOutlet weak var dataPicker: UIDatePicker!
    @IBOutlet weak var detailsInput: UITextField!
    @IBOutlet weak var imageView: UIImageView!
    
    private var currentCategory : CategoryEnum?
    var editViewModel = EditViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadInitialImage()
    }
    
    private func loadInitialImage(){
        let uid = Auth.auth().currentUser!.uid
        let islandRef = Storage.storage().reference().child("\(uid)/\(expenseRecieve!.image)")
        islandRef.getData(maxSize: 1 * 2000 * 2000) { data, error in
            if error != nil {
                self.imageView.image = #imageLiteral(resourceName: "chitanta")
            } else {
                self.imageView.image = UIImage(data: data!)
            }
        }
    }
    
    
    func setAmount(_ amountFromConverter: String) {
        expenseRecieve!.amount = Float(amountFromConverter)!
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
        dataPicker.date = expenseRecieve!.date
        amount.text = String(expenseRecieve!.amount)
        currentCategory = expenseRecieve!.category
        selectCurrentCategory()
        detailsInput.text = expenseRecieve!.details
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
        guard let image = imageView.image else { return }
        
        UIImageWriteToSavedPhotosAlbum(image, self, #selector(image(_:didFinishSavingWithError:contextInfo:)), nil)
    }
    
    @objc func image(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        if let error = error {
            // we got back an error!
            let ac = UIAlertController(title: "Save error", message: error.localizedDescription, preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            present(ac, animated: true)
        } else {
            let ac = UIAlertController(title: "Saved!", message: "Your altered image has been saved to your photos.", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            present(ac, animated: true)
        }
    }

    
    @IBAction func deleteSelectedPhotoClick(_ sender: UIButton) {
       imageView.image = #imageLiteral(resourceName: "chitanta")
    }
    
    func selectCurrentCategory(){
        for item in categoryViewArray{
            if let textLabel = item.subviews[1] as? UILabel{
                if textLabel.text! == expenseRecieve!.category!.rawValue {
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
                    expenseRecieve!.category = CategoryEnum(rawValue: label.text!)!
                    print("AddExpense -> User selected \(currentCategory!) for this expense")
                }
            }else{
                item.layer.borderColor = #colorLiteral(red: 0.1019607843, green: 0.662745098, blue: 0.4470588235, alpha: 1)
            }
        }
    }
    
    @objc private func saveClick(){
        if amount.text!.count > 0 {
            expenseRecieve?.amount = Float(amount.text!)!
        }else{
            expenseRecieve?.amount = -1
        }
        expenseRecieve?.details = detailsInput.text ?? ""
        expenseRecieve?.date = dataPicker.date
        
        let errorMessage = editViewModel.isExpenseValid(expense: expenseRecieve!,img : imageView.image!)
        if errorMessage.count<1 {
            _ = navigationController?.popViewController(animated: true)
        }else{
            AlertService.showAlert(style: .alert, title: "Error", message: errorMessage)
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
            let editedImageResized = Utils.ResizeImage(image: editedImage)
            DispatchQueue.main.async {
                self.imageView.image = editedImageResized
            }
            
        }else if let originalImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage{
            let originalImageResized = Utils.ResizeImage(image: originalImage)
            DispatchQueue.main.async {
                self.imageView.image = originalImageResized
            }
        }
        dismiss(animated: true)
    }
}
