//
//  Test+Extensions.swift
//  M46SwiftTests
//
//  Created by David Jobe on 2019-08-23.
//  Copyright © 2019 se.mobility46. All rights reserved.
//

import XCTest

extension XCTestCase {
    func given(_ description: String, closure: () throws -> Void) rethrows {
        try closure()
    }
    
    func when(_ description: String, closure: () throws -> Void) rethrows {
        try closure()
    }
    
    func then(_ description: String, closure: () throws -> Void) rethrows {
        try closure()
    }
    
    func assert<T, E: Error & Equatable>(
        _ expression: @autoclosure () throws -> T,
        throws error: E,
        in file: StaticString = #file,
        line: UInt = #line
    ) {
        var thrownError: Error?

        XCTAssertThrowsError(try expression(),
                             file: file, line: line) {
            thrownError = $0
        }

        XCTAssertTrue(
            thrownError is E,
            "Unexpected error type: \(type(of: thrownError))",
            file: file, line: line
        )

        XCTAssertEqual(
            thrownError as? E, error,
            file: file, line: line
        )
    }}
