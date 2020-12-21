//
//  CountryInfo.swift
//  Atlas
//
//  Created by Denis Godovaniuk on 10.12.2020.
//

import Foundation

struct CountryInfo {
    
    let capital: String
    let currencies: [String]
    let languages: [String]
    let borders: [String]
    let latitude: Float
    let longitude: Float
    
    enum CodingKeys: String, CodingKey {
        case capital = "capital"
        case currencies = "currencies"
        case languages = "languages"
        case borders = "borders"
        case coordinates = "latlng"
        case latitude = "latitude"
        case longitude = "longitude"
        case name = "name"
    }
    
    // initializing with network request
    init? (json: [String : Any]) {
        guard let capital = json[CodingKeys.capital.rawValue] as? String,
              let currenciesJSON = json[CodingKeys.currencies.rawValue] as? [[String : String]],
              let languagesJSON = json[CodingKeys.languages.rawValue] as? [[String : String]],
              let coordinates = json[CodingKeys.coordinates.rawValue] as? [Double],
              coordinates.count == 2,
              let borders = json[CodingKeys.borders.rawValue] as? [String]
        else {
            return nil
        }
        
        var currencies = [String]()
        for element in currenciesJSON {
            guard let currency = element[CodingKeys.name.rawValue] else { return nil }
            currencies.append(currency)
        }
        
        var languages = [String]()
        for element in languagesJSON {
            guard let language = element[CodingKeys.name.rawValue] else { return nil }
            languages.append(language)
        }
        
        self.capital = capital
        self.currencies = currencies
        self.languages = languages
        self.borders = borders
        self.latitude = Float(coordinates[0])
        self.longitude = Float(coordinates[1])
    }
}
