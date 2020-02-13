//
//  SynResponse.swift
//  M46Swift
//
//  Created by David Jobe on 2020-02-13.
//  Copyright © 2020 se.mobility46. All rights reserved.
//

import Foundation

struct SynResponse : Decodable {
    let versionStatus: VersionStatus
    let message: String?
    let details: String?
    
    enum VersionStatus : String, Decodable {
        case updateAvailable = "updateAvailable"
        case updateRequired = "updateRequired"
        case latest = "latest"
    }
    
    enum Key : CodingKey {
        case versionStatus
        case message
        case details
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: Key.self)
        self.versionStatus = try container.decode(VersionStatus.self, forKey: .versionStatus)
        self.message = try container.decode(String.self, forKey: .message)
        self.details = try container.decode(String.self, forKey: .details)
    }
}
