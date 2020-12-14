//
//  CountryinfoViewController.swift
//  Atlas
//
//  Created by Denis Godovaniuk on 09.12.2020.
//

import UIKit
import MapKit

class CountryInfoViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var country: Country?
    var countryInfo: CountryInfo?
    var neighbors = Countries()
    
    @IBOutlet weak var flagLabel: UILabel!
    @IBOutlet weak var capitalLabel: UILabel!
    @IBOutlet weak var currenciesLabel: UILabel!
    @IBOutlet weak var languagesLabel: UILabel!
    
    @IBOutlet weak var capitalStackView: UIStackView!
    
    @IBOutlet weak var mapView: MKMapView!
    
    @IBOutlet weak var noBordersLabel: UILabel!
    @IBOutlet weak var boardsWithLabel: UILabel!
    @IBOutlet weak var neighboringCountriesTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        neighboringCountriesTableView.dataSource = self
        neighboringCountriesTableView.delegate = self
        neighboringCountriesTableView.register(UINib(nibName: String(describing: CountryTableViewCell.self), bundle: nil), forCellReuseIdentifier: String(describing: CountryTableViewCell.self))
        
        navigationItem.title = country?.name
        
        DataRequest.fetchCountryInfo(forCountryCode: country!.alpha3Code) { result in
            switch result {
            case .success(let countryInfo):
                self.countryInfo = countryInfo
                self.configure()
                DataRequest.fetchCountries(forCodes: countryInfo.borders) { result in
                    switch result {
                    case .success(let neighborCountries):
                        self.neighbors = neighborCountries
                        self.neighboringCountriesTableView.reloadData()
                    case .failure(let error):
                        print(error)
                    }
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    private func configure() {
        
        if self.countryInfo?.capital == "" {
            capitalStackView.isHidden = true
        } else {
            self.capitalLabel.text = countryInfo?.capital
        }
        
        if self.countryInfo?.borders.count == 0 {
            self.noBordersLabel.isHidden = false
            self.boardsWithLabel.isHidden = true
            self.neighboringCountriesTableView.isHidden = true
        }
        
        self.flagLabel.text = country?.emoji
        self.currenciesLabel.text = countryInfo?.currencies.joined(separator: ", ")
        self.languagesLabel.text = countryInfo?.languages.joined(separator: ", ")
        if let latitude = countryInfo?.latitude, let longitude = countryInfo?.longitude {
            let center = CLLocationCoordinate2D(latitude: CLLocationDegrees(latitude), longitude: CLLocationDegrees(longitude))
            mapView.setCenter(center, animated: true)
            let annotation = MKPointAnnotation()
            annotation.coordinate = center
            mapView.addAnnotation(annotation)
        }
    }
    
    // MARK: - TableView Data Source
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return neighbors.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: CountryTableViewCell.self), for: indexPath) as! CountryTableViewCell
        cell.country = neighbors[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let newCountryVC = storyboard?.instantiateViewController(withIdentifier: "CountryinfoViewController") as! CountryInfoViewController
        newCountryVC.country = neighbors[indexPath.row]
        self.navigationController?.pushViewController(newCountryVC, animated: true)
    }
}
