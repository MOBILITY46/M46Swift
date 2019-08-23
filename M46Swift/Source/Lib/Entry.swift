//
//  Entry.swift
//  M46Swift
//
//  Created by David Jobe on 2019-08-22.
//  Copyright © 2019 se.mobility46. All rights reserved.
//

import Foundation

public struct Entry<T> {
    public let object: T
    public let expiry: Expiry
    public let filePath: String?
    
    init(object: T, expiry: Expiry) {
        self.object = object
        self.expiry = expiry
        self.filePath = nil
    }
    
    init(object: T, expiry: Expiry, filePath: String?) {
        self.object = object
        self.expiry = expiry
        self.filePath = filePath
    }
}
