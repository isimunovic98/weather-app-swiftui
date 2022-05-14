//
//  HomeScreenViewModel.swift
//  WeatherApp
//
//  Created by Domagoj Bunoza on 01.03.2022..
//

import Combine
import Foundation
import CoreLocation

class HomeScreenPresenter: ObservableObject {
    
    let interactor: HomeScreenInteractor
    var isLoading: Bool = false
    var error: Error?
    
    @Published var screenData = HomeScreenDomainItem()
    
    var disposebag = Set<AnyCancellable>()
    
    init(interactor: HomeScreenInteractor) {
        self.interactor = interactor
        setupInteractor()
        setupError()
        setupLoading()
        setupData()
    }
    
    func setupInteractor() {
        interactor.$model
            .assign(to: \.screenData, on: self)
            .store(in: &disposebag)
    }
    
    func setupError()  {
        interactor.$error
            .assign(to: \.error, on: self)
            .store(in: &disposebag)
    }
    
    func setupLoading()  {
        interactor.$isLoading
            .assign(to: \.isLoading, on: self)
            .store(in: &disposebag)
    }
    
    func setupData() {
        if !interactor.currentLocationIsSet {
            interactor.setupLocationListener()
        }
        interactor.requestWeatherUpdates()
    }
    
}
