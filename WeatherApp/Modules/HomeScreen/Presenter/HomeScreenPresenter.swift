//
//  HomeScreenViewModel.swift
//  WeatherApp
//
//  Created by Domagoj Bunoza on 01.03.2022..
//

import Combine
import Foundation
import CoreLocation
import SwiftUI

class HomeScreenPresenter: ObservableObject {
    
    let interactor: HomeScreenInteractor
    let searchScreenRouter = SearchScreenRouter()
    let settingsScreenRouter = SettingsScreenRouter()
    var isLoading: Bool = false
    var error: Error?
    
    @Published var screenData = HomeScreenDomainItem()
    
    var disposebag = Set<AnyCancellable>()
    
    init(interactor: HomeScreenInteractor) {
        self.interactor = interactor
        setupBindings()
    }
    
    func setupBindings() {
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
    
    func searchScreenLinkBuilder<Content: View>(
        @ViewBuilder content: () -> Content
    ) -> some View {
        NavigationLink(
            destination: searchScreenRouter.makeSearchScreenRouter(
                backgroundImage: screenData.backgroundImage
            )
        ) {
            content()
        }
    }
    
    func settingsScreenLinkBuilder<Content: View>(
        backgroundImage: String,
        @ViewBuilder content: () -> Content
    ) -> some View {
        NavigationLink(
            destination: settingsScreenRouter.makeSettingsScreen(
                backgroundImage: screenData.backgroundImage
            )
        ) {
            content()
        }
    }
    
}
