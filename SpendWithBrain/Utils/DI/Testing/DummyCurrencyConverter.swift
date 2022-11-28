//
//  DummyCurrencyConverter.swift
//  SpendWithBrain
//
//  Created by Ovidiu Nitan on 28.11.2022.
//  Copyright © 2022 Maxim. All rights reserved.
//

import Foundation
@testable import SpendWithBrain

class DummyCurrencyConverter: CurrencyConverter {
    func getRates(_ completion: @escaping ((SpendWithBrain.DataSet?) -> Void)) {
        let fixturesPath = Bundle.current.path(forResource: "ConversionData", ofType: "xml")!
        completion(SpendWithBrain.DataSet(XMLString: try! String(contentsOfFile: fixturesPath)))
    }
}
