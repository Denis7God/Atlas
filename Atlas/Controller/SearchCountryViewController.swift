//
//  SearchCountryViewController.swift
//  Atlas
//
//  Created by Denis Godovaniuk on 11.12.2020.
//

import UIKit

class SearchCountryViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate, UITextFieldDelegate {

    var countriesList = Countries() {
        didSet {
            tableView.reloadData()
        }
    }
    
    @IBOutlet var searchBar: UISearchBar!
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
  
        searchBar.delegate = self
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: String(describing: CountryTableViewCell.self), bundle: nil), forCellReuseIdentifier: String(describing: CountryTableViewCell.self))
        tableView.becomeFirstResponder()
        
        navigationItem.titleView = searchBar
    }
    
    // MARK: - TableView Data Source
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return countriesList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: CountryTableViewCell.self), for: indexPath) as! CountryTableViewCell
        cell.country = countriesList[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "Show Detail", sender: self)
    }
    
    // MARK: - Segueing to CountryInfo
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "Show Detail" {
            let destinationVC = segue.destination as! CountryInfoViewController
            if let indexPathForSelectedCountry = tableView.indexPathForSelectedRow {
                destinationVC.country = countriesList[indexPathForSelectedCountry.row]
            }
        }
    }
    
    // MARK: - SearchBar Delegate
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        countriesList.removeAll()
        DataRequest.fetchCountries(forSearchName: searchText) { result in
            switch result {
            case .success(let countries):
                self.countriesList = countries
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        searchBar.endEditing(true)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.endEditing(true)
    }
}
