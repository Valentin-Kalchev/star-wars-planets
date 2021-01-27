//
//  LocalFeedLoader.swift
//  PlanetsTests
//
//  Created by Valentin Kalchev (Zuant) on 25/01/21.
//

import Foundation

public class LocalFeedLoader: FeedLoader {
    private let store: LocalFeedStore
    
    public init(store: LocalFeedStore) {
        self.store = store
    }
    
    public func load(from url: URL, completion: @escaping (FeedLoader.Result) -> Void) {
        store.retrieve(with: url) { (result) in
            switch result {
            case let .success(page):
                if let page = page {
                    completion(.success(page.toModel()))
                } else {
                    completion(.success(Page(next: nil, previous: nil, planets: [])))
                }
                
            case let .failure(error):
                completion(.failure(error))
            }
        }
    }
}

extension LocalFeedLoader {
    public typealias SaveResult = Swift.Result<Void, Error>
    
    public func save(page: Page, with url: URL, completion: @escaping (SaveResult) -> Void) {
        store.deleteCacheFeed(for: url) { [weak self] (result) in
            guard let self = self else { return }
            
            switch result {
            case .success(()):
                self.cache(page: page.toLocal(), with: url, completion: completion)
                
            case let .failure(error):
                completion(.failure(error))
            }
        }
    }
    
    private func cache(page: LocalFeedPage, with url: URL, completion: @escaping (SaveResult) -> Void) {
        store.insert(page: page, with: url) { [weak self] (result) in
            guard self != nil else { return }
            completion(result)
        }
    }
}

private extension LocalFeedPage {
    func toModel() -> Page {
        return Page(next: next, previous: previous, planets: planets.toModel())
    }
}

private extension Page {
    func toLocal() -> LocalFeedPage {
        return LocalFeedPage(next: next, previous: previous, planets: planets.toLocal())
    }
}

private extension Array where Element == Planet {
    func toLocal() -> [LocalFeedPlanet] {
        return map {
            LocalFeedPlanet(name: $0.name, rotationPeriod: $0.rotationPeriod, orbitalPeriod: $0.orbitalPeriod, diameter: $0.diameter, climate: $0.climate, gravity: $0.gravity, terrain: $0.terrain, surfaceWater: $0.surfaceWater, population: $0.population, residents: $0.residents, films: $0.films, created: $0.created, edited: $0.edited, url: $0.url)}
    }
}

private extension Array where Element == LocalFeedPlanet {
    func toModel() -> [Planet] {
        return map {
            Planet(name: $0.name, rotationPeriod: $0.rotationPeriod, orbitalPeriod: $0.orbitalPeriod, diameter: $0.diameter, climate: $0.climate, gravity: $0.gravity, terrain: $0.terrain, surfaceWater: $0.surfaceWater, population: $0.population, residents: $0.residents, films: $0.films, created: $0.created, edited: $0.edited, url: $0.url)
        }
    }
}
