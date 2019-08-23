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
}
