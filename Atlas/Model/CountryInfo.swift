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

    init? (json: [String : Any]) {
        guard let capital = json["capital"] as? String,
              let currenciesJSON = json["currencies"] as? [[String : String]],
              let languagesJSON = json["languages"] as? [[String : String]],
              let latlng = json["latlng"] as? [Double],
              latlng.count == 2,
              let borders = json["borders"] as? [String]
        else {
            return nil
        }
        
        var currencies = [String]()
        for element in currenciesJSON {
            guard let currency = element["name"] else { return nil }
            currencies.append(currency)
        }
        
        var languages = [String]()
        for element in languagesJSON {
            guard let language = element["name"] else { return nil }
            languages.append(language)
        }
        
        self.capital = capital
        self.currencies = currencies
        self.languages = languages
        self.borders = borders
        self.latitude = Float(latlng[0])
        self.longitude = Float(latlng[1])
    }
}
