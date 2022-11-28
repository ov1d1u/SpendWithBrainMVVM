//
//  CurrencyConverter.swift
//  SpendWithBrain
//
//  Created by Ovidiu Nitan on 28.11.2022.
//  Copyright © 2022 Maxim. All rights reserved.
//

import Foundation

protocol CurrencyConverter {
    func getRates(_ completion: @escaping ((DataSet?) -> Void))
}

