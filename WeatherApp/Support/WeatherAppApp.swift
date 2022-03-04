//
//  WeatherAppApp.swift
//  Shared
//
//  Created by Domagoj Bunoza on 28.02.2022..
//

import SwiftUI

@main
struct WeatherAppApp: App {
    
    var body: some Scene {
        WindowGroup {
            let weatherRepository = WeatherRepositoryImpl()
            let persistence = Database()
            let viewProvider = ViewProvider()
            let homeScreenViewModel = HomeScreenViewModel(repository: weatherRepository, persistence: persistence)
            
            HomeScreen(viewmodel: homeScreenViewModel, viewProvider: viewProvider)
        }
    }
}
