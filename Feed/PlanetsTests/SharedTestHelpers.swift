//
//  SharedTestHelpers.swift
//  PlanetsTests
//
//  Created by Valentin Kalchev (Zuant) on 25/01/21.
//

import Foundation
import Planets

func anyNSError() -> NSError {
    return NSError(domain: "any error", code: 0)
}

func pageFeed() -> (model: Page, local: LocalFeedPage) { 
    let planets = planetsFeed()
    let model = Page(next: URL(string: "http://next-url.com")!, previous: URL(string: "http://previous-url.com")!, planets: planets.models)
    
    let local = LocalFeedPage(next: model.next, previous: model.previous, planets: planets.local)
    return (model, local)
}

func planetsFeed() -> (models: [Planet], local: [LocalFeedPlanet]) {
    let models = [anyPlanet(), anyPlanet()]
    let local = models.map {
        LocalFeedPlanet(name: $0.name, rotationPeriod: $0.rotationPeriod, orbitalPeriod: $0.orbitalPeriod, diameter: $0.diameter, climate: $0.climate, gravity: $0.gravity, terrain: $0.terrain, surfaceWater: $0.surfaceWater, population: $0.population, residents: $0.residents, films: $0.films, created: $0.created, edited: $0.edited, url: $0.url)
    }
    
    return (models, local)
}

func anyPlanet() -> Planet {
    return Planet(name: "Tatooine", created: Date(), edited: Date(), url: anyURL())
}

func anyURL() -> URL {
    return URL(string: "http://a-url.com")!
}
