//
//  WeatherRepositoryImpl.swift
//  WeatherApp (iOS)
//
//  Created by Domagoj Bunoza on 03.03.2022..
//

import Foundation
import Combine

class WeatherRepositoryImpl: WeatherRepository {
    
    func fetch(lat: String, lon: String, units: String) -> AnyPublisher<Result<WeatherResponse, NetworkError>, Never> {
        return RestManager.fetch(
            url: RestEndpoints.weather(
                lat: lat,
                lng: lon,
                units: units
            )
            .endpoint()
        )
    }
}
