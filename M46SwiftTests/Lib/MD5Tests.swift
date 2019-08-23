//
//  MD5Tests.swift
//  M46SwiftTests
//
//  Created by David Jobe on 2019-08-23.
//  Copyright © 2019 se.mobility46. All rights reserved.
//

import XCTest
@testable import M46Swift

class MD5Tests: XCTestCase {

    func testHashing() {
        let hash = "hello, world!".md5()
        let expected = "3adbbad1791fbae3ec908894c4963870"
        XCTAssertEqual(hash, expected, "md5: \(hash)")
    }

}
