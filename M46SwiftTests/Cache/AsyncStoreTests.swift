//
//  AsyncStoreTests.swift
//  M46SwiftTests
//
//  Created by David Jobe on 2019-08-23.
//  Copyright © 2019 se.mobility46. All rights reserved.
//

import XCTest
@testable import M46Swift

class AsyncStoreTests: XCTestCase {
    private let object = User(firstName: "Sune", lastName: "Surdeg")
    private var cache: AsyncStore<User>!

    override func setUp() {
        let memoryConfig = MemoryConfig(expiry: .years(1), countLimit: 10, totalCostLimit: 10)
        let memory = MemoryStore<User>(config: memoryConfig)
        let diskConfig = DiskConfig(name: "plupp", expiry: .years(1), maxSize: 20, directory: nil)
        let disk = try! DiskStore<User>(config: diskConfig, transformer: TransformerFactory.forCodable(ofType: User.self))
        
        let hybrid = HybridStore<User>(memory: memory, disk: disk)
        cache = AsyncStore(store: hybrid, queue: DispatchQueue(label: "queue"))
    }
    
    override func tearDown() {
        super.tearDown()
        cache.removeAll { _ in }
    }

    func testAdd() {
        let expectationOne = XCTestExpectation(description: #function)
        let expectationTwo = XCTestExpectation(description: #function)
        
        cache.add(object, forKey: "user", expiry: nil, { res in
            switch res {
                case .ok(_):
                    expectationOne.fulfill()
                    return
                case .err(let err):
                    XCTFail(err.localizedDescription)
            }
        })
        
        cache.entry(forKey: "user", { res in
            switch res {
            case .ok(let entry):
                if entry.expiry.isExpired == false {
                    print("Entry: \(entry)")
                    expectationTwo.fulfill()
                    return
                }
            case .err(let err):
                XCTFail(err.localizedDescription)
            }
        })
        
        
        
        wait(for: [expectationOne, expectationTwo], timeout: 1)
    }
}
