//
//  TrackListModelTest.swift
//  ScottishPowerTestTests
//
//  Created by Stephen Biggerstaff on 01/03/2020.
//  Copyright © 2020 Stephen. All rights reserved.
//

import XCTest
@testable import ScottishPowerTest

class TrackListModelTest: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testParsingExpectedJSON() {
       
        let expectation = XCTestExpectation(description: "ParsedJSON")
        //Just a simple parse test of expected JSON format. Tests that our codable objects are in the right shape.
        let testBundle = Bundle(for: type(of: self))
        if let path = testBundle.path(forResource: "ExpectedResponse", ofType: "json") {
            
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: [])
                let decoder = JSONDecoder()
                decoder.dateDecodingStrategy = .iso8601
                let jsonResult = try decoder.decode(TracksResponse.self, from: data)
                XCTAssert(jsonResult.resultCount == 50)
                
                jsonResult.results.forEach { (details) in

                    XCTAssertFalse(details.artistName.isEmpty)
                    XCTAssertFalse(details.artworkUrl100.isEmpty)
                    XCTAssertTrue(details.releaseDate.distance(to: Date()) > 0)
                    XCTAssertFalse(details.trackName.isEmpty)
                    XCTAssertTrue(details.trackTimeMillis > 0)
                    XCTAssertTrue(details.trackPrice > 0.0)
                    XCTAssertFalse(details.trackViewUrl.isEmpty)
                    expectation.fulfill()
                }
              } catch {
                
                    XCTFail("Failed to decode JSON")
                    expectation.fulfill()
              }
            
        } else {
            
            XCTFail("Could not read in JSON file.")
            expectation.fulfill()
        }
        
        // Wait until the expectation is fulfilled, with a timeout of 10 seconds.
        wait(for: [expectation], timeout: 10.0)
    }
}
