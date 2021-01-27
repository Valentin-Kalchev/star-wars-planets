//
//  HTTPClientSpy.swift
//  PlanetsTests
//
//  Created by Valentin Kalchev (Zuant) on 26/01/21.
//

import Foundation 
import Planets

class HTTPClientSpy: HTTPClient {
    var requestedURLs: [URL] {
        return messages.map {$0.url }
    }
    
    var messages = [(url: URL, completion: (Result) -> Void)]()
    
    func get(from url: URL, completion: @escaping (HTTPClient.Result) -> Void) {
        messages.append((url, completion))
    }
    
    func completeLoad(with error: Error, at index: Int = 0) {
        messages[index].completion(.failure(error))
    }
    
    func complete(withStatusCode code: Int, data: Data = Data(), at index: Int = 0) {
        let response = HTTPURLResponse(url: requestedURLs[index], statusCode: code, httpVersion: nil, headerFields: nil)!
        messages[index].completion(.success((data, response)))
    }
}
