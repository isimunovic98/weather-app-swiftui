//
//  HomeScreenRouter.swift
//  WeatherApp (iOS)
//
//  Created by Domagoj Bunoza on 14.05.2022..
//

import Foundation
import SwiftUI

class HomeScreenRouter {
    func makeHomeScreen() -> some View {
        let homeScreenInteractor = HomeScreenInteractor()
        let homeScreenPresenter = HomeScreenPresenter(interactor: homeScreenInteractor)
        return HomeScreen(presenter: homeScreenPresenter)
    }
}
