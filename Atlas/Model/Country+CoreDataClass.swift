//
//  Country+CoreDataClass.swift
//  Atlas
//
//  Created by Denis Godovaniuk on 17.12.2020.
//
//

import Foundation
import CoreData

@objc(Country)
public class Country: NSManagedObject {
    
    public override init(entity: NSEntityDescription, insertInto context: NSManagedObjectContext?) {
        super.init(entity: entity, insertInto: context)
    }

    init(countryModel: CountryModel) {
        let context = MainManagedObjectContext.shared
        super.init(entity: NSEntityDescription.entity(forEntityName: String(describing: Country.self), in: context)!, insertInto: context)
        self.name = countryModel.name
        self.nativeName = countryModel.nativeName
        self.alpha3Code = countryModel.alpha3Code
        self.emoji = countryModel.emoji
    }
}
