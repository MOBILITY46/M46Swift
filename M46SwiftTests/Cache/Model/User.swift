//
//  User.swift
//  M46SwiftTests
//
//  Created by David Jobe on 2019-08-23.
//  Copyright © 2019 se.mobility46. All rights reserved.
//

import Foundation
@testable import M46Swift

struct User: Codable, Equatable {
    let firstName: String
    let lastName: String

    enum CodingKeys: String, CodingKey {
        case firstName = "firstName"
        case lastName = "lastName"
    }
}
