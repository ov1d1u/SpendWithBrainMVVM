//
//  ShowInfo.swift
//  SpendWithBrain
//
//  Created by Maxim on 26/08/2020.
//  Copyright © 2020 Maxim. All rights reserved.
//

import UIKit

class ShowInfo {
    func alert() -> ShowInfoViewController {
        let sboard = UIStoryboard(name: "ShowInfo", bundle: .main)
        let showVC = sboard.instantiateViewController(withIdentifier: "showInfo") as! ShowInfoViewController
        return showVC
    }
}
