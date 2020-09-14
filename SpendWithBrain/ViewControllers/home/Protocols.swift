//
//  Protocols.swift
//  SpendWithBrain
//
//  Created by Maxim on 14/09/2020.
//  Copyright © 2020 Maxim. All rights reserved.
//

import Foundation

protocol ShowInfoDelegate {
    func show(_ expense: Expense)
    func delete(_ expense: Expense)
}

protocol ShowGreetingMessage {
    func showGreeting()
}

protocol RefreshViewModelDelegate {
    func refreshUI()
}
