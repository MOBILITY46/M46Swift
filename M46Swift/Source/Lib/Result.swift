//
//  Result.swift
//  M46Swift
//
//  Created by David Jobe on 2019-10-10.
//  Copyright © 2019 se.mobility46. All rights reserved.
//

import Foundation

public enum Result<T> {
    case ok(T)
    case err(Swift.Error)
    
    public func map<U>(_ transform: (T) -> U) -> Result<U> {
        switch self {
        case .ok(let val):
            return Result<U>.ok(transform(val))
        case .err(let err):
            return Result<U>.err(err)
        }
    }
}

public typealias M46Result = Result
