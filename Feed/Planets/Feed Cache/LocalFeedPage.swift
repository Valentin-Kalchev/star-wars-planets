//
//  LocalFeedPage.swift
//  Planets
//
//  Created by Valentin Kalchev (Zuant) on 26/01/21.
//

import Foundation

public struct LocalFeedPage: Equatable {
    public let next: URL?
    public let previous: URL?
    public let planets: [LocalFeedPlanet]
    
    public init(next: URL?, previous: URL?, planets: [LocalFeedPlanet]) {
        self.next = next
        self.previous = previous
        self.planets = planets
    }
}
