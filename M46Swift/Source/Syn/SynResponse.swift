//
//  SynResponse.swift
//  M46Swift
//
//  Created by David Jobe on 2020-02-13.
//  Copyright © 2020 se.mobility46. All rights reserved.
//

import Foundation

public struct SynResponse : Decodable {
    private let versionStatus: VersionStatus
    private let message: String?
    private let details: String?
    
    var needsUpdate: Bool {
        return versionStatus == .updateRequired
    }
    
    var hasUpdate: Bool {
        return versionStatus != .latest
    }
    
    var info: (String, String) {
        return (message ?? "", details ?? "")
    }
    
    private enum VersionStatus : String, Decodable {
        case updateAvailable = "updateAvailable"
        case updateRequired = "updateRequired"
        case latest = "latest"
    }
    
    private enum Key : CodingKey {
        case versionStatus
        case message
        case details
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: Key.self)
        self.versionStatus = try container.decode(VersionStatus.self, forKey: .versionStatus)
        self.message = try container.decode(String.self, forKey: .message)
        self.details = try container.decode(String.self, forKey: .details)
    }
}
