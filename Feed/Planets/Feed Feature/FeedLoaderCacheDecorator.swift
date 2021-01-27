//
//  FeedLoaderCacheDecorator.swift
//  PlanetsApp
//
//  Created by Valentin Kalchev (Zuant) on 25/01/21.
//

import Foundation 

public class FeedLoaderCacheDecorator: FeedLoader {
    private let decoratee: FeedLoader
    private let cache: LocalFeedLoader
    
    public init(decoratee: FeedLoader, cache: LocalFeedLoader) {
        self.decoratee = decoratee
        self.cache = cache
    }
    
    public func load(from url: URL, completion: @escaping (FeedLoader.Result) -> Void) {
        decoratee.load(from: url) { [weak self] (result) in
            switch result {
            case let .success(page):
                self?.cache.save(page: page, with: url, completion: { _ in }) 
                completion(.success(page))
                
            case let .failure(error):
                completion(.failure(error))
            }
        }
    }
}
