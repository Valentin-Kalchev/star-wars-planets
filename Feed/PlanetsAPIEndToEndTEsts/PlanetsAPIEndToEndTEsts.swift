//
//  PlanetsAPIEndToEndTests.swift
//  PlanetsAPIEndToEndTests
//
//  Created by Valentin Kalchev (Zuant) on 24/01/21.
//

import XCTest
import Planets

class PlanetsAPIEndToEndTests: XCTestCase {

    func test_endToEndTestServerGETFeedResults_matchesFixedData() {
        switch getFeedResult() {
        case let .success(page):
            let count = page.planets.count
            XCTAssertEqual(count, 10, "Expected 60 planets, got \(count) instead")
            XCTAssertEqual(page.planets.first, expectedPlanet())
            // Other planets ...
            
        case let .failure(error):
            XCTFail("Expected successful feed result, got \(error) instead")
            
        default:
            XCTFail("Expected successful feed result, got no result instead")
        }
    } 
    
    // MARK: - Helper
    
    private func getFeedResult(file: StaticString = #file, line: UInt = #line) -> FeedLoader.Result? {
        let client = URLSessionHTTPClient()
        let loader = RemoteFeedLoader(client: client)
        trackForMemoryLeaks(client, file: file, line: line)
        trackForMemoryLeaks(loader, file: file, line: line)
        
        let exp = expectation(description: "Wait for load completion")
        var receivedResult: FeedLoader.Result?
        loader.load(from: URL(string: "https://swapi.dev/api/planets")!) { (result) in
            receivedResult = result
            exp.fulfill()
        }
        
        wait(for: [exp], timeout: 5.0)
        return receivedResult
    }
    
    
    private func expectedPlanet() -> Planet {
        return Planet(name: "Tatooine",
                      rotationPeriod: 23,
                      orbitalPeriod: 304,
                      diameter: 10465,
                      climate: "arid",
                      gravity: "1 standard",
                      terrain: "desert",
                      surfaceWater: "1",
                      population: 200000,
                      residents: [
                            URL(string: "http://swapi.dev/api/people/1/")!,
                            URL(string: "http://swapi.dev/api/people/2/")!,
                            URL(string: "http://swapi.dev/api/people/4/")!,
                            URL(string: "http://swapi.dev/api/people/6/")!,
                            URL(string: "http://swapi.dev/api/people/7/")!,
                            URL(string: "http://swapi.dev/api/people/8/")!,
                            URL(string: "http://swapi.dev/api/people/9/")!,
                            URL(string: "http://swapi.dev/api/people/11/")!,
                            URL(string: "http://swapi.dev/api/people/43/")!,
                            URL(string: "http://swapi.dev/api/people/62/")!
                      ],
                      films: [
                            URL(string: "http://swapi.dev/api/films/1/")!,
                            URL(string: "http://swapi.dev/api/films/3/")!,
                            URL(string: "http://swapi.dev/api/films/4/")!,
                            URL(string: "http://swapi.dev/api/films/5/")!,
                            URL(string: "http://swapi.dev/api/films/6/")!
                      ],
                      created: "2014-12-09T13:50:49.641000Z".isoFormattedDate()!,
                      edited: "2014-12-20T20:58:18.411000Z".isoFormattedDate()!,
                      url: URL(string: "http://swapi.dev/api/planets/1/")!)
    }
    
}
