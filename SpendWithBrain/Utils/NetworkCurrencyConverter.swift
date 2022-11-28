//
//  NetworkCurrencyConverter.swift
//  SpendWithBrain
//
//  Created by Ovidiu Nitan on 28.11.2022.
//  Copyright © 2022 Maxim. All rights reserved.
//

import Alamofire
import XMLMapper

class NetworkCurrencyConverter: CurrencyConverter {
    func getRates(_ completion: @escaping ((DataSet?) -> Void)) {
        AF.request("https://www.bnr.ro/nbrfxrates.xml", method: .get).response { response in
            if let data = response.data {
                let xml = try? XMLSerialization.xmlObject(with: data, options: [.default, .cdataAsString])
                let dataSet = XMLMapper<DataSet>().map(XMLObject: xml)
                completion(dataSet)
            } else {
                completion(nil)
            }
        }
    }
}
