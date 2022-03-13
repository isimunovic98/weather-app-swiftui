//
//  SettingsScreenDomainItem.swift
//  WeatherApp (iOS)
//
//  Created by Domagoj Bunoza on 12.03.2022..
//

import Foundation

struct SettingsScreenDomainItem {
    var cities : [GeoItem]
    var humidity : Bool
    var pressure : Bool
    var wind : Bool
    
    init() {
        self.cities = []
        self.humidity = true
        self.pressure = true
        self.wind = true
    }
    
    init(cities: [GeoItem], humidity: Bool, pressure: Bool, wind: Bool) {
        self.cities = cities
        self.humidity = humidity
        self.pressure = pressure
        self.wind = wind
    }
}
