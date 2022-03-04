//
//  WeatherRepositoryImpl.swift
//  WeatherApp (iOS)
//
//  Created by Domagoj Bunoza on 03.03.2022..
//

import Foundation

class WeatherRepositoryImpl : WeatherRepository {
    
    override func fetch(lat: String, lon: String, units: String, completion: @escaping (Result<WeatherResponse, NetworkError>) -> ()) {
        RestManager.fetch(url: "https://api.openweathermap.org/data/2.5/weather?lat=\(lat)&lon=\(lon)&units=\(units)&appid=\(Constants.APIKEY)", completionHandler: completion)
    }
}
