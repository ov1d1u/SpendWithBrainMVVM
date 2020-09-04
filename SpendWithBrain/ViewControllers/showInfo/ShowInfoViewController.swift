//
//  ShowInfoViewController.swift
//  SpendWithBrain
//
//  Created by Maxim on 26/08/2020.
//  Copyright © 2020 Maxim. All rights reserved.
//

import UIKit

class ShowInfoViewController: UIViewController{
    
    @IBOutlet weak var container: UIView!
    @IBOutlet weak var catImg: UIImageView!
    @IBOutlet weak var catLbl: UILabel!
    @IBOutlet weak var stackCat: UIView!
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var amount: UILabel!
    @IBOutlet weak var details: UILabel!
    @IBOutlet weak var photoImg: UIImageView!
    
    var cellRecieve : CellViewModel?
    var cellViewModel : CellViewModel!{
        didSet{
            catImg.image = cellViewModel.imageCategory
            catLbl.text = cellViewModel.category
            amount.text = String(cellViewModel.expense.amount)
            date.text = cellViewModel.getDateFormatForInfo()
            details.text = cellViewModel.expense.details
            photoImg.image = Utils.getImage(imageName: (cellViewModel.expense.image))
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        cellViewModel = cellRecieve!
        stackCat.backgroundColor = #colorLiteral(red: 0.9607843137, green: 0.9529411765, blue: 0.9529411765, alpha: 1)
        stackCat.layer.cornerRadius = 4
        stackCat.layer.borderWidth = 1
        stackCat.layer.borderColor = #colorLiteral(red: 0.05566834658, green: 0.7084309459, blue: 0.5218427777, alpha: 1)
        container.layer.cornerRadius = 5
        container.backgroundColor = #colorLiteral(red: 1, green: 0.9764705882, blue: 0.9764705882, alpha: 1)
    }
    
    func setData(_ cell : CellViewModel){
        self.cellRecieve = cell
    }
    @IBAction func deleteClick(_ sender: UIButton) {
        cellViewModel.deleteThisExpense()
        dismiss(animated: true)
    }
    
    @IBAction func editClick(_ sender: UIButton) {
        NotificationCenter.default.post(name: Notification.Name(rawValue: "editOpen"), object: nil, userInfo : ["cell" : cellViewModel!])
        dismiss(animated: true)
    }
    
    @IBAction func closeClick(_ sender: UIButton) {
        dismiss(animated: true)
    }
    
}
