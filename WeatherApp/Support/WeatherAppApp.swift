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
            let homeScreenRouter = HomeScreenRouter()
            homeScreenRouter.makeHomeScreen()
        }
    }
}
