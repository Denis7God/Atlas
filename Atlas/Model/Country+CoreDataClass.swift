//
//  Country+CoreDataClass.swift
//  Atlas
//
//  Created by Denis Godovaniuk on 17.12.2020.
//
//

import Foundation
import CoreData

typealias Countries = [Country]

@objc(Country)
public class Country: NSManagedObject {
    
    public override init(entity: NSEntityDescription, insertInto context: NSManagedObjectContext?) {
        super.init(entity: entity, insertInto: context)
    }
    
    // initializing with network request
    init? (json: [String : String], context: NSManagedObjectContext?) {
        guard let name = json["name"],
              let nativeName = json["nativeName"],
              let alpha2Code = json["alpha2Code"],
              let alpha3Code = json["alpha3Code"]
        else {
            return nil
        }
        
        super.init(entity: NSEntityDescription.entity(forEntityName: String(describing: Country.self), in: MainManagedObjectContext.shared)!, insertInto: context)
        
        self.name = name
        self.nativeName = nativeName
        self.alpha3Code = alpha3Code
        self.emoji = CountriesAndFlags.flagForCountryCode(alpha2Code) ?? ""
    }
}
