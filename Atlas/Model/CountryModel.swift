//
//  CountryModel.swift
//  Atlas
//
//  Created by Denis Godovaniuk on 17.12.2020.
//

import Foundation

typealias Countries = [CountryModel]

struct CountryModel {
    
    let name: String
    let nativeName: String
    let emoji: String
    let alpha3Code: String
    
    init? (json: [String : String]) {
        guard let name = json["name"],
              let nativeName = json["nativeName"],
              let alpha2Code = json["alpha2Code"],
              let alpha3Code = json["alpha3Code"]
        else {
            return nil
        }
        
        self.name = name
        self.nativeName = nativeName
        self.alpha3Code = alpha3Code
        self.emoji = CountriesAndFlags.flagForCountryCode(alpha2Code) ?? ""
    }
    
    init(country: Country) {
        self.name = country.name ?? ""
        self.nativeName = country.nativeName ?? ""
        self.alpha3Code = country.alpha3Code ?? ""
        self.emoji = country.emoji ?? ""
    }
}
