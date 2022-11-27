//
//  EmailValidationsTest.swift
//  SpendWithBrainTests
//
//  Created by Ovidiu Nitan on 25.11.2022.
//  Copyright © 2022 Maxim. All rights reserved.
//

import XCTest
@testable import SpendWithBrain

final class EmailValidationsTests: XCTestCase {
    func testCorrectEmail() {
        XCTAssert(Validations.emailValid(email: "email@assist.ro"))
    }

    func testIncorrectFormatEmail() {
        XCTAssertFalse(Validations.emailValid(email: "email"))
    }

    func testDoubleAroundEmail() {
        XCTAssertFalse(Validations.emailValid(email: "email@localhost@assist.ro"))
    }
}
