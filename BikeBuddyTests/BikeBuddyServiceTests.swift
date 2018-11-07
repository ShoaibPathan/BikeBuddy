//
//  BikeBuddyServiceTests.swift
//  BikeBuddyTests
//
//  Created by Lech H. Conde on 18/05/2018.
//  Copyright © 2018 Lech H. Conde. All rights reserved.
//

import XCTest
@testable import BikeBuddy

class FooBikeBuddyService: Gettable {
    var getWasCalled = false
    var result = Result.success([Network]())
    
    func get(_ completion: @escaping (Result<[Network]>) -> Void) {
        getWasCalled = true
        completion(result)
    }
}

class BikeBuddyServiceTests: XCTestCase {

    //let newyork = Location(latitude: 40.6976633, longitude: -74.1201077)
    let viewModel = MainViewModel()
    var bikeBuddyData: [Network]?
    
    func testFetchBikeBuddyData() {
        viewModel.fetchData()
        XCTAssertNotNil(viewModel.networkList)
    }
    /*
    func testBikeBuddyDataEmptyResponse() {
        var expect = expectation(description: "bikeBuddyServiceResponse")
        // Do stuff
    }
    
    func testFetchBikeBuddyData() {
        viewModel.getBikeBuddyData(from: bikeBuddyService)
    }
    
    func testFetchBikeBuddyDataSuccess() {
        let fooBikeBuddyService = FooBikeBuddyService()
        viewModel.getBikeBuddyData(from: fooBikeBuddyService)
        // XCTAsserts
        XCTAssertTrue(fooBikeBuddyService.getWasCalled)
        // XCTAssertEqual(viewModel.dataSource.count, fooBikeBuddyService.dataSource.count)
        // XCTAssertEqual(viewModel.dataSource, fooBikeBuddyService.dataSource)
    }
    
    override func tearDown() {
        super.tearDown()
    }
    */
}
