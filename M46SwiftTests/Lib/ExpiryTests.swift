//
//  ExpiryTests.swift
//  M46SwiftTests
//
//  Created by David Jobe on 2019-08-23.
//  Copyright © 2019 se.mobility46. All rights reserved.
//

import XCTest
@testable import M46Swift

class ExpiryTests: XCTestCase {

    func testSeconds() {
        let date = Date().addingTimeInterval(3000)
        let expiry = Expiry.seconds(3)
        XCTAssertEqual(
           date.timeIntervalSinceReferenceDate,
           expiry.date.timeIntervalSinceReferenceDate,
           accuracy: 0.1
        )
    }
    
    func testOneYear() {
        let date = Date(timeIntervalSince1970: 60 * 60 * 24 * 365)
        let expiry = Expiry.oneYear
        XCTAssertEqual(date, expiry.date)
    }
    
    func testDate() {
        let date = Date().addingTimeInterval(1000)
        let expiry = Expiry.date(date)
        XCTAssertEqual(expiry.date, date)
    }
}
