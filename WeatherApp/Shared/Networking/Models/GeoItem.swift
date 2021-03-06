//
//  GeoItem.swift
//  WeatherApp (iOS)
//
//  Created by Domagoj Bunoza on 02.03.2022..
//

import Foundation

class GeoItem: NSObject, Codable {
    let name: String
    let lat: String
    let lng: String
    
    init(name: String, lat: String, lng: String) {
        self.name = name
        self.lat = lat
        self.lng = lng
    }
}
