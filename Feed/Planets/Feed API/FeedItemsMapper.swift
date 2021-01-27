//
//  FeedItemsMapper.swift
//  Planets
//
//  Created by Valentin Kalchev (Zuant) on 24/01/21.
//

import Foundation

final class FeedItemsMapper<T: Decodable> { 
    private static var OK_200: Int { return 200 }
    
    static func map(_ data: Data, from response: HTTPURLResponse) throws -> T {
        guard response.statusCode == OK_200,
            let decodable = try? JSONDecoder().decode(T.self, from: data) else {
            throw RemoteFeedLoader.Error.invalidData
        }
        
        return decodable
    }
}
