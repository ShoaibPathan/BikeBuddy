//
//  BoxTests.swift
//  BikeBuddyTests
//
//  Created by Naveen Magatala on 10/26/18.
//  Copyright © 2018 Lech H. Conde. All rights reserved.
//

import XCTest

@testable import BikeBuddy

class BoxTests: XCTestCase {
    
    enum MultiplicationError: String, Error {
        case empty = "no numbers to multiply"
    }
    
    func testValidAsyncMultiplication() {
        // Given
        let expectedProduct = 12
        var error: Error?
        let testExpectation = expectation(description: "async valid multiplication")
        
        // When
        multiplyIntegers(numbers: [1, 2, 3, 2])
            .then {
                XCTAssert(expectedProduct == $0)
                testExpectation.fulfill()
            }
            .error { error = $0 }
        
        // Then
        XCTAssert(error == nil)
        waitForExpectations(timeout: 2)
    }
    
    func testInValidAsyncMultiplication() {
        // Given
        var product: Int?
        let testExpectation = expectation(description: "async invalid multiplication")
        
        // When
        multiplyIntegers(numbers: [])
            .then { product = $0 }
            .error {
                XCTAssert(($0 as! MultiplicationError) == .empty)
                testExpectation.fulfill()
        }
        
        // Then
        XCTAssert(product == nil)
        waitForExpectations(timeout: 2)
    }
    
    private func multiplyIntegers(numbers: [Int]) -> Box<Int> {
        let box = Box<Int>()
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            if numbers.count != 0 {
                let product = numbers.reduce(1, { $0 * $1 })
                return box.resolve(product)
            }
            return box.fail(MultiplicationError.empty)
        }
        return box
    }
}
