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
        
        // when scene is launched, start fetching CountriesAndFlags data from data.json
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // hiding the navigationBar for this scene
        navigationController?.setNavigationBarHidden(true, animated: animated)
        
        // start observing for network reachability
        NotificationCenter.default.addObserver(self, selector: #selector(reachabilityChanged(note:)), name: .reachabilityChanged, object: Reachability.shared)
        do{
            try Reachability.shared.startNotifier()
        }catch{
            print("could not start reachability notifier")
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // throwing back the navigationBar while moving forward in NavigationController
        navigationController?.setNavigationBarHidden(false, animated: animated)
        
        // stop following notifications
        Reachability.shared.stopNotifier()
        NotificationCenter.default.removeObserver(self, name: .reachabilityChanged, object: Reachability.shared)
    }
    
    // MARK: - Network reachability check
    
    // show alert if network state has changed and throw alert if connection is unavailable
    @objc func reachabilityChanged(note: Notification) {
        
        let reachability = note.object as! Reachability
        
        switch reachability.connection {
        case .unavailable:
            let alert = UIAlertController(title: "Atlas App could not connect to the server.", message: "\nMake sure your network connection is active.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Okay", style: .default))
            self.present(alert, animated: true)
        default:
            break
        }
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
