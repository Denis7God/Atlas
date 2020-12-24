//
//  Country+CoreDataClass.swift
//  Atlas
//
//  Created by Denis Godovaniuk on 21.12.2020.
//
//

import Foundation
import CoreData

typealias Countries = [Country]

@objc(Country)
public class Country: NSManagedObject {
    
    enum CodingKeys: String, CodingKey {
        case name = "name"
        case nativeName = "nativeName"
        case code = "alpha3Code"
        case codeShort = "alpha2Code"
    }
    
    public override init(entity: NSEntityDescription, insertInto context: NSManagedObjectContext?) {
        super.init(entity: entity, insertInto: context)
    }
    
    // initializing with network request
    init? (json: [String : String], context: NSManagedObjectContext?) {
        guard let name = json[CodingKeys.name.rawValue],
              let nativeName = json[CodingKeys.nativeName.rawValue],
              let codeShort = json[CodingKeys.codeShort.rawValue],
              let code = json[CodingKeys.code.rawValue]
        else {
            return nil
        }
        
        super.init(entity: NSEntityDescription.entity(forEntityName: String(describing: Country.self), in: MainManagedObjectContext.shared)!, insertInto: context)
        
        self.name = name
        self.nativeName = nativeName
        self.code = code
        self.flagEmoji = CountriesAndFlags.flagForCountryCode(codeShort) ?? ""
    }
}
