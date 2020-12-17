//
//  DataRequest.swift
//  Atlas
//
//  Created by Denis Godovaniuk on 09.12.2020.
//

import Foundation
import Alamofire

struct DataRequest {
    
    static private let requestBody = "https://restcountries.eu/rest/v2/"
    static private let allRegionsRequestParams = "all?fields=region"
    static private let countriesRequestParams = "?fields=name;nativeName;alpha2Code;alpha3Code"
    static private let coiuntryInfoRequestParams = "?fields=capital;latlng;borders;currencies;languages"
    static private let regionSubdirectory = "region/"
    static private let codeSubdirectory = "alpha/"
    static private let nameSubdirectory = "name/"
    
    static func fetchAllRegions(completion: @escaping(Result<Regions, AFError>) -> Void) {
        AF.request(requestBody + allRegionsRequestParams).responseJSON { response in
            switch response.result {
            case .failure(let error):
                completion(.failure(error))
            case .success(let json as [[String : String]]):
                if let regions = Regions(json: json) {
                    completion(.success(regions))
                } else {
                    completion(.failure(AFError.responseSerializationFailed(reason: .invalidEmptyResponse(type: "region"))))
                }
            default:
                fatalError("fetchAllRegions response is unreachable")
            }
        }
    }
    
    static func fetchCountries (forRegion region: String, completion: @escaping(Result<Countries, AFError>) -> Void) {
        var countries = Countries()
        AF.request(requestBody + regionSubdirectory + region + countriesRequestParams).responseJSON { response in
            switch response.result {
            case .failure(let error):
                completion(.failure(error))
            case .success(let json as [[String : String]]):
                for countryJSON in json {
                    if let country = CountryModel(json: countryJSON) {
                        countries.append(country)
                        if countries.count == json.count {
                            completion(.success(countries))
                        }
                    } else {
                        completion(.failure(AFError.responseSerializationFailed(reason: .invalidEmptyResponse(type: "countries"))))
                    }
                }
            default:
                fatalError("fetchCountries response is unreachable")
            }
        }
    }
    
    static func fetchCountries (forCodes codes: [String], completion: @escaping(Result<Countries, AFError>) -> Void) {
        var countries = Countries()
        for code in codes {
            AF.request(requestBody + codeSubdirectory + code + countriesRequestParams).responseJSON { response in
                switch response.result {
                case .failure(let error):
                    completion(.failure(error))
                case .success(let json as [String : String]):
                    if let country = CountryModel(json: json) {
                        countries.append(country)
                        if countries.count == codes.count {
                            completion(.success(countries))
                        }
                    } else {
                        completion(.failure(AFError.responseSerializationFailed(reason: .invalidEmptyResponse(type: "countries"))))
                    }
                default:
                    fatalError("fetchCountries response is unreachable")
                }
            }
        }
    }
    
    static func fetchCountries (forName name: String, completion: @escaping(Result<Countries, AFError>) -> Void) {
        var countries = Countries()
        AF.request(requestBody + nameSubdirectory + name.lowercased() + countriesRequestParams).responseJSON { response in
            switch response.result {
            case .failure(let error):
                completion(.failure(error))
            case .success(let json as [[String : String]]):
                for countryJSON in json {
                    if let country = CountryModel(json: countryJSON) {
                        countries.append(country)
                        if countries.count == json.count {
                            completion(.success(countries))
                        }
                    } else {
                        completion(.failure(AFError.responseSerializationFailed(reason: .invalidEmptyResponse(type: "countries"))))
                    }
                }
            default:
                print("fetchCountries response is unreachable")
            }
        }
    }
    
    static func fetchCountryInfo (forCountryCode countryCode: String, completion: @escaping(Result<CountryInfo, AFError>) -> Void) {
        AF.request(requestBody + codeSubdirectory + countryCode + coiuntryInfoRequestParams).responseJSON { response in
            switch response.result {
            case .failure(let error):
                completion(.failure(error))
            case .success(let json as [String : Any]):
                if let countryInfo = CountryInfo(json: json) {
                        completion(.success(countryInfo))
                } else {
                    completion(.failure(AFError.responseSerializationFailed(reason: .invalidEmptyResponse(type: "countryInfo"))))
                }
            default:
                fatalError("fetchCountries response is unreachable")
            }
        }
    }
    
}
