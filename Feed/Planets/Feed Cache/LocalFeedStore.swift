//
//  LocalFeedStore.swift
//  Planets
//
//  Created by Valentin Kalchev (Zuant) on 25/01/21.
//

import Foundation
 
public protocol LocalFeedStore {
    typealias InsertResult = Swift.Result<Void, Error>
    typealias InsertionCompletion = (InsertResult) -> Void
    func insert(page: LocalFeedPage, with url: URL, completion: @escaping (InsertResult) -> Void)
    
    typealias DeleteResult = Swift.Result<Void, Error>
    typealias DeletionCompletion = (DeleteResult) -> Void
    func deleteCacheFeed(for url: URL, completion: @escaping (DeleteResult) -> Void)
    
    typealias RetrieveResult = Swift.Result<LocalFeedPage?, Error>
    typealias RetrievalCompletion = (RetrieveResult) -> Void
    func retrieve(with url: URL, completion: @escaping RetrievalCompletion)
}
