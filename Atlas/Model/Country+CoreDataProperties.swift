//
//  Country+CoreDataProperties.swift
//  Atlas
//
//  Created by Denis Godovaniuk on 17.12.2020.
//
//

import Foundation
import CoreData


extension Country {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Country> {
        return NSFetchRequest<Country>(entityName: String(describing: Country.self))
    }

    @NSManaged public var alpha3Code: String
    @NSManaged public var emoji: String
    @NSManaged public var name: String
    @NSManaged public var nativeName: String

}

extension Country : Identifiable {

}
