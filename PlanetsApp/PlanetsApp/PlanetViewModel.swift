//
//  PlanetViewModel.swift
//  PlanetsApp
//
//  Created by Valentin Kalchev (Zuant) on 25/01/21.
//

import Foundation
import Planets

class PlanetViewModel {
    private let planet: Planet
    init(planet: Planet) {
        self.planet = planet
    }
    
    var name: String {
        if let name = planet.name {
            return name
        } else {
            return "Unknown"
        }
    }
    
    var rotationPeriod: String? {
        if let rotationPeriod = planet.rotationPeriod {
            return "Rotation Period: \(rotationPeriod) years"
            
        } else {
            return nil
        }
    }
    
    var orbitalPeriod: String? {
        if let orbitalPeriod = planet.orbitalPeriod {
            return "Orbital Period: \(orbitalPeriod) years"
        } else {
            return nil
        }
    }
    
    var diameter: String? {
        if let diameterLabel = planet.diameter {
            return "Diameter: \(diameterLabel) miles"
        } else {
            return nil
        }
    }
    
    var climate: String? {
        if let climate = planet.climate {
            return "Climate: \(climate)"
        } else {
            return nil
        }
    }
    
    var gravity: String? {
        if let gravity = planet.gravity {
            return "Gravity: \(gravity)"
        } else {
            return nil
        }
    }
    
    var terrain: String? {
        if let terrain = planet.terrain {
            return "Terrain: \(terrain)"
        } else {
            return nil
        }
    }
    
    var surfaceWater: String? {
        if let surfaceWater = planet.surfaceWater {
            return "Surface Water: \(surfaceWater)"
        } else {
            return nil
        }
    }
    
    var population: String? {
        if let population = planet.population {
            return "Population: \(population)"
        } else {
            return nil
        }
    }
}
