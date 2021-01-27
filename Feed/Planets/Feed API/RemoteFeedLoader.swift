//
//  RemoteFeedLoader.swift
//  Planets
//
//  Created by Valentin Kalchev (Zuant) on 23/01/21.
//

import Foundation

public class RemoteFeedLoader: FeedLoader {
     
    private let client: HTTPClient
    
    public enum Error: Swift.Error {
        case connectivity, invalidData
    }
    
    public typealias Result = FeedLoader.Result
    
    public init(client: HTTPClient) {
        self.client = client
    }
     
    public func load(from url: URL, completion: @escaping (Result) -> Void) {
        client.get(from: url) { [weak self] (result) in
            guard self != nil else { return }
            switch result {
            case .success((let data, let response)):
                do {
                    let remotePage = try FeedItemsMapper<RemoteFeedPage>.map(data, from: response)
                    return completion(.success(remotePage.model))
                } catch {
                    return completion(.failure(Error.invalidData))
                }
                
            case .failure:
                completion(.failure(Error.connectivity))
            }
        }
    }
}

private extension RemoteFeedPage {
    var model: Page {
        return Page(next: next != nil ? URL(string: next!) : nil, previous: previous != nil ? URL(string: previous!) : nil, planets: results?.toModels() ?? [])
    }
}

private extension Array where Element == RemoteFeedPlanet {
    func toModels() -> [Planet] {
        return map {
            Planet(name: $0.name,
                   rotationPeriod: $0.rotation_period != nil ? Int($0.rotation_period!): nil,
                   orbitalPeriod: $0.orbital_period != nil ? Int($0.orbital_period!): nil,
                   diameter: $0.diameter != nil ? Int($0.diameter!): nil,
                   climate: $0.climate,
                   gravity: $0.gravity,
                   terrain: $0.terrain,
                   surfaceWater: $0.surface_water,
                   population: $0.population != nil ? Int($0.population!): nil,
                   residents: $0.residents?.compactMap { URL(string: $0) },
                   films: $0.films?.compactMap { URL(string: $0) },
                   created: $0.created.isoFormattedDate()!,
                   edited: $0.edited.isoFormattedDate()!,
                   url: URL(string: $0.url)!)
        }
    }
}
