//
//  DiskConfig.swift
//  M46Swift
//
//  Created by David Jobe on 2019-08-22.
//  Copyright © 2019 se.mobility46. All rights reserved.
//

import Foundation

public struct DiskConfig {
    public let name: String
    public let expiry: Expiry
    public let maxSize: UInt
    public let directory: URL?
    
    public init(name: String, expiry: Expiry, maxSize: UInt = 30, directory: URL? = nil) {
        self.name = name
        self.expiry = expiry
        self.maxSize = maxSize
        self.directory = directory
    }
}
