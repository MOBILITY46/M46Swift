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
}
