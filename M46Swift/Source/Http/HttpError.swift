//
//  HttpError.swift
//  M46Swift
//
//  Created by David Jobe on 2020-02-13.
//  Copyright © 2020 se.mobility46. All rights reserved.
//

import Foundation

public enum HttpError : Swift.Error {
    case unknown(Error)
    case status(Int)
    case decoder(Error)
}
