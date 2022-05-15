//
//  SearchScreenViewModel.swift
//  WeatherApp (iOS)
//
//  Created by Domagoj Bunoza on 02.03.2022..
//
import Foundation
import Combine
import SwiftUI

class SearchScreenPresenter: ObservableObject {
    
    let interactor: SearchScreenInteractor
    var disposebag = Set<AnyCancellable>()
    
    @Published var cities: [GeoItem] = []
    
    init(interactor: SearchScreenInteractor) {
        self.interactor = interactor
        setupInteractor()
    }
    
    func setupInteractor() {
        self.interactor.$cities
            .assign(to: \.cities, on: self)
            .store(in: &disposebag)
    }
    
    func getLocation(cityName: String) {
        interactor.getLocation(cityName: cityName)
    }
    
    func didSelectCity(geoItem: GeoItem) {
        interactor.didSelectCity(geoItem: geoItem)
    }
    
}
