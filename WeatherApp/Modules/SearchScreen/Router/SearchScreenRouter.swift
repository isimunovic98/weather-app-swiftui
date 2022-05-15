//
//  SearchScreenRouter.swift
//  WeatherApp (iOS)
//
//  Created by Domagoj Bunoza on 15.05.2022..
//

import Foundation
import SwiftUI

class SearchScreenRouter {
    func makeSearchScreenRouter(backgroundImage: String) -> some View {
        let searchScreenInteractor = SearchScreenInteractor()
        let searchScreenPresenter = SearchScreenPresenter(interactor: searchScreenInteractor)
        return SearchView(backgroundImage: backgroundImage, presenter: searchScreenPresenter)
    }
}

