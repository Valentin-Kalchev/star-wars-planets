//
//  PlanetsUIComposer.swift
//  Planets
//
//  Created by Valentin Kalchev (Zuant) on 25/01/21.
//

import UIKit
import Planets
import CoreData

public final class PlanetsUIComposer {
    private init() {}
    
    public static func viewController(with loader: FeedLoader) -> PlanetsViewController {
        let planetsViewController = PlanetsViewController.make()
         
        planetsViewController.onViewDidLoad = { [weak planetsViewController] in
            loader.load(from: URL(string: "https://swapi.dev/api/planets")!) { (result) in
                switch result {
                case let .success(page):
                    DispatchQueue.main.async {
                        planetsViewController?.tableModel = page.planets.map { PlanetCellController(viewModel: PlanetViewModel(planet: $0))}
                    }
                    
                case .failure:
                    DispatchQueue.main.async {
                        planetsViewController?.tableModel = []
                    }
                }
            }
        }
        
        return planetsViewController
    }
} 

private extension PlanetsViewController {
    static func make() -> PlanetsViewController {
        let bundle = Bundle(for: PlanetsViewController.self)
        let storyboard = UIStoryboard(name: "Main", bundle: bundle)
        let planetsViewController = storyboard.instantiateInitialViewController() as! PlanetsViewController
        return planetsViewController
    }
}
