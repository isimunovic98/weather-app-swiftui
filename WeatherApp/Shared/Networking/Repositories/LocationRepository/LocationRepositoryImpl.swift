//
//  LocationRepositoryImpl.swift
//  WeatherApp (iOS)
//
//  Created by Domagoj Bunoza on 03.03.2022..
//

import Foundation

class LocationRepositoryImpl : LocationRepository {
    
    func fetch(cityName: String, completion: @escaping (Result<GeoResponse, NetworkError>) -> ()) {
        RestManager.fetch(url: RestEndpoints.geo(cityName: cityName).endpoint(), completionHandler: completion)
    }
}
