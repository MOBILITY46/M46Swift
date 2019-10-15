//
//  JWT+Base64URLEncoded.swift
//  M46Swift
//
//  Created by David Jobe on 2019-10-11.
//  Copyright © 2019 se.mobility46. All rights reserved.
//

import Foundation

extension JWT {
    public static func data(base64: String) -> Data? {
        let paddingLength = 4 - base64.count % 4
         let padding = (paddingLength < 4) ? String(repeating: "=", count: paddingLength) : ""
         let base64EncodedString = base64
             .replacingOccurrences(of: "-", with: "+")
             .replacingOccurrences(of: "_", with: "/")
             + padding
         return Data(base64Encoded: base64EncodedString)
    }
}
