//
//  DiskStoreTests.swift
//  M46SwiftTests
//
//  Created by David Jobe on 2019-08-23.
//  Copyright © 2019 se.mobility46. All rights reserved.
//

import XCTest
@testable import M46Swift

class DiskStoreTests: XCTestCase {
    private let key = "my-store-key"
    private let object = User(firstName: "Sune", lastName: "Surdeg")
    private let config = DiskConfig(name: "plupp", expiry: .oneYear, maxSize: 2000, directory: nil)
    private let fileManager = FileManager()
    private var store: DiskStore<User>!

    override func setUp() {
        store = try! DiskStore<User>(
            config: config,
            transformer: TransformerFactory.forCodable(ofType: User.self)
        )
    }

    func testAdd() throws {
        try store.add(object, forKey: key, expiry: nil)
        let cached: User? = try store.object(forKey: key)
        XCTAssertEqual(cached?.firstName, object.firstName)
        XCTAssertEqual(cached?.lastName, object.lastName)
    }
    
    func testRemove() throws {
        try store.add(object, forKey: key, expiry: nil)
        var fileExists = fileManager.fileExists(atPath: store.makeFilePath(for: key))
        XCTAssertTrue(fileExists)
        
        try store.remove(forKey: key)
        fileExists = fileManager.fileExists(atPath: store.makeFilePath(for: key))
        XCTAssertFalse(fileExists)
    }

}
