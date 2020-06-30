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
        let now = Date()
        let oneYear = Calendar.current.date(byAdding: .year, value: 1, to: now)!
        let expiry = Expiry.years(1)
        XCTAssertEqual(oneYear.timeIntervalSinceNow, expiry.date.timeIntervalSinceNow, accuracy: 0.1)
        XCTAssertFalse(expiry.isExpired)
    }
    
    func testOneMonths() {
        let now = Date()
        let oneYear = Calendar.current.date(byAdding: .month, value: 1, to: now)!
        let expiry = Expiry.months(1)
        XCTAssertEqual(oneYear.timeIntervalSinceNow, expiry.date.timeIntervalSinceNow, accuracy: 0.1)
        XCTAssertFalse(expiry.isExpired)
    }
    
    func testDate() {
        let date = Date().addingTimeInterval(1000)
        let expiry = Expiry.date(date)
        XCTAssertEqual(expiry.date, date)
    }
}
