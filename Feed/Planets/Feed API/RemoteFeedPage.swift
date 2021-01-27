//
//  RemoteFeedPage.swift
//  Planets
//
//  Created by Valentin Kalchev (Zuant) on 26/01/21.
//

import Foundation
 
struct RemoteFeedPage: Decodable {
    let next: String?
    let previous: String?
    let results: [RemoteFeedPlanet]?
}
