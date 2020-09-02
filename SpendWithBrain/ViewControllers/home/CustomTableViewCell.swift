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
    var details : String?
    var imagePath : String?
    var date : Date?
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
