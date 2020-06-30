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
    var path: String = "/api/v1/verify"
    var body: Data? = nil
}

public struct AvailabilityResult {
    let successfulRequest: Bool
    let availableVersion: Bool?
}

public class VersionChecker {
    
    private let httpClient: HttpClient = HttpClient(baseURL: "https://syn.mobility46.se")
    let callback: (SynResponse) -> Void

    public required init(_ callback: @escaping (SynResponse) -> Void) {
        self.callback = callback
    }
    
    /*
    public func checkAvailability() -> AvailabilityResult {
        guard let info = Bundle.main.infoDictionary,
            let currentVersion = info["CFBundleShortVersionString"] as? String,
            let identifier = info["CFBundleIdentifier"] as? String,
            let url = URL(string: "http://itunes.apple.com/lookup?bundleId=\(identifier)") else {
                Log.error("Could not construct itunes lookup request")
                return AvailabilityResult(successfulRequest: false, availableVersion: nil)
        }
        do {
                
            let data = try Data(contentsOf: url)
            guard let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any] else {
                Log.error("Invalid response")
                return AvailabilityResult(successfulRequest: false, availableVersion: nil)
            }

        } catch {

        }

    }
 
    */

    public func performCheck() {
        let request = SynRequest()
        httpClient.send(request, { result in
            switch result {
            case .success(let data):
                self.handleResponse(res: data)
                break
            case .failure(let err):
                Log.error("SynClient: \(err)")
                break
            }
        })
    }
    
    private func handleResponse(res: SynResponse) {
        DispatchQueue.main.async {
            self.callback(res)

        }
    }
}
