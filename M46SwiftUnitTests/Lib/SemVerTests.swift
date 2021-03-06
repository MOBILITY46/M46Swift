//
//  SemVerTests.swift
//  M46SwiftTests
//
//  Created by David Jobe on 2020-06-30.
//  Copyright © 2020 se.mobility46. All rights reserved.
//

import XCTest
@testable import M46Swift

class SemVerTests: XCTestCase {
    
    let validVersions = [
        ("1.0.0", SemVer(major: 1, minor: 0, patch: 0)),
        ("1.1.0", SemVer(major: 1, minor: 1, patch: 0)),
        ("1.1.1", SemVer(major: 1, minor: 1, patch: 1)),
        ("1.1.1-alpha.11", SemVer(major: 1, minor: 1, patch: 1)),
    ]
    
    func testParsingValidVersions() throws {
        try validVersions.forEach {
            let parsed = try SemVer.parse($0.0)
            XCTAssertEqual(parsed, $0.1)
        }
    }
    
    func testParsingInvalidVersions() throws {
        assert(try SemVer.parse("1.0"), throws: SemVer.ParsingError.digitsNotFound("1.0"))
        assert(try SemVer.parse("a.b.c"), throws: SemVer.ParsingError.missingVersionComponent(.major))
        assert(try SemVer.parse("1.b.c"), throws: SemVer.ParsingError.missingVersionComponent(.minor))
        assert(try SemVer.parse("1.0.c"), throws: SemVer.ParsingError.missingVersionComponent(.patch))
    }
    
    func testComparable() throws {
        let cond1 = try SemVer.parse("1.0.0") > SemVer.parse("0.1.0")
        XCTAssertTrue(cond1)
        let cond2 = try SemVer.parse("0.1.0") == SemVer.parse("0.1.0")
        XCTAssertTrue(cond2)
        let cond3 = try SemVer.parse("1.0.9") > SemVer.parse("1.0.0")
        XCTAssertTrue(cond3)
        let cond4 = try SemVer.parse("1.9.0") > SemVer.parse("1.1.0")
        XCTAssertTrue(cond4)
        let cond5 = try SemVer.parse("0.0.1") == SemVer.parse("0.0.1")
        XCTAssertTrue(cond5)
    }
}
