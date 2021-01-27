//
//  PlanetsViewControllerTests.swift
//  PlanetsAppTests
//
//  Created by Valentin Kalchev (Zuant) on 27/01/21.
//

import XCTest
import PlanetsApp
import Planets

class PlanetsViewControllerTests: XCTestCase {
    func test_init_doesNotLoad() {
        let loader = LoaderSpy()
        let viewController = PlanetsUIComposer.viewController(with: loader)
        trackForMemoryLeaks(loader)
        trackForMemoryLeaks(viewController)
        
        XCTAssertTrue(loader.requestedURLs.isEmpty, "Expected no requestes")
    }
    
    private class LoaderSpy: FeedLoader {
        private(set) var requestedURLs = [URL]()
        func load(from url: URL, completion: @escaping (FeedLoader.Result) -> Void) {
            requestedURLs.append(url)
        }
    }
}


extension XCTestCase {
    func trackForMemoryLeaks(_ instance: AnyObject, file: StaticString = #file, line: UInt = #line) {
        addTeardownBlock { [weak instance] in
            XCTAssertNil(instance, "Instance should have been deallocated. Poterntial memory leak", file: file, line: line)
        }
    }
}
