//
//  FeedLoader.swift
//  Planets
//
//  Created by Valentin Kalchev (Zuant) on 23/01/21.
//

import Foundation

public protocol FeedLoader {
    typealias Result = Swift.Result<Page, Error>
    func load(from url: URL, completion: @escaping (Result) -> Void)
}
