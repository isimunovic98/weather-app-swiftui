//
//  UserDefaults+Extensions.swift
//  WeatherApp (iOS)
//
//  Created by Domagoj Bunoza on 20.03.2022..
//

import Foundation

extension UserDefaults {
    @objc var currentCity: GeoItem {
        get {
            let decoder = JSONDecoder()
            var currentCity = [GeoItem]()
            let defaultGeoItem = GeoItem(name: "Vienna", lat: "48.20849", lng: "16.37208")
            do {
                guard let decoded = data(forKey: "geo")
                else {
                    return defaultGeoItem
                }
                currentCity = try decoder.decode([GeoItem].self, from: decoded)
                if currentCity.count == 0 {
                    currentCity.append(defaultGeoItem)
                }
            }
            catch {
                return defaultGeoItem
            }
            return currentCity[0]
        }
    }
}
