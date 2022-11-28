//
//  CurrencyConverterTests.swift
//  SpendWithBrainTests
//
//  Created by Ovidiu Nitan on 28.11.2022.
//  Copyright © 2022 Maxim. All rights reserved.
//

import Swinject
import SwinjectStoryboard
import XCTest
import Mockingbird
@testable import SpendWithBrain

final class CurrencyConverterTests: XCTestCase {
    var converterVM: ConverterViewModel!
    
    override func setUp() {
        // Setting up an expectation because `converterVM.getRates` is async
        let exp = expectation(description: "CurrencyConverterTests.setUp")

        // Get an instance of `ConverterViewModel` from the DI framework
        // Note that because in Testing/SwinjectStoryboard we register a DummyCurrencyConverter class
        // for the CurrencyConverter service, this will not trigger a network request
        converterVM = SwinjectStoryboard.defaultContainer.resolve(ConverterViewModel.self)

        // Retrieve the rates. Note that because in
        converterVM.getRates { result in
            // Fulfill the expectation
            exp.fulfill()
        }

        // Wait for the expectation, this will never fain anyway
        waitForExpectations(timeout: 5, handler: nil)
    }
    
    func testNativeCurrencyConverter() throws {
        // Test basic conversion (foreign to local)
        let rates = try XCTUnwrap(converterVM.rates)
        let valToConvert = "10"
        converterVM.leftSelectedCurrency = .EUR
        converterVM.rightSelectedCurrency = .RON
        converterVM.leftInput = valToConvert
        converterVM.didSetLeft(str: valToConvert)
        XCTAssertEqual(converterVM.rightInput, String((rates.getValue(for: .EUR) * Double(valToConvert)!).rounded(toPlaces: 3)))
        
        // TODO: Tests for `converterVM.currentRate`
    }
    
    func testForeignCurrencyConverter() throws {
        // TODO: Same tests as above, but with converterVM.leftSelectedCurrency = .EUR and converterVM.rightSelectedCurrency = .USD
    }
    
    func testConverterRatesFetch() {
        // Mocking
        let mockedCurrencyConverter = mock(CurrencyConverter.self)
        // Stubbing
        given(mockedCurrencyConverter.getRates(any())).will { _ in }
        
        // Instantiate `ConverterViewModel` with mocked `CurrencyConverter`
        let converterViewModel = ConverterViewModel(currencyConverter: mockedCurrencyConverter)
        let _ = converterViewModel.getRates { _ in }
        
        eventually {
            verify(mockedCurrencyConverter.getRates(any())).wasCalled()
        }
        
        waitForExpectations(timeout: 1)
    }

    func testViewModelFunctionality() {
        let mockedViewModel = mock(ConverterViewModel.self).initialize(currencyConverter: DummyCurrencyConverter())
        // TODO: Stubbing
        
        // TODO: Check if `didSetRight` and `didSetLeft` methods are properly called when `rightSelectedCurrency` and `rightSelectedCurrency` are being set
    }
}
