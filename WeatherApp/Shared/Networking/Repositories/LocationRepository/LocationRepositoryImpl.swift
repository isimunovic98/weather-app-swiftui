//
//  LocationRepositoryImpl.swift
//  WeatherApp (iOS)
//
//  Created by Domagoj Bunoza on 03.03.2022..
//

import Foundation
import Combine

class LocationRepositoryImpl : LocationRepository {
    
    func fetch(cityName: String) -> AnyPublisher<Result<GeoResponse, NetworkError>, Never> {
        return RestManager.fetch(url: RestEndpoints.geo(cityName: cityName).endpoint())
    }
}
