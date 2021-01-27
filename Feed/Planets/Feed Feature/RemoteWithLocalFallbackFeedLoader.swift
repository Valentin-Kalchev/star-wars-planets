//
//  RemoteWithLocalFallbackFeedLoader.swift
//  PlanetsApp
//
//  Created by Valentin Kalchev (Zuant) on 25/01/21.
//

import Foundation 

public class RemoteWithLocalFallbackFeedLoader: FeedLoader {
    private let primary: FeedLoader
    private let fallback: FeedLoader
    
    public init(primary: FeedLoader, fallback: FeedLoader) {
        self.primary = primary
        self.fallback = fallback
    }
    
    public func load(from url: URL, completion: @escaping (FeedLoader.Result) -> Void) {
        primary.load(from: url) { [weak self] (result) in
            switch result {
            case let .success(planets):
                completion(.success(planets))
                
            case .failure:
                self?.fallback.load(from: url) { (result) in
                    completion(result)
                }
            }
        }
    }
}
