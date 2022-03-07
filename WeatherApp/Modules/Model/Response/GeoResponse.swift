//
//  GeoResponse.swift
//  WeatherApp
//
//  Created by Domagoj Bunoza on 01.03.2022..
//

import Foundation

// MARK: - Welcome
struct GeoResponse: Codable {
    let geonames: [Geoname]
}
enum CodingKeys: String, CodingKey {
    case GeoResponse = "Welcome"
}

// MARK: - Geoname
struct Geoname: Codable {
    let lng: String
    let name: String
    let lat: String

    enum CodingKeys: String, CodingKey {
        case name, lat, lng
    }
}
