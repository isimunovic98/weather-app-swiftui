//
//  SettingsScreenViewModel.swift
//  WeatherApp (iOS)
//
//  Created by Domagoj Bunoza on 03.03.2022..
//

import Combine
import Foundation
import SwiftUI

class SettingsScreenPresenter: ObservableObject {
    
    @Published var settingsData: SettingsScreenDomainItem
    
    let interactor: SettingsScreenInteractor
    
    var disposebag = Set<AnyCancellable>()
    
    init(interactor: SettingsScreenInteractor) {
        self.interactor = interactor
        settingsData = SettingsScreenDomainItem()
        setupBindings()
    }
    
    func setupBindings()  {
        interactor.$screenData
            .assign(to: \.settingsData, on: self)
            .store(in: &disposebag)
    }
    
    func onAppear() {
        interactor.getLocationHistory()
    }
    
    func selectedDeleteCity(geoItem: GeoItem) {
        interactor.selectedDeleteCity(geoItem: geoItem)
    }
    
    func selectMeasuringUnit(unit: String) {
        interactor.selectMeasuringUnit(unit: unit)
    }
    
    func toggleFeature(feature: String) {
        interactor.toggleFeature(feature: feature)
    }
    
    func selectedCity(geoItem: GeoItem) {
        interactor.selectedCity(geoItem: geoItem)
    }
}
