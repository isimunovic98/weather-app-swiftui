//
//  SettingsScreenRouter.swift
//  WeatherApp (iOS)
//
//  Created by Domagoj Bunoza on 15.05.2022..
//

import Foundation
import SwiftUI

class SettingsScreenRouter {
    func makeSettingsScreen(backgroundImage: String) -> some View {
        let settingsScreenInteractor = SettingsScreenInteractor()
        let settingsScreenPresenter = SettingsScreenPresenter(interactor: settingsScreenInteractor)
        return SettingsScreen(
            backgroundImage: backgroundImage,
            presenter: settingsScreenPresenter
        )
    }
}
