//
//  GeoResponse.swift
//  WeatherApp
//
//  Created by Domagoj Bunoza on 01.03.2022..
//

import Foundation

// MARK: - Welcome
struct GeoResponse: Codable {
    let totalResultsCount: Int
    let geonames: [Geoname]
}
enum CodingKeys: String, CodingKey {
    case GeoResponse = "Welcome"
}

// MARK: - Geoname
struct Geoname: Codable {
    let adminCode1, lng: String
    let geonameID: Int
    let toponymName, countryID: String
    let population: Int
    let countryCode, name: String
    let adminCodes1: AdminCodes1
    let countryName, fcodeName, adminName1, lat: String
    let fcode: String

    enum CodingKeys: String, CodingKey {
        case adminCode1, lng
        case geonameID = "geonameId"
        case toponymName
        case countryID = "countryId"
        case population, countryCode, name , adminCodes1, countryName, fcodeName, adminName1, lat, fcode
    }
}

// MARK: - AdminCodes1
struct AdminCodes1: Codable {
    let iso31662: String

    enum CodingKeys: String, CodingKey {
        case iso31662 = "ISO3166_2"
    }
}

enum FclName: String, Codable {
    case cityVillage = "city, village,..."
    case parksArea = "parks,area, ..."
}
