//
//  SynClient.swift
//  M46Swift
//
//  Created by David Jobe on 2020-02-13.
//  Copyright © 2020 se.mobility46. All rights reserved.
//

import Foundation
import UIKit

class SynRequest : HttpRequest {
    typealias Response = SynResponse
    var method: String = "get"
    var path: String = "https://syn.mobility46.se/api/v1/verify"
    var body: Data?
    var query: Dictionary<String, String>?
}

public struct SynResult {
    public let message: String?
    public let details: String?
    public let status: SynResponse.VersionStatus

    public var lockDevice: Bool {
        status == .updateRequired
    }
}

public class SynClient {

    private let httpClient: HttpClient = HttpClient(baseURL: "")
    let callback: (Result<SynResult, Error>) -> Void

    public required init(_ callback: @escaping (Result<SynResult, Error>) -> Void) {
        self.callback = callback
    }
    
    public func performCheck() {
        let request = SynRequest()
        httpClient.send(request, { res in
            switch res {
            case .success(let data):
                self.handleResponse(res: .success(SynResult(
                    message: data.message,
                    details: data.details,
                    status: data.versionStatus)
                ))
            case .failure(let err):
                self.handleResponse(res: .failure(err))
            }
        })
    }
    
    private func handleResponse(res: Result<SynResult, Error>) {
        DispatchQueue.main.async {
            self.callback(res)

        }
    }
}
