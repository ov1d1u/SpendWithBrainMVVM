//
//  SwinjectStoryboard.swift
//  SpendWithBrain
//
//  Created by Ovidiu Nitan on 28.11.2022.
//  Copyright © 2022 Maxim. All rights reserved.
//

import Swinject
import SwinjectStoryboard

extension SwinjectStoryboard {
    class func setup() {
        Container.loggingFunction = nil
        defaultContainer.register(CurrencyConverter.self) { _ in
            return NetworkCurrencyConverter()
        }
        defaultContainer.register(ConverterViewModel.self) { r in
            return ConverterViewModel(currencyConverter: r.resolve(CurrencyConverter.self))
        }
        defaultContainer.storyboardInitCompleted(ConverterViewController.self) { r, c in
            c.converterViewModel = r.resolve(ConverterViewModel.self)
        }
    }
}
