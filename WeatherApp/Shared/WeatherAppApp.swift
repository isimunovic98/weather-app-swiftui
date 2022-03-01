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
            let repository = Repository()
            let homeScreenViewModel = HomeScreenViewModel(repository: repository)

            HomeScreen(viewmodel: homeScreenViewModel)
        }
    }
}
