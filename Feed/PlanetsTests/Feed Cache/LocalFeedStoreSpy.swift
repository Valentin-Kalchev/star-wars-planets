//
//  LocalFeedStoreSpy.swift
//  PlanetsTests
//
//  Created by Valentin Kalchev (Zuant) on 25/01/21.
//

import Foundation
import Planets

class LocalFeedStoreSpy: LocalFeedStore {
    
    enum Messages: Equatable {
        case retrieve
        case insert(LocalFeedPage, URL)
        case delete
    }
    
    private(set) var receivedMessages = [Messages]()
    
    private var retrievalCompletions = [RetrievalCompletion]()
    private var deletionCompletions = [DeletionCompletion]()
    private var insertionCompletions = [InsertionCompletion]()
    
    func insert(page: LocalFeedPage, with url: URL, completion: @escaping (InsertResult) -> Void) {
        receivedMessages.append(.insert(page, url))
        insertionCompletions.append(completion)
    }
    
    func retrieve(with url: URL, completion: @escaping RetrievalCompletion) {
        receivedMessages.append(.retrieve)
        retrievalCompletions.append(completion)
    }
    
    func deleteCacheFeed(for url: URL, completion: @escaping (DeleteResult) -> Void) {
        receivedMessages.append(.delete)
        deletionCompletions.append(completion)
    }
    
    func completeDeletion(with error: Error, at index: Int = 0) {
        deletionCompletions[index](.failure(error))
    }
    
    func completeDeletionSuccessfully(at index: Int = 0) {
        deletionCompletions[index](.success(()))
    }
    func completeInsertion(with error: Error, at index: Int = 0) {
        insertionCompletions[index](.failure(error))
    }
    
    func completeInsertionSuccessfully(at index: Int = 0) {
        insertionCompletions[index](.success(()))
    }
    
    func completeRetrieve(with error: Error, at index: Int = 0) {
        retrievalCompletions[index](.failure(error))
    } 
    
    func completeRetrieveWithEmptyCache(at index: Int = 0) {
        retrievalCompletions[index](.success(.none))
    }
    
    func completeRetrieve(with page: LocalFeedPage, timestamp: Date = Date(), at index: Int = 0) {
        retrievalCompletions[index](.success(page))
    }
}
