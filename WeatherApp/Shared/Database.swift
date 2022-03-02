//
//  Database.swift
//  WeatherApp (iOS)
//
//  Created by Domagoj Bunoza on 02.03.2022..
//

import Foundation

class Database {
    
    let defaults = UserDefaults.standard
    
    let encoder = JSONEncoder()
    let decoder = JSONDecoder()
        
    func fetchCurrentCity() -> GeoItem {
        var currentCity = GeoItem(name: "Vienna", lat: "48.20849", lng: "16.37208")
        do {
            guard let decoded = defaults.data(forKey: "geo")
            else {
                return currentCity
            }
            currentCity = try decoder.decode(GeoItem.self, from: decoded)
        }
        catch {}
        print(currentCity.name)
        return currentCity
    }
    
    func storeNewCity(geoItem: GeoItem) {
        let currentCity = geoItem
        do {
            let data = try encoder.encode(currentCity)
            defaults.set(data, forKey: "geo")
        }
        catch{}
        print(currentCity.name)
    }
}
