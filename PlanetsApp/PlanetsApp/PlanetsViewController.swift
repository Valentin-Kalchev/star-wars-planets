//
//  PlanetsViewController.swift
//  Planets
//
//  Created by Valentin Kalchev (Zuant) on 25/01/21.
//

import UIKit
import Planets

public class PlanetsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet private var tableView: UITableView! 
    
    var tableModel: [PlanetCellController] = [] {
        didSet {
            self.tableView.reloadData() 
        }
    }
    
    var onViewDidLoad: (() -> Void)? 
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        onViewDidLoad?()
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return tableModel[indexPath.row].view(tableView: tableView)
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableModel.count
    }
}
