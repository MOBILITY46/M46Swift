//
//  Transformer.swift
//  M46Swift
//
//  Created by David Jobe on 2019-08-22.
//  Copyright © 2019 se.mobility46. All rights reserved.
//

import Foundation

struct TypeWrapper<T: Codable>: Codable {
    enum CodingKeys: String, CodingKey {
        case object
    }
    
    public let object: T
    
    public init(object: T) {
        self.object = object
    }
}

public class Transformer<T> {
    let toData: (T) throws -> Data
    let fromData: (Data) throws -> T
    
    public init(toData: @escaping (T) throws -> Data, fromData: @escaping (Data) throws -> T) {
        self.toData = toData
        self.fromData = fromData
    }
}

public class TransformerFactory {
    
    public static func forData() -> Transformer<Data> {
        let toData: (Data) throws -> Data = { $0 }
        let fromData: (Data) throws -> Data = { $0 }
        return Transformer<Data>(toData: toData, fromData: fromData)
    }
    
    public static func forCodable<U: Codable>(ofType: U.Type) -> Transformer<U> {
        let toData: (U) throws -> Data = { object in
            let wrapper = TypeWrapper<U>(object: object)
            let encoder = JSONEncoder()
            return try encoder.encode(wrapper)
        }
        
        let fromData: (Data) throws -> U = { data in
            let decoder = JSONDecoder()
            return try decoder.decode(TypeWrapper<U>.self, from: data).object
        }
        
        return Transformer<U>(toData: toData, fromData: fromData)
    }
}


