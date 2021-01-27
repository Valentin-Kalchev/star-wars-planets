//
//  ManagedFeedPlanet.swift
//  Planets
//
//  Created by Valentin Kalchev (Zuant) on 25/01/21.
//

import CoreData 

extension ManagedFeedPlanet {
    var local: LocalFeedPlanet {
        return LocalFeedPlanet(name: name, rotationPeriod: Int(rotationPeriod), orbitalPeriod: Int(orbitalPeriod), diameter: Int(diameter), climate: climate, gravity: gravity, terrain: terrain, surfaceWater: surfaceWater, population: Int(population), residents: residents, films: films, created: created!, edited: edited, url: url!)
    }
    
    static func planets(from feed: [LocalFeedPlanet], in context: NSManagedObjectContext) -> NSOrderedSet {
        return NSOrderedSet(array: feed.map {
            let managedFeedPlanet = ManagedFeedPlanet(context: context)
            managedFeedPlanet.name = $0.name
            managedFeedPlanet.rotationPeriod = Int64($0.rotationPeriod ?? 0)
            managedFeedPlanet.orbitalPeriod = Int64($0.orbitalPeriod ?? 0)
            managedFeedPlanet.diameter = Int64($0.diameter ?? 0)
            managedFeedPlanet.climate = $0.climate
            managedFeedPlanet.gravity = $0.gravity
            managedFeedPlanet.terrain = $0.terrain
            managedFeedPlanet.surfaceWater = $0.surfaceWater
            managedFeedPlanet.population = Int64($0.population ?? 0)
            managedFeedPlanet.residents = $0.residents
            managedFeedPlanet.films = $0.films
            managedFeedPlanet.created = $0.created
            managedFeedPlanet.edited = $0.edited
            managedFeedPlanet.url = $0.url
            return managedFeedPlanet
        })
    }
}
