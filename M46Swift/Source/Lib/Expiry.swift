//
//  Expiry.swift
//  M46Swift
//
//  Created by David Jobe on 2019-08-22.
//  Copyright © 2019 se.mobility46. All rights reserved.
//

import Foundation

public enum Expiry {
    case seconds(TimeInterval)
    case date(Date)
    case oneYear
    
    public var date: Date {
        switch self {
        case .seconds(let seconds):
            return Date().addingTimeInterval(seconds * 1000)
            
        case .date(let dt):
            return dt
            
        case .oneYear:
            let future = Date(timeIntervalSince1970: 60 * 60 * 24 * 365)
            return future
        }
    }

    public var isExpired: Bool {
        return date.inThePast
    }

}

extension Date {
    var inThePast: Bool {
        return timeIntervalSinceNow < 0
    }
}
