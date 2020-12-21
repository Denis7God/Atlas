//
//  FavoritesTableViewController.swift
//  Atlas
//
//  Created by Denis Godovaniuk on 16.12.2020.
//

import UIKit
import CoreData

class FavoritesTableViewController: UITableViewController, NSFetchedResultsControllerDelegate {
    
    lazy var fetchedResultsController: NSFetchedResultsController<Country> = {
        let request = NSFetchRequest<Country>(entityName: String(describing: Country.self))
        request.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
        let context = MainManagedObjectContext.shared
        
        return NSFetchedResultsController<Country>(fetchRequest: request, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        do {
            try fetchedResultsController.performFetch()
        } catch {
            assertionFailure("An error '\(error)' occurred while fetching data from database")
        }
        
        tableView.register(UINib(nibName: String(describing: CountryTableViewCell.self), bundle: nil), forCellReuseIdentifier: String(describing: CountryTableViewCell.self))
        
        fetchedResultsController.delegate = self
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.reloadData()
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fetchedResultsController.sections?[section].numberOfObjects ?? 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: CountryTableViewCell.self), for: indexPath) as! CountryTableViewCell
        cell.country = fetchedResultsController.object(at: indexPath)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "Show Detail", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "Show Detail" {
            let destinationVC = segue.destination as! CountryInfoViewController
            if let indexPathForSelectedCountry = tableView.indexPathForSelectedRow {
                destinationVC.country = fetchedResultsController.object(at: indexPathForSelectedCountry)
            }
        }
    }
}
