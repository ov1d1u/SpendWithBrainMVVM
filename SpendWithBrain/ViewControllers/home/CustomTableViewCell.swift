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
    var cellViewModel : CellViewModel! {
        didSet{
            dateOfExp.text = cellViewModel.day
            amount.text = cellViewModel.amount
            if Double(cellViewModel.amount)! < 0.0 {
                amount.textColor = #colorLiteral(red: 0.9921568627, green: 0.07450980392, blue: 0.07450980392, alpha: 1)
            }else{
                amount.textColor = #colorLiteral(red: 0.1019607843, green: 0.662745098, blue: 0.4470588235, alpha: 1)
            }
            incExp.text = cellViewModel.type
            category.text = cellViewModel.category
            imgCat.image = cellViewModel.imageCategory
            soldAfterExp.text = cellViewModel.soldAfter
            if Double(cellViewModel.soldAfter)! < 0.0 {
                soldAfterExp.textColor = #colorLiteral(red: 0.9921568627, green: 0.07450980392, blue: 0.07450980392, alpha: 1)
            }
        }
    }
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
    
}
