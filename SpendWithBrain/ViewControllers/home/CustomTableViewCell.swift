//
//  CustomTableViewCell.swift
//  SpendWithBrain
//
//  Created by Maxim on 26/08/2020.
//  Copyright © 2020 Maxim. All rights reserved.
//

import UIKit

class CustomTableViewCell: UITableViewCell {
    @IBOutlet weak var dateOfExp : UILabel!
    @IBOutlet weak var amount: UILabel!
    @IBOutlet weak var soldAfterExp: UILabel!
    @IBOutlet weak var incExp: UILabel!
    @IBOutlet weak var category: UILabel!
    @IBOutlet weak var imgCat: UIImageView!
    @IBOutlet weak var containerView: UIView!
    var expense : Expense?
    
    override func awakeFromNib() {
        super.awakeFromNib()
                containerView.layer.cornerRadius = 4
                containerView.layer.borderWidth = 1
                containerView.layer.borderColor = #colorLiteral(red: 0.862745098, green: 0.862745098, blue: 0.862745098, alpha: 1)
                containerView.backgroundColor = #colorLiteral(red: 0.968627451, green: 0.9568627451, blue: 0.9568627451, alpha: 1)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setUI(_ soldAfter : Float){
        dateOfExp.text = getDayString(date: (expense?.date)!)
        category.text = expense!.category!.rawValue
        imgCat.image = CategoryEnum.getCategoryImage(for: expense!.category!)
        incExp.text = expense!.category == .Income ? "Income" : "Expense"
        amount.text = expense!.category == .Income ? "+\(expense!.amount)" : "-\(expense!.amount)"
        if expense!.category != .Income {
            amount.textColor = #colorLiteral(red: 0.9921568627, green: 0.07450980392, blue: 0.07450980392, alpha: 1)
        }else{
            amount.textColor = #colorLiteral(red: 0.1019607843, green: 0.662745098, blue: 0.4470588235, alpha: 1)
        }
        soldAfterExp.text = String(soldAfter.rounded(toPlaces: 2))
        DispatchQueue.main.async {
            if soldAfter < 0.0 {
                self.soldAfterExp.textColor = #colorLiteral(red: 0.9921568627, green: 0.07450980392, blue: 0.07450980392, alpha: 1)
            }
        }
        
    }
    
    private func getDayString(date : Date) -> String{
        if Calendar.current.isDateInToday(date){
            return "Today"
        }else if Calendar.current.isDateInYesterday(date){
            return "Yesterday"
        }else {
            let dateFormat = DateFormatter()
            dateFormat.dateFormat = "E d MMM"
            return  String(dateFormat.string(from: date))
        }
    }
    
}
