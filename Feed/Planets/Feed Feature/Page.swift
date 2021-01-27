//
//  Page.swift
//  Planets
//
//  Created by Valentin Kalchev (Zuant) on 26/01/21.
//

import Foundation

public struct Page: Equatable {
   public let next: URL?
   public let previous: URL?
   public let planets: [Planet]
   
   public init(next: URL?, previous: URL?, planets: [Planet]) {
       self.next = next
       self.previous = previous
       self.planets = planets
   }
}
