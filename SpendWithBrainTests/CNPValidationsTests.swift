//
//  CNPValidationsTests.swift
//  SpendWithBrainTests
//
//  Created by Ovidiu Nitan on 27.11.2022.
//  Copyright © 2022 Maxim. All rights reserved.
//

import XCTest
@testable import SpendWithBrain

final class CNPValidationsTests: XCTestCase {
    func testCorrectCNP() {
        XCTAssert(Validations.cnpValid("1920708093241"))
        XCTAssert(Validations.cnpValid("2911007196811"))
        XCTAssert(Validations.cnpValid("5041228425461"))
        XCTAssert(Validations.cnpValid("6000301400978"))
    }
    
    func testGarbageCNP() {
        XCTAssertFalse(Validations.cnpValid("This is not a CNP"))
    }
    
    func testInvalidChecksum() {
        XCTAssertFalse(Validations.cnpValid("1920708093242"))
    }
    
    func testInvalidCounty() {
        XCTAssertFalse(Validations.cnpValid("1920708693241"))
    }
    
    func testInvalidOrdNo() {
        XCTAssertFalse(Validations.cnpValid("1920708090001"))
    }
}
