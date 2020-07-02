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

class AppStoreRequest : HttpRequest {
    typealias Response = AppStoreResponse
    var method: String = "get"
    var path: String = "http://itunes.apple.com/lookup"
    var body: Data?
    var query: Dictionary<String, String>?
}

public class SynClient {
    
    public struct SynResult {
        var verifiedVersion: SemVer?
        let message: String?
        let details: String?
        let status: SynResponse.VersionStatus
        
        var currentIncompatible: Bool {
            status == .updateRequired
        }
        
        var lockDevice: Bool {
            currentIncompatible && verifiedVersion != nil
        }
    }
    
    
    
    private let httpClient: HttpClient = HttpClient(baseURL: "")
    let callback: (Result<SynResult, Error>) -> Void

    public required init(_ callback: @escaping (Result<SynResult, Error>) -> Void) {
        self.callback = callback
    }
    
    private func newVersionAvailable(current: SemVer, bundleId: String, _ completion: @escaping (SemVer?) -> Void) {
        let request = AppStoreRequest()
        request.query?.updateValue("bundleId", forKey: bundleId)
        httpClient.send(request, { result in
            switch result {
            case .success(let data):
                if data.version > current {
                    completion(data.version)
                } else {
                    completion(nil)
                }
            case .failure(let err):
                Log.error(err)
                completion(nil)
            }
        })
    }

    public func performCheck(_ currentVersion: SemVer, bundleId: String) {
        let request = SynRequest()
        httpClient.send(request, { res in
            switch res {
            case .success(let data):
                if data.versionStatus != .latest {
                    self.newVersionAvailable(current: currentVersion, bundleId: bundleId, { version in
                        let result = SynResult(verifiedVersion: version, message: data.message, details: data.details, status: data.versionStatus)
                        self.handleResponse(res: .success(result))
                    })
                }
                break
            case .failure(let err):
                self.handleResponse(res: .failure(err))
                break
            }
        })
    }
    
    private func handleResponse(res: Result<SynResult, Error>) {
        DispatchQueue.main.async {
            self.callback(res)

        }
    }
}
