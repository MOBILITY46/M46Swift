//
//  Result.swift
//  M46Swift
//
//  Created by David Jobe on 2019-08-22.
//  Copyright © 2019 se.mobility46. All rights reserved.
//

import Foundation

public enum Result<T> {
    case value(T)
    case error(Error)
    
    public func map<U>(_ transform: (T) -> U) -> Result<U> {
        switch self {
        case .value(let val):
            return Result<U>.value(transform(val))
        case .error(let err):
            return Result<U>.error(err)
        }
    }
}
