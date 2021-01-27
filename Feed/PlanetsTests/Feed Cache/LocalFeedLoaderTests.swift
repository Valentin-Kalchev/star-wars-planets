//
//  LocalFeedLoaderTests.swift
//  PlanetsTests
//
//  Created by Valentin Kalchev (Zuant) on 24/01/21.
//

import XCTest
import Planets

// MARK: - Load

class LocalFeedLoaderTests: XCTestCase {
    func test_init_doesNotRequestDataFromStore() {
        let (_, store) = makeSUT()
        XCTAssertEqual(store.receivedMessages, [])
    }
    
    func test_load_requestsCacheRetrieval() {
        let (sut, store) = makeSUT()
        sut.load(from: anyURL()) { _ in }
        XCTAssertEqual(store.receivedMessages, [.retrieve])
    }
    
    func test_load_failsOnRetrievalError() {
        let (sut, store) = makeSUT()
        
        let error = anyNSError()
        expect(sut: sut, toCompleteWith: .failure(error)) {
            store.completeRetrieve(with: error)
        }
    }
    
    func test_load_deliversNoPlanetsOnEmptyCache() {
        let (sut, store) = makeSUT()
        
        expect(sut: sut, toCompleteWith: .success(Page(next: nil, previous: nil, planets: []))) {
            store.completeRetrieveWithEmptyCache()
        }
    }
    
    func test_load_deliversCachedPlanetsOnNonExpiredCache() {
        let (sut, store) = makeSUT()
        let feed = pageFeed()
        expect(sut: sut, toCompleteWith: .success(feed.model), when: {
            store.completeRetrieve(with: feed.local)
        })
    }
    
    private func expect(sut: LocalFeedLoader, toCompleteWith expectedResult: FeedLoader.Result, when action: () -> Void, file: StaticString = #file, line: UInt = #line) {
        
        let exp = expectation(description: "Wait for load")
        sut.load(from: anyURL()) { (receivedResult) in
            switch (expectedResult, receivedResult) {
            case (let .success(expectedPlanets), let .success(receivedPlanets)):
                XCTAssertEqual(expectedPlanets, receivedPlanets, file: file, line: line)
                
            case (let .failure(expectedError), let .failure(receivedError)):
                XCTAssertEqual(expectedError as NSError?, receivedError as NSError?, file: file, line: line)
                
            default:
                XCTFail("Expected \(expectedResult), got \(receivedResult) instead", file: file, line: line)
            }
            exp.fulfill()
        }
        
        action()
        
        wait(for: [exp], timeout: 1.0)
    }
}


// MARK: - Save

extension LocalFeedLoaderTests {
    func test_save_requestCacheDeletion() {
        let (sut, store) = makeSUT()
        sut.save(page: pageFeed().model, with: anyURL(), completion: { _ in })
        XCTAssertEqual(store.receivedMessages, [.delete])
    }
    
    func test_save_doesNotRequestCacheInsertionOnDeletionError() {
        let (sut, store) = makeSUT()
        sut.save(page: pageFeed().model, with: anyURL(), completion: { _ in })
        store.completeDeletion(with: anyNSError())
        XCTAssertEqual(store.receivedMessages, [.delete])
    }
    
    func test_save_requestsNewCacheInsertionWithTimestampOnSuccessfulDeletion() {
        let (sut, store) = makeSUT()
        let feed = pageFeed()
        let url = anyURL()
        sut.save(page: feed.model, with: url, completion: { _ in })
        store.completeDeletionSuccessfully()
        XCTAssertEqual(store.receivedMessages, [.delete, .insert(feed.local, url)])
    }
    
    func test_save_failOnDeletionError() {
        let (sut, store) = makeSUT()
    
        let error = anyNSError()
        expect(sut: sut, toCompleteWithError: error) {
            store.completeDeletion(with: error)
        }
    }
    
    func test_save_failOnInsertionError() {
        let (sut, store) = makeSUT()
        let error = anyNSError()
        expect(sut: sut, toCompleteWithError: error) {
            store.completeDeletionSuccessfully()
            store.completeInsertion(with: error)
        }
    }
    
    func test_save_succeedsOnSuccessfulCacheInsertion() {
        let (sut, store) = makeSUT()
        
        expect(sut: sut, toCompleteWithError: nil) {
            store.completeDeletionSuccessfully()
            store.completeInsertionSuccessfully()
        }
    }
    
    private func expect(sut: LocalFeedLoader, toCompleteWithError expectedError: NSError?, when action: () -> Void, file: StaticString = #file, line: UInt = #line) {
        let exp = expectation(description: "Wait for save")
        
        var receivedError: Error?
        sut.save(page: pageFeed().model, with: anyURL()) { (result) in
            if case let Result.failure(error) = result {
                receivedError = error
            }
            exp.fulfill()
        }
        
        action()
        wait(for: [exp], timeout: 1.0)
        XCTAssertEqual(receivedError as NSError?, expectedError, file: file, line: line)
    }
}

extension LocalFeedLoaderTests {
    private func makeSUT(file: StaticString = #file, line: UInt = #line) -> (sut: LocalFeedLoader, store: LocalFeedStoreSpy) {
        let store = LocalFeedStoreSpy()
        let sut = LocalFeedLoader(store: store)
        trackForMemoryLeaks(store, file: file, line: line)
        trackForMemoryLeaks(sut, file: file, line: line)
        return (sut, store)
    }
}
