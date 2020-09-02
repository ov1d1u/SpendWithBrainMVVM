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
    
    private var cell : CustomTableViewCell?
    override func viewDidLoad() {
        super.viewDidLoad()
        if cell != nil {
            catImg.image = cell?.imgCat.image
            catLbl.text = cell?.category.text
            details.text = cell?.details
            let amountTxt = cell!.amount.text!
            let absValAmount = abs(Double(amountTxt)!)
            amount.text = String(absValAmount)
            let dateFormat = DateFormatter()
            dateFormat.dateFormat = "yyyy-MM-dd at HH:mm"
            date.text = String(dateFormat.string(from: (cell?.date)!))
            photoImg.image = Utils.getImage(imageName: (cell?.imagePath)!)
        }
        stackCat.backgroundColor = #colorLiteral(red: 0.9607843137, green: 0.9529411765, blue: 0.9529411765, alpha: 1)
        stackCat.layer.cornerRadius = 4
        stackCat.layer.borderWidth = 1
        stackCat.layer.borderColor = #colorLiteral(red: 0.05566834658, green: 0.7084309459, blue: 0.5218427777, alpha: 1)
        container.layer.cornerRadius = 5
        container.backgroundColor = #colorLiteral(red: 1, green: 0.9764705882, blue: 0.9764705882, alpha: 1)
    }
    
    func setData(_ cell : CustomTableViewCell){
        self.cell = cell
    }
    @IBAction func deleteClick(_ sender: UIButton) {
        Utils.deleteDirectory(directoryName: (cell?.imagePath)!)
        LocalDataBase.deleteExpense((cell?.date)!)
        NotificationCenter.default.post(name: Notification.Name(rawValue: "refreshUserData"), object: nil)
        NotificationCenter.default.post(name: Notification.Name(rawValue: "refreshExpenseScreen"), object: nil)
        dismiss(animated: true)
    }
    
    @IBAction func editClick(_ sender: UIButton) {
        NotificationCenter.default.post(name: Notification.Name(rawValue: "editOpen"), object: nil, userInfo : ["cell" : cell!])
        //let editVC = Navigation.getEditViewController(cell!)
        //present(editVC,animated: true)
        //self.navigationController?.pushViewController(editVC, animated: true)
        dismiss(animated: true)
    }
    
    @IBAction func closeClick(_ sender: UIButton) {
        dismiss(animated: true)
    }
    
    

}
