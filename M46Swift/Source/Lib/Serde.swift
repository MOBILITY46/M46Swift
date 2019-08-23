//
//  Serde.swift
//  M46Swift
//
//  Created by David Jobe on 2019-08-22.
//  Copyright © 2019 se.mobility46. All rights reserved.
//

import Foundation

public class Serde {
    
    static func serialize<T: Encodable>(object: T) throws -> Data {
        let encoder = JSONEncoder()
        return try encoder.encode(object)
    }
    
    static func deserialize<T: Decodable>(data: Data) throws -> T {
        let decoder = JSONDecoder()
        return try decoder.decode(T.self, from: data)
    }
    
}
