//
//  URLSessionHTTPClient.swift
//  Planets
//
//  Created by Valentin Kalchev (Zuant) on 24/01/21.
//

import Foundation

public struct UnexpectedValueRepresentation: Error {}

public class URLSessionHTTPClient: HTTPClient {
    private let session: URLSession
    public init(session: URLSession = .shared) {
        self.session = session
    }
    
    public func get(from url: URL, completion: @escaping (HTTPClient.Result) -> Void) {
        session.dataTask(with: url) { (data, response, error) in
            completion(Result {
                if let error = error {
                    throw error
                } else if let data = data, let response = response as? HTTPURLResponse {
                    return (data, response)
                } else {
                    throw UnexpectedValueRepresentation()
                }
            })
        }.resume()
    }
}
