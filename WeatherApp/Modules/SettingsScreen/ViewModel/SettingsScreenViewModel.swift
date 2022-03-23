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
        self.screenData = persistence.fetchSettingsModel()
    }
    
    func getLocationHistory() {
        let cityHistory = persistence.fetchCityHistory()
        setScreenData(from: cityHistory)
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
    }
    
    func selectMeasuringUnit(unit: String) {
        screenData.measuringUnit = unit
        persistence.storeSettingsModel(settings: screenData)
    }
    
    
    
    func toggleFeature(feature: String) {
        switch feature {
        case "humidity":
            screenData.humidity.toggle()
            persistence.storeSettingsModel(settings: screenData)
        case "pressure":
            screenData.pressure.toggle()
            persistence.storeSettingsModel(settings: screenData)
        case "wind":
            screenData.wind.toggle()
            persistence.storeSettingsModel(settings: screenData)
        default:
            break
        }
    }
}
