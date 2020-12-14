//
//  CountriesTableViewController.swift
//  Atlas
//
//  Created by Denis Godovaniuk on 09.12.2020.
//

import UIKit

class CountriesTableViewController: UITableViewController {
    
    var region = String()
    
    var countriesList = Countries()

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = region
        
        tableView.register(UINib(nibName: String(describing: CountryTableViewCell.self), bundle: nil), forCellReuseIdentifier: String(describing: CountryTableViewCell.self))
        
        DataRequest.fetchCountries(forRegion: region.lowercased()) { result in
            switch result {
            case .success(let countries):
                self.countriesList = countries
                self.tableView.reloadData()
            case .failure(let error):
                print(error)
            }
        }
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return countriesList.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: CountryTableViewCell.self), for: indexPath) as! CountryTableViewCell
        cell.country = countriesList[indexPath.row]
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "Show Detail", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "Show Detail" {
            let destinationVC = segue.destination as! CountryInfoViewController
            if let indexPathForSelectedCountry = tableView.indexPathForSelectedRow {
                destinationVC.country = countriesList[indexPathForSelectedCountry.row]
            }
        }
    }
}
