//
//  ShowInfoViewController.swift
//  SpendWithBrain
//
//  Created by Maxim on 26/08/2020.
//  Copyright © 2020 Maxim. All rights reserved.
//

import UIKit
import Firebase

class ShowInfoViewController: UIViewController{
    
    @IBOutlet weak var container: UIView!
    @IBOutlet weak var catImg: UIImageView!
    @IBOutlet weak var catLbl: UILabel!
    @IBOutlet weak var stackCat: UIView!
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var amount: UILabel!
    @IBOutlet weak var details: UILabel!
    @IBOutlet weak var photoImg: UIImageView!
    
    var expense : Expense?
    var showInfoViewModel = ShowInfoViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        customize()
    }
    
    private func customize(){
        stackCat.backgroundColor = #colorLiteral(red: 0.9607843137, green: 0.9529411765, blue: 0.9529411765, alpha: 1)
        stackCat.layer.cornerRadius = 4
        stackCat.layer.borderWidth = 1
        stackCat.layer.borderColor = #colorLiteral(red: 0.05566834658, green: 0.7084309459, blue: 0.5218427777, alpha: 1)
        container.layer.cornerRadius = 5
        container.backgroundColor = #colorLiteral(red: 1, green: 0.9764705882, blue: 0.9764705882, alpha: 1)
        catImg.image = CategoryEnum.getCategoryImage(for: (expense?.category)!)
        catLbl.text = expense?.category?.rawValue
        date.text = showInfoViewModel.getDateFormatForInfo(date: (expense?.date)!)
        amount.text = String((expense?.amount.rounded(toPlaces: 2))!)
        details.text = expense?.details
        let uid = Auth.auth().currentUser!.uid
        let ref = Storage.storage().reference().child("\(uid)/\(expense!.image)")
        ref.getData(maxSize: 1 * 2000 * 2000) { data, error in
            if error != nil {
                self.photoImg.image = #imageLiteral(resourceName: "chitanta")
            } else {
                self.photoImg.image = UIImage(data: data!)
            }
        }
    }
    
    @IBAction func deleteClick(_ sender: UIButton) {
        showInfoViewModel.deleteThisExpense(expense: expense!)
        dismiss(animated: true)
    }
    
    @IBAction func editClick(_ sender: UIButton) {
        NotificationCenter.default.post(name: Notification.Name(rawValue: "editOpen"), object: nil, userInfo : ["expense" : expense!])
        dismiss(animated: true)
    }
    
    @IBAction func closeClick(_ sender: UIButton) {
        dismiss(animated: true)
    }
    
}
