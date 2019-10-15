//
//  JWTTests.swift
//  M46SwiftTests
//
//  Created by David Jobe on 2019-10-11.
//  Copyright © 2019 se.mobility46. All rights reserved.
//

import XCTest
@testable import M46Swift

struct TestSession: Session {
    typealias Header = SessionHeader
    typealias Claims = SessionClaims
    
    let header: Header
    let claims: Claims

    class SessionHeader: Decodable {
        let alg: String
    }
    
    class SessionClaims: Decodable {
        let userId: Int
        
        enum DataKey: CodingKey {
            case user_id
        }
        
        required init(from decoder: Decoder) throws {
            let data = try decoder.container(keyedBy: DataKey.self)
            self.userId = try data.decode(Int.self, forKey: .user_id)
        }
        
        var description: String {
            return "[user_id: \(userId)]"
        }
    }
}

class JWTTests: XCTestCase {
    
    let testToken: String = "eyJhbGciOiJIUzI1NiJ9.eyJ1c2VyX2lkIjoxMTEsImV4cCI6MTYwMjQwNTQxMX0.mZEsM4EhRoDlH9QXWLz3DpM3hQEniwSNuWlPX2Rpy8g"

    func testDecode() throws {
        let jwt = JWT<TestSession>(base64: testToken)
        let decoded = jwt.decode(TestSession.self)
        XCTAssertTrue(decoded.isOk(), "decoded: \(decoded.map { v in v })")
        
        if case .ok(let s) = decoded {
            XCTAssertEqual(s.claims.userId, 111, s.claims.description)
        }
        
        
    }
}
