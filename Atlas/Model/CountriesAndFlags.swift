//
//  CountriesAndFlags.swift
//  Atlas
//
//  Created by Denis Godovaniuk on 10.12.2020.
//

import Foundation

struct CountriesAndFlags {
    
    private static var dictionary = [String : String]()
    
    static func flagForCountryCode(_ code: String) -> String? {
        return dictionary[code]
    }
    
    static func fetchJSONData() {
        if let path = Bundle.main.path(forResource: "data", ofType: "json") {
            do {
                let url = URL(fileURLWithPath: path)
                let data = try Data(contentsOf: url)
                let jsonResult = try JSONSerialization.jsonObject(with: data, options: [])
                if let json = jsonResult as? [[String : Any]] {
                    for element in json {
                        if let countryCode = element["code"] as? String, let emoji = element["emoji"] as? String {
                            dictionary[countryCode] = emoji
                        }
                    }
                }
            } catch {
                print(error)
            }
        }
    }
}
