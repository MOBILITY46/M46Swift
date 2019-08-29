//
//  HybridStoreTests.swift
//  M46SwiftTests
//
//  Created by David Jobe on 2019-08-29.
//  Copyright © 2019 se.mobility46. All rights reserved.
//

import XCTest
@testable import M46Swift

class HybridStoreTests: XCTestCase {
    private let cacheName = "Hybrid"
    private let key = "user"
    private let user = User(firstName: "Sune", lastName: "Surdeg")
    private var store: HybridStore<User>!
    private let fileManager = FileManager()
    
    override func setUp() {
        super.setUp()
        let memory = MemoryStore<User>(config: MemoryConfig())
        let disk = try! DiskStore<User>(
            config: DiskConfig(
            name: "HybridDisk",
            expiry: .years(1)),
            transformer: TransformerFactory.forCodable(ofType: User.self)
        )
        
        store = HybridStore(memory: memory, disk: disk)
    }

    override func tearDown() {
        try? store.removeAll()
    }
    
    func testAdd() throws {
        try store.add(user, forKey: key, expiry: nil)
        XCTAssertNotNil(try store.object(forKey: key), "user could not be found")
    }
    

}
