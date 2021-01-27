//
//  LocalFeedPlanet.swift
//  Planets
//
//  Created by Valentin Kalchev (Zuant) on 25/01/21.
//

import Foundation

public struct LocalFeedPlanet: Equatable {
    public let name: String?
    public let rotationPeriod: Int?
    public let orbitalPeriod: Int?
    public let diameter: Int?
    public let climate: String?
    public let gravity: String?
    public let terrain: String?
    public let surfaceWater: String?
    public let population: Int?
    public let residents: [URL]?
    public let films: [URL]?
    public let created: Date
    public let edited: Date?
    public let url: URL
    
    public init(name: String? = nil,
         rotationPeriod: Int? = nil,
         orbitalPeriod: Int? = nil,
         diameter: Int? = nil,
         climate: String? = nil,
         gravity: String? = nil,
         terrain: String? = nil,
         surfaceWater: String? = nil,
         population: Int? = nil,
         residents: [URL]? = nil,
         films: [URL]? = nil,
         created: Date,
         edited: Date?,
         url: URL) {
        
        self.name = name
        self.rotationPeriod = rotationPeriod
        self.orbitalPeriod = orbitalPeriod
        self.diameter = diameter
        self.climate = climate
        self.gravity = gravity
        self.terrain = terrain
        self.surfaceWater = surfaceWater
        self.population = population
        self.residents = residents
        self.films = films
        self.created = created
        self.edited = edited
        self.url = url
    }
}
