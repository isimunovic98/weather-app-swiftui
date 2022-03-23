//
//  SettingsScreenViewModel.swift
//  WeatherApp (iOS)
//
//  Created by Domagoj Bunoza on 03.03.2022..
//

import Combine
import Foundation
import SwiftUI

class SettingsScreenViewModel : ObservableObject {
    
    @Published var screenData : SettingsScreenDomainItem
    
    let persistence : UserDefaultsManager
    
    init() {
        self.persistence = UserDefaultsManager()
        self.screenData = SettingsScreenDomainItem(
            cities: [],
            humidity: persistence.fetchHumidity(),
            pressure: persistence.fetchPressure(),
            wind: persistence.fetchWind())
    }
    
    func getLocationHistory() {
        let cityHistory = persistence.fetchCityHistory()
        setScreenData(from: cityHistory)
    }
    
    func setFeatures() {
        screenData.humidity = persistence.fetchHumidity()
        screenData.pressure = persistence.fetchPressure()
        screenData.wind = persistence.fetchWind()
    }
    
    func onAppear() {
        getLocationHistory()
    }
    
    func selectedCity(geoItem: GeoItem) {
        persistence.removeCity(geoItem: geoItem)
        persistence.storeNewCity(geoItem: geoItem)
    }
    
    func selectedDeleteCity(geoItem: GeoItem) {
        persistence.removeCity(geoItem: geoItem)
        getLocationHistory()
    }
    
    func setScreenData(from input: [GeoItem]) {
        screenData.cities = input
        setFeatures()
    }
    
    func selectMeasuringUnit(unit: String) {
        persistence.storeMeasuringUnit(unit: unit)
    }
    
    func toggleFeature(feature: String) {
        switch feature {
        case "humidity":
            screenData.humidity.toggle()
            persistence.storeHumidity(value: screenData.humidity)
        case "pressure":
            screenData.pressure.toggle()
            persistence.storePressure(value: screenData.pressure)
        case "wind":
            screenData.wind.toggle()
            persistence.storeWind(value: screenData.wind)
        default:
            break
        }
    }
}
