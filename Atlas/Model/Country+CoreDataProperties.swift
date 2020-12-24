//
//  Country+CoreDataProperties.swift
//  Atlas
//
//  Created by Denis Godovaniuk on 21.12.2020.
//
//

import Foundation
import CoreData


extension Country {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Country> {
        return NSFetchRequest<Country>(entityName: "Country")
    }

    @NSManaged public var code: String
    @NSManaged public var flagEmoji: String
    @NSManaged public var name: String
    @NSManaged public var nativeName: String

}

extension Country : Identifiable {

}
