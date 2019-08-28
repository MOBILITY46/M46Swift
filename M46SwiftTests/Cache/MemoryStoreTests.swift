//
//  MemoryStoreTests.swift
//  M46SwiftTests
//
//  Created by David Jobe on 2019-08-23.
//  Copyright © 2019 se.mobility46. All rights reserved.
//

import XCTest
@testable import M46Swift

class MemoryStoreTests: XCTestCase {
    private let key = "my-store-key"
    private let object = User(firstName: "Sune", lastName: "Surdeg")
    private let config = MemoryConfig(expiry: .years(1), countLimit: 10, totalCostLimit: 10)
    private var store: MemoryStore<User>!
    
    override func setUp() {
        store = MemoryStore<User>(config: config)
    }
    
    func testAdd() throws {
        store.add(object, forKey: key, expiry: nil)
        let cached: User? = try store.object(forKey: key)
        XCTAssertEqual(cached?.firstName, object.firstName)
        XCTAssertEqual(cached?.lastName, object.lastName)
    }
    
    func testRemove() throws {
        store.add(object, forKey: key, expiry: nil)
        var cached = try? store.object(forKey: key)
        XCTAssertTrue(cached != nil)
        
        store.remove(forKey: key)
        cached = try? store.object(forKey: key)
        XCTAssertTrue(cached == nil)
    }

}
