//
//  CountryinfoViewController.swift
//  Atlas
//
//  Created by Denis Godovaniuk on 09.12.2020.
//

import UIKit
import MapKit
import CoreData

class CountryInfoViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var country: CountryModel!
    var countryInfo: CountryInfo!
    var neighbors = Countries()
    
    var countryIsFavorite = false {
        willSet {
            favoriteBarButton.image = UIImage(systemName: newValue ? "star.fill" : "star")
        }
    }
    
    @IBOutlet weak var flagLabel: UILabel!
    @IBOutlet weak var capitalLabel: UILabel!
    @IBOutlet weak var currenciesLabel: UILabel!
    @IBOutlet weak var languagesLabel: UILabel!
    
    @IBOutlet weak var capitalStackView: UIStackView!
    
    @IBOutlet weak var mapView: MKMapView!
    
    @IBOutlet weak var noBordersLabel: UILabel!
    @IBOutlet weak var boardsWithLabel: UILabel!
    @IBOutlet weak var neighboringCountriesTableView: UITableView!
    
    @IBOutlet weak var favoriteBarButton: UIBarButtonItem!
    
    @IBAction func favoriteBarButtonPressed(_ sender: UIBarButtonItem) {
        let context = MainManagedObjectContext.shared
        if countryIsFavorite {
            // delete from DB
            let request = NSFetchRequest<Country>(entityName: String(describing: Country.self))
            request.predicate = NSPredicate(format: "name == %@", country.name)
            let resultArray = try? context.fetch(request)
            if let result = resultArray?[0] {
                context.delete(result)
                try? context.save()
            }
        } else {
            // add to DB
            let newCountryObject = Country(countryModel: country)
            context.insert(newCountryObject)
            try? context.save()
        }
        countryIsFavorite = !countryIsFavorite
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        neighboringCountriesTableView.dataSource = self
        neighboringCountriesTableView.delegate = self
        neighboringCountriesTableView.register(UINib(nibName: String(describing: CountryTableViewCell.self), bundle: nil), forCellReuseIdentifier: String(describing: CountryTableViewCell.self))
        
        navigationItem.title = country.name
        
        let context = MainManagedObjectContext.shared
        let request = NSFetchRequest<Country>(entityName: String(describing: Country.self))
        request.predicate = NSPredicate(format: "name == %@", country.name)
        let resultArray = try? context.fetch(request)
        if let result = resultArray, !result.isEmpty {
            countryIsFavorite = true
        }
        
        DataRequest.fetchCountryInfo(forCountryCode: country.alpha3Code) { result in
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
        
        if self.countryInfo.capital == "" {
            capitalStackView.isHidden = true
        } else {
            self.capitalLabel.text = countryInfo?.capital
        }
        
        if self.countryInfo.borders.count == 0 {
            self.noBordersLabel.isHidden = false
            self.boardsWithLabel.isHidden = true
            self.neighboringCountriesTableView.isHidden = true
        }
        
        self.flagLabel.text = country.emoji
        self.currenciesLabel.text = countryInfo.currencies.joined(separator: ", ")
        self.languagesLabel.text = countryInfo.languages.joined(separator: ", ")
        let center = CLLocationCoordinate2D(latitude: CLLocationDegrees(countryInfo.latitude), longitude: CLLocationDegrees(countryInfo.longitude))
        mapView.setCenter(center, animated: true)
        let annotation = MKPointAnnotation()
        annotation.coordinate = center
        mapView.addAnnotation(annotation)
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
