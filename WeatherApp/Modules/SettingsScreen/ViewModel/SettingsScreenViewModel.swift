//
//  SettingsScreenViewModel.swift
//  WeatherApp (iOS)
//
//  Created by Domagoj Bunoza on 03.03.2022..
//

import Combine
import Foundation

class SettingsScreenViewModel : ObservableObject {

    @Published var citiesNames : [String]
    @Published var cities : [GeoItem]
    @Published var humidity : Bool
    @Published var pressure : Bool
    @Published var wind : Bool

    let persistence : Database
    
    init(persistence : Database) {
        self.persistence = persistence
        self.citiesNames = []
        self.cities = []
        self.humidity = true
        self.pressure = true
        self.wind = true
    }
        
    func handleGettingLocationHistory() {
        let cityHistory = persistence.fetchCityHistory()
        setScreenData(from: cityHistory)
        setFeatures()
    }
    
    func setFeatures() {
        let features = persistence.fetchFeatures()
        humidity = features[0]
        pressure = features[1]
        wind = features[2]
    }
    
    func startViewModel() {
        handleGettingLocationHistory()
    }
    
    func selectedCity(geoItem: GeoItem) {
        persistence.removeCity(geoItem: geoItem)
        persistence.storeNewCity(geoItem: geoItem)
    }
    
    func selectedDeleteCity(geoItem: GeoItem) {
        persistence.removeCity(geoItem: geoItem)
        handleGettingLocationHistory()
    }
    
    func setScreenData(from input: [GeoItem]) {
        cities = input
        citiesNames = input.map({ $0.name })
    }
    
    func selectMeasuringUnit(unit: String) {
        persistence.storeMeasuringUnit(unit: unit)
    }
    
    func toggleFeature(feature: String) {
        switch feature {
        case "humidity":
            humidity.toggle()
        case "pressure":
            pressure.toggle()
        case "wind":
            wind.toggle()
        default:
            break
        }
        persistence.storeFeatures(features: [humidity, pressure, wind])
    }
}
