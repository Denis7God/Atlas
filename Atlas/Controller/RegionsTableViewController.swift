//
//  RegionsTableViewController.swift
//  Atlas
//
//  Created by Denis Godovaniuk on 09.12.2020.
//

import UIKit
import Alamofire

class RegionsTableViewController: UITableViewController {

    var regionsList = Regions()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        DispatchQueue.global(qos: .utility).async {
            CountriesAndFlags.fetchJSONData()
        }
        
        DataRequest.fetchAllRegions { result in
            switch result {
            case .success(let regions):
                self.regionsList = regions
                self.tableView.reloadData()
            case .failure(let error):
                print(error)
            }
        }
    }
    
    // hiding navigationBar
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        navigationController?.setNavigationBarHidden(false, animated: animated)

    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return regionsList.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: RegionTableViewCell.self), for: indexPath) as! RegionTableViewCell
        cell.regionNameLabel.text = self.regionsList[indexPath.row]
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "Show Countries", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "Show Countries" {
            let destinationVC = segue.destination as! CountriesTableViewController
            if let indexPathForSelectedRegion = tableView.indexPathForSelectedRow {
                destinationVC.region = regionsList[indexPathForSelectedRegion.row]
            }
        }
    }
}
