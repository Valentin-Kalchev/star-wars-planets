//
//  RemoteFeedLoaderTests.swift
//  PlanetsTests
//
//  Created by Valentin Kalchev (Zuant) on 23/01/21.
//

import XCTest
import Planets

class RemoteFeedLoaderTests: XCTestCase {
    
    func test_init_doesNotRequestDataFromURL() {
        let (_, client) = makeSUT()
        XCTAssertNil(client.requestedURLs.first)
    }
    
    func test_load_requestsDataFromURL() {
        let (sut, client) = makeSUT()
        sut.load(from: anyURL()) {_ in}
        XCTAssertNotNil(client.requestedURLs.first)
    }
    
    func test_load_deliversConnectivityErrorOnClientError() {
        let (sut, client) = makeSUT()
        
        expect(sut: sut, toCompleteWith: failure(.connectivity)) {
            client.completeLoad(with: NSError(domain: "test", code: 0))
        }
    }
    
    func test_load_deliversErrorOnNon200HTTPResponse() {
        let (sut, client) = makeSUT()
        
        [199, 201, 300, 400, 500].enumerated().forEach { (index, code) in
            expect(sut: sut, toCompleteWith: failure(.invalidData)) {
                client.complete(withStatusCode: code, at: index)
            }
        }
    }
    
    func test_load_deliversNoItemsOn200HTTPResponseWithEmptyJSONList() {
        let (sut, client) = makeSUT()
        expect(sut: sut, toCompleteWith: .success(Page(next: nil, previous: nil, planets: []))) {
            client.complete(withStatusCode: 200, data: data(with: [:]))
        }
    }
    
    func test_load_deliversItemsOn200HTTPResponseWithJSONItems() {
        let (sut, client) = makeSUT()
        
        let page = makePage()
        expect(sut: sut, toCompleteWith: .success(page.model)) {
            client.complete(withStatusCode: 200, data: data(with: page.json))
        }
    }
    
    func test_load_doesNotDeliverResultAfterSUTInstanceHasBeenDeallocated() {
        let client = HTTPClientSpy()
        
        var capturedResults = [RemoteFeedLoader.Result]()
        var sut: RemoteFeedLoader? = RemoteFeedLoader(client: client)
        
        sut?.load(from: anyURL()) { (result) in
            capturedResults.append(result)
        }
        sut = nil
        
        client.complete(withStatusCode: 200, data: data(with:[:]))
        XCTAssertTrue(capturedResults.isEmpty)
    }
    
    // MARK: - Helpers
    
    private func makeSUT(file: StaticString = #file, line: UInt = #line) -> (sut: RemoteFeedLoader, client: HTTPClientSpy) {
        let client = HTTPClientSpy()
        let sut = RemoteFeedLoader(client: client)
        
        trackForMemoryLeaks(client, file: file,line: line)
        trackForMemoryLeaks(sut, file: file, line: line)
        
        return (sut, client)
    }
    
    private func expect(sut: RemoteFeedLoader, toCompleteWith expectedResult: RemoteFeedLoader.Result, when action: () -> Void, file: StaticString = #file, line: UInt = #line) {
        let exp = expectation(description: "Wait for load completion")
        
        sut.load(from: anyURL()) { (receivedResult) in
            switch (expectedResult, receivedResult) {
            
            case (let .success(expectedPlanets), let .success(receivedPlanets)):
                XCTAssertEqual(expectedPlanets, receivedPlanets, file: file, line: line)
                
            case (let .failure(expectedError as RemoteFeedLoader.Error), let .failure(receivedError as RemoteFeedLoader.Error)):
                XCTAssertEqual(expectedError, receivedError, file: file, line: line)
                
            default:
                XCTFail("Expected result \(expectedResult), got \(receivedResult) instead", file: file, line: line)
                
            }
            exp.fulfill()
        }
        
        action()
        
        wait(for: [exp], timeout: 2.0)
    }
    
    private func failure(_ error: RemoteFeedLoader.Error) -> RemoteFeedLoader.Result {
        return .failure(error)
    }
    
    private func makePage(next: URL? = URL(string: "http://next-url.com")!,
                            previous: URL? = URL(string: "http://previous-url.com")!) -> (model: Page, json: [String: Any?]) {
        
        let (planet1, planet1JSON) = makePlanet(name: "Tatooine", created: "2014-12-10T11:35:48.479000Z".isoFormattedDate()!, edited: "2014-12-20T20:58:18.420000Z".isoFormattedDate()!, url: URL(string: "http://planet1-url.com")!)
        
        let (planet2, planet2JSON) = makePlanet(name: "Alderaan", created: "2014-12-10T11:35:48.479000Z".isoFormattedDate()!, edited: "2014-12-20T20:58:18.420000Z".isoFormattedDate()!, url: URL(string: "http://planet2-url.com")!)
        
        let page = Page(next: next, previous: previous, planets: [planet1, planet2])
        let json: [String: Any?] = [
            "next": next != nil ? "\(next!.absoluteString)" : nil,
            "previous": previous != nil ? "\(previous!.absoluteString)" : nil,
            "results": [
                planet1JSON,
                planet2JSON
            ]
        ]
            
        return (page, json)
    }
    
    private func makePlanet(name: String? = nil, rotationPeriod: Int? = nil, orbitalPeriod: Int? = nil, diameter: Int? = nil, climate: String? = nil, gravity: String? = nil, terrain: String? = nil, surfaceWater: String? = nil, population: Int? = nil, residents: [URL]? = nil, films: [URL]? = nil, created: Date, edited: Date,  url: URL) -> (planet: Planet, json: [String: Any?]) {
        
        let planet = Planet(name: name, rotationPeriod: rotationPeriod, orbitalPeriod: orbitalPeriod, diameter: diameter, climate: climate, gravity: gravity, terrain: terrain, surfaceWater: surfaceWater, population: population, residents: residents, films: films, created: created, edited: edited, url: url)
        
        let json: [String: Any?] = [
            "name": name,
            "rotationPeriod": rotationPeriod != nil ? "\(rotationPeriod!)" : nil,
            "orbitalPeriod": orbitalPeriod != nil ? "\(orbitalPeriod!)" : nil,
            "diameter": diameter != nil ? "\(diameter!)" : nil,
            "climate": climate,
            "gravity": gravity,
            "terrain": terrain,
            "surfaceWater": surfaceWater,
            "population": population != nil ? "\(population!)" : nil,
            "residents": residents?.map { $0.absoluteString },
            "films": films?.map { $0.absoluteString },
            "created": created.iso8601FormattedString(),
            "edited": edited.iso8601FormattedString(),
            "url": url.absoluteString
        ]
        
        return (planet, json)
    }
    
    private func data(with jsonObject: [String: Any?]) -> Data {
        return try! JSONSerialization.data(withJSONObject: jsonObject)
    }
}
