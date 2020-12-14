//
//  [String].swift
//  Atlas
//
//  Created by Denis Godovaniuk on 09.12.2020.
//

import Foundation

typealias Regions = [String]

extension Regions {
    init?(json: [[String : String]]) {
        var regions = [String]()
        for element in json {
            if let region = element["region"] {
                if region == "" || region == " " {
                    continue
                }
                if regions.contains(region) {
                    continue
                } else {
                    regions.append(region)
                }
            } else {
                return nil
            }
        }
        self = regions
    }
}
