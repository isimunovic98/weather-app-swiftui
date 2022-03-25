//
//  Database.swift
//  WeatherApp (iOS)
//
//  Created by Domagoj Bunoza on 02.03.2022..
//

import Foundation
import Combine

class UserDefaultsManager {
    
    let defaults = UserDefaults.standard
    
    let encoder = JSONEncoder()
    let decoder = JSONDecoder()
    
    func fetchCurrentCityObservable() -> AnyPublisher<GeoItem, Never> {
        return defaults.publisher(for: \.currentCity).eraseToAnyPublisher()
    }
    
    func fetchCurrentCity() -> GeoItem {
        var currentCity = [GeoItem]()
        let defaultGeoItem = GeoItem(
            name: "Vienna",
            lat: "48.20849",
            lng: "16.37208"
        )
        do {
            guard let decoded = defaults.data(forKey: "geo")
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
    
    func fetchCityHistory() -> [GeoItem] {
        var cityHistory = [GeoItem]()
        do {
            guard let decoded = defaults.data(forKey: "geo")
            else {
                return cityHistory
            }
            cityHistory = try decoder.decode([GeoItem].self, from: decoded)
        }
        catch {}
        return cityHistory
    }
    
    func storeNewCity(geoItem: GeoItem) {
        let currentCity = geoItem
        var cityHistory = fetchCityHistory()
        cityHistory = cityHistory.filter {
            $0.name != currentCity.name
        }
        cityHistory.insert(currentCity, at: 0)
        do {
            let data = try encoder.encode(cityHistory)
            defaults.set(data, forKey: "geo")
        }
        catch{}
    }
    
    func storeSettingsModel(settings: SettingsScreenDomainItem) {
        do {
            let data = try encoder.encode(settings)
            defaults.set(data, forKey: "settings")
        }
        catch{}
    }
    
    func fetchSettingsModel() -> SettingsScreenDomainItem {
        let defaultSettings = SettingsScreenDomainItem(
            cities: fetchCityHistory(),
            humidity: true,
            pressure: true,
            wind: true,
            measuringUnit: "Metric"
        )
        do {
            guard let decoded = defaults.data(forKey: "settings")
            else {
                return defaultSettings
            }
            return try decoder.decode(SettingsScreenDomainItem.self, from: decoded)
        }
        catch {
            return defaultSettings
        }
    }
    
    func removeCity(geoItem: GeoItem) {
        var cityHistory = fetchCityHistory()
        cityHistory = cityHistory.filter {
            $0.name != geoItem.name
        }
        do {
            let data = try encoder.encode(cityHistory)
            defaults.set(data, forKey: "geo")
        }
        catch{}
    }
}
