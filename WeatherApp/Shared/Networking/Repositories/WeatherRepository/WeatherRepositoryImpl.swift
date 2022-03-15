//
//  WeatherRepositoryImpl.swift
//  WeatherApp (iOS)
//
//  Created by Domagoj Bunoza on 03.03.2022..
//

import Foundation

class WeatherRepositoryImpl : WeatherRepository {
    
    func fetch(lat: String, lon: String, units: String, completion: @escaping (Result<WeatherResponse, NetworkError>) -> ()) {
        RestManager.fetch(url: RestEndpoints.weather(lat: lat, lng: lon, units: units).endpoint(), completionHandler: completion)
    }
    
    
}
