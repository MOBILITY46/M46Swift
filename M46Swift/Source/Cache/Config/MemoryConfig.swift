//
//  MemoryConfig.swift
//  M46Swift
//
//  Created by David Jobe on 2019-08-22.
//  Copyright © 2019 se.mobility46. All rights reserved.
//

import Foundation

public struct MemoryConfig {
    
    /// Expiry date that will be applied by default for every added object
    public let expiry: Expiry
    
    public let countLimit: UInt
    public let totalCostLimit: UInt
    
    public init(expiry: Expiry = .oneYear, countLimit: UInt = 0, totalCostLimit: UInt = 0) {
        self.expiry = expiry
        self.countLimit = countLimit
        self.totalCostLimit = totalCostLimit
    }
}
