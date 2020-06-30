//
//  ApiClient.swift
//  M46Swift
//
//  Created by David Jobe on 2020-02-13.
//  Copyright © 2020 se.mobility46. All rights reserved.
//

import Foundation

public class HttpClient {
    private let session = URLSession(configuration: .default)
    private let system = System()
    private let baseURL: String
    
    enum Error : Swift.Error {
        case malformedURL
    }
    
    public required init(baseURL: String = "") {
        self.baseURL = baseURL
    }

    public func send<T : HttpRequest>(_ request: T, token: String? = nil,
                           _ completion: @escaping ResultCallback<T.Response>) {
        do {
            let urlReq = try createURLRequest(request, token: token)
            Log.info("request: \(urlReq)")

            let task = session.dataTask(with: urlReq) { (data, response, error) in
    
                if let err = error {
                    completion(Swift.Result.failure(.unknown(err)))
                    return
                }

                if let response = response as? HTTPURLResponse {
                    if response.statusCode / 100 != 2 {
                        completion(.failure(.status(response.statusCode)))
                        return
                    }
                }
    
                if let data = data {
                    do {
                        let responseData = try JSONDecoder().decode(T.Response.self, from: data)
                        completion(.success(responseData))
                    } catch {
                        completion(.failure(.decoder(error)))
                    }
                }
            }
            task.resume()
        } catch {
            Log.error(error)
        }
    }
    
    private func createURLRequest<T : HttpRequest>(_ req: T, token: String?) throws -> URLRequest {
        guard var urlComponents = URLComponents(string: "\(baseURL)\(req.path)") else {
            throw Error.malformedURL
        }
        
        if let query = req.query {
            let queryItems = query.map { (key, value) in
                URLQueryItem(name: key, value: value)
            }
            urlComponents.queryItems = queryItems
        }
        
        guard let url = urlComponents.url else {
            throw Error.malformedURL
        }
        
        var urlReq = URLRequest(url: url)
        urlReq.httpMethod = req.method
        urlReq.httpBody = req.body
        
        urlReq.addValue("application/json", forHTTPHeaderField: "content-type")
        urlReq.addValue(system.description, forHTTPHeaderField: "user-agent")
        urlReq.addValue(UUID().uuidString, forHTTPHeaderField: "x-request-id")
        
        Log.info("\(system.description)")

        if let token = token {
            urlReq.addValue("Token \(token)", forHTTPHeaderField: "authorization")
        }
        
        return urlReq
    }
    
}

public protocol HttpResponse : Decodable {
}

public protocol HttpRequest: Encodable {
    associatedtype Response: Decodable
    var path: String { get }
    var method: String { get }
    var body: Data? { get }
    var query: Dictionary<String, String>? { get }
}

public typealias ResultCallback<T> = (Swift.Result<T, HttpError>) -> Void
