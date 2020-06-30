//
//  SemVer.swift
//  M46Swift
//
//  Created by David Jobe on 2020-06-30.
//  Copyright © 2020 se.mobility46. All rights reserved.
//

import Foundation

public struct SemVer : Comparable, CustomStringConvertible {
    public var description: String
    
    let major: String
    let minor: String
    let patch: String
    
    internal init(major: String, minor: String = "0", patch: String = "0") {
        self.major = major
        self.minor = minor
        self.patch = patch
        self.description = [major, minor, patch].joined(separator: ".")
    }
    
    public init(major: UInt, minor: UInt = 0, patch: UInt = 0) {
        self.init(major: "\(major)", minor: "\(minor)", patch: "\(patch)")
    }
}

public func == (left: SemVer, right: SemVer) -> Bool {
    return (left.major.compare(right.major, options: .numeric) == .orderedSame) &&
        (left.minor.compare(right.minor, options: .numeric) == .orderedSame) &&
        (left.patch.compare(right.patch, options: .numeric) == .orderedSame)
}

public func < (left: SemVer, right: SemVer) -> Bool {
    for (l, r) in zip([left.major, left.minor, left.patch], [right.major, right.minor, right.patch]) {
        return l.compare(r, options: .numeric) == .orderedAscending
    }
    return false
}
