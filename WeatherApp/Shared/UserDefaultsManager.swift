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
    
    func fetchHumidity() -> Bool {
        return defaults.bool(forKey: "humidity")
    }
    
    func fetchPressure() -> Bool {
        return defaults.bool(forKey: "pressure")
    }
    
    func fetchWind() -> Bool {
        return defaults.bool(forKey: "wind")
    }
    
    func storeHumidity(value: Bool) {
        defaults.set(value, forKey: "humidity")
    }
    
    func storePressure(value: Bool) {
        defaults.set(value, forKey: "pressure")
    }
    
    func storeWind(value: Bool) {
        defaults.set(value, forKey: "wind")
    }
    
    func fetchMeasuringUnit() -> String {
        var measuringUnit : String
        do {
            guard let decoded = defaults.data(forKey: "unit")
            else {
                return "Metric"
            }
            measuringUnit = try decoder.decode(String.self, from: decoded)
        }
        catch {
            return "Metric"
        }
        return measuringUnit
    }
    
    func storeMeasuringUnit(unit: String) {
        do {
            let data = try encoder.encode(unit)
            defaults.set(data, forKey: "unit")
        }
        catch{}
    }
    
    func fetchCurrentCity() -> GeoItem {
        var currentCity = [GeoItem]()
        let defaultGeoItem = GeoItem(name: "Vienna", lat: "48.20849", lng: "16.37208")
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
        cityHistory = cityHistory.filter({ $0.name != currentCity.name })
        cityHistory.insert(currentCity, at: 0)
        
        do {
            let data = try encoder.encode(cityHistory)
            defaults.set(data, forKey: "geo")
        }
        catch{}
    }
    
    func removeCity(geoItem: GeoItem) {
        var cityHistory = fetchCityHistory()
        cityHistory = cityHistory.filter({
            $0.name != geoItem.name
        })
        do {
            let data = try encoder.encode(cityHistory)
            defaults.set(data, forKey: "geo")
        }
        catch{}
    }
}
