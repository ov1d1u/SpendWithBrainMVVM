//
//  Bundle.swift
//  SpendWithBrainTests
//
//  Created by Ovidiu Nitan on 28.11.2022.
//  Copyright © 2022 Maxim. All rights reserved.
//

import Foundation

extension Bundle {
    static var current: Bundle {
        class __ { }
        return Bundle(for: __.self)
    }
}
