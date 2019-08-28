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
    case years(Int)
    case months(Int)
    
    public var date: Date {
        switch self {
        case .seconds(let seconds):
            return Date().addingTimeInterval(seconds * 1000)
            
        case .date(let dt):
            return dt
            
        case .months(let months):
            let future = Calendar.current.date(byAdding: .month, value: months, to: Date())!
            return future
            
        case .years(let years):
            let future = Calendar.current.date(byAdding: .year, value: years, to: Date())!
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
