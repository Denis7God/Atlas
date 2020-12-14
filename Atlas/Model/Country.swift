//
//  Country.swift
//  Atlas
//
//  Created by Denis Godovaniuk on 09.12.2020.
//

import Foundation

typealias Countries = [Country]

struct Country {
    
    let name: String
    let nativeName: String
    let emoji: String?
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
        self.emoji = CountriesAndFlags.flagForCountryCode(alpha2Code)
    }
}
