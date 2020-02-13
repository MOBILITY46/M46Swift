//
//  JWT.swift
//  M46Swift
//
//  Created by David Jobe on 2019-10-11.
//  Copyright © 2019 se.mobility46. All rights reserved.
//

import Foundation

public protocol JWTSession: Decodable {
    associatedtype Header = Decodable
    associatedtype Claims = Decodable
}

public struct JWT<T: JWTSession> {
    
    public enum Error : Swift.Error {
        case invalid(Component)
        case decode(Swift.Error)
        case typeMismatch
        
        public enum Component {
            case header
            case claims
        }
    }
    
    private let base64: String
    
    public init(base64: String) {
        self.base64 = base64
    }
    
    enum Keys: CodingKey {
        case header
        case claims
    }

    public func decode(_ type: T.Type) -> Result<T, Error> {
        let components = base64.components(separatedBy: ".")
        guard let headerData = JWT.data(base64: components[0]) else {
            return .failure(.invalid(.header))
        }

        guard let claimsData = JWT.data(base64: components[1]) else {
            return .failure(.invalid(.claims))
        }
        
        let decoder = JWTDecoder<T, Keys>(header: headerData, claims: claimsData)
        do {
            let decoded = try decoder.decode(type)
            return .success(decoded)
        } catch {
            return .failure(.decode(error))
        }
    }
}

fileprivate class JWTDecoder<T, Key: CodingKey> : Decoder where T: JWTSession {
    var codingPath: [CodingKey] = []
    var userInfo: [CodingUserInfoKey : Any] = [:]
    
    var header: Data
    var claims: Data
    
    init(header: Data, claims: Data) {
        self.header = header
        self.claims = claims
    }
    
    func decode(_ type: T.Type) throws -> T {
        return try type.init(from: self)
    }
    
    func container<Key>(keyedBy type: Key.Type) throws -> KeyedDecodingContainer<Key> where Key : CodingKey {
        let container = JWTDecoder<T, Key>(header: header, claims: claims)
        return KeyedDecodingContainer(container)
    }
    
    func unkeyedContainer() throws -> UnkeyedDecodingContainer {
        return UnkeyedContainer(decoder: self)
    }
    
    func singleValueContainer() throws -> SingleValueDecodingContainer {
        return UnkeyedContainer(decoder: self)
    }
    
    
}

extension JWTDecoder: KeyedDecodingContainerProtocol {
    func decodeNil(forKey key: Key) throws -> Bool {
        throw JWT<T>.Error.typeMismatch
    }
    
    var allKeys: [Key] {
        return ["header", "claims"].compactMap { Key(stringValue: $0) }
    }
    
    func contains(_ key: Key) -> Bool {
        return key.stringValue == "header" || key.stringValue == "claims"
    }
    
    func decode<V: Decodable>(_ type: V.Type, forKey key: Key) throws -> V {
        codingPath.append(key)
        let jsonDecoder = JSONDecoder()
        jsonDecoder.dateDecodingStrategy = .secondsSince1970
        if key.stringValue == "header" {
            return try jsonDecoder.decode(V.self, from: self.header)
        } else {
        }
        
        if key.stringValue == "claims" {
            return try jsonDecoder.decode(V.self, from: claims)
        } else {
        }
        
        return try type.init(from: self)
    }
    
    func nestedContainer<NestedKey>(keyedBy type: NestedKey.Type, forKey key: Key) throws -> KeyedDecodingContainer<NestedKey> where NestedKey : CodingKey {
        return try self.container(keyedBy: type)
    }
    
    func nestedUnkeyedContainer(forKey key: Key) throws -> UnkeyedDecodingContainer {
        return try self.unkeyedContainer()
    }
    
    func superDecoder() throws -> Decoder {
        return self
    }
    
    func superDecoder(forKey key: Key) throws -> Decoder {
        return self
    }
    
}

private struct UnkeyedContainer<T, K>: UnkeyedDecodingContainer, SingleValueDecodingContainer where T: JWTSession, K: CodingKey {
    var decoder: JWTDecoder<T, K>
    
    var codingPath: [CodingKey] { return [] }
    
    var count: Int? { return nil }
    
    var currentIndex: Int { return 0 }
    
    var isAtEnd: Bool { return false }
    
    func decode<T: Decodable>(_ type: T.Type) throws -> T {
        throw DecodingError.typeMismatch(type, DecodingError.Context(codingPath: codingPath, debugDescription: "JWTDecoder can only Decode JWT tokens"))
    }
    
    func decodeNil() -> Bool {
        return true
    }
    
    func nestedContainer<NestedKey>(keyedBy type: NestedKey.Type) throws -> KeyedDecodingContainer<NestedKey> where NestedKey : CodingKey {
        return try decoder.container(keyedBy: type)
    }
    
    func nestedUnkeyedContainer() throws -> UnkeyedDecodingContainer {
        return self
    }
    
    func superDecoder() throws -> Decoder {
        return decoder
    }
}
