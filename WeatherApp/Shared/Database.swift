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
    
    func fetchFeatures() -> [Bool] {
        var feaures : [Bool]
        do {
            guard let decoded = defaults.data(forKey: "features")
            else {
                return [true, true, true]
            }
            feaures = try decoder.decode([Bool].self, from: decoded)
        }
        catch {
            return [true, true, true]
        }
        return feaures
    }
    
    func storeFeatures(features: [Bool]) {
        do {
            let data = try encoder.encode(features)
            defaults.set(data, forKey: "features")
        }
        catch{}
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
                return currentCity[0]
            }
            currentCity = try decoder.decode([GeoItem].self, from: decoded)
            if currentCity.count == 0 {
                currentCity.append(defaultGeoItem)
            }
        }
        catch {
            return currentCity[0]
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
        print(cityHistory)
        return cityHistory
    }
    
    func storeNewCity(geoItem: GeoItem) {
        let currentCity = geoItem
        var cityHistory = fetchCityHistory()
        cityHistory.insert(currentCity, at: 0)
        
        do {
            let data = try encoder.encode(cityHistory)
            defaults.set(data, forKey: "geo")
        }
        catch{}
        print(currentCity.name)
    }
    
    func storeAll(geoItems: [GeoItem]) {
        let cityHistory = geoItems
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
