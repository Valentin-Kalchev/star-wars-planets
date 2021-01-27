//
//  PlanetCellController.swift
//  PlanetsApp
//
//  Created by Valentin Kalchev (Zuant) on 25/01/21.
//

import UIKit
import Planets

class PlanetCellController {
    private let viewModel: PlanetViewModel
    init(viewModel: PlanetViewModel) {
        self.viewModel = viewModel
    }
    
    func view(tableView: UITableView) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PlanetCell") as! PlanetCell
        
        cell.nameLabel.text = viewModel.name
        
        cell.rotationPeriodLabel.isHidden = (viewModel.rotationPeriod == nil)
        cell.rotationPeriodLabel.text = viewModel.rotationPeriod
        
        cell.orbitalPeriodLabel.isHidden = (viewModel.orbitalPeriod == nil)
        cell.orbitalPeriodLabel.text = viewModel.orbitalPeriod
        
        cell.diameterLabel.isHidden = (viewModel.diameter == nil)
        cell.diameterLabel.text = viewModel.diameter
        
        cell.climateLabel.isHidden = (viewModel.climate == nil)
        cell.climateLabel.text = viewModel.climate
        
        cell.gravityLabel.isHidden = (viewModel.gravity == nil)
        cell.gravityLabel.text = viewModel.gravity
        
        cell.terrainLabel.isHidden = (viewModel.terrain == nil)
        cell.terrainLabel.text = viewModel.terrain
        
        cell.surfaceWaterLabel.isHidden = (viewModel.surfaceWater == nil)
        cell.surfaceWaterLabel.text = viewModel.surfaceWater
        
        cell.populationLabel.isHidden = (viewModel.population == nil)
        cell.populationLabel.text = viewModel.population
        
        return cell
    }
}
