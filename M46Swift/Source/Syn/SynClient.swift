//
//  SynClient.swift
//  M46Swift
//
//  Created by David Jobe on 2020-02-13.
//  Copyright © 2020 se.mobility46. All rights reserved.
//

import Foundation

class SynRequest : HttpRequest {
    typealias Response = SynResponse
    var method: String = "get"
    var path: String = "/verify"
    var body: Data? = nil
}

public class SynClient {
    
    let httpClient: HttpClient = HttpClient(baseURL: "https://syn.mobility46.se")
    
    let dialog: Dialog = Dialog()
    
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
        
        Log.debug("res: \(res)")
        
        switch res.versionStatus {
        case .latest:
            return
        case .updateRequired:
            // TODO(David): Lock app & inform user
            return
        case .updateAvailable:
            // TODO(David): Inform user
            return
        }
    }
    
    
}
