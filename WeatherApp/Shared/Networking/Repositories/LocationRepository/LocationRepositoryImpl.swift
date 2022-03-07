//
//  LocationRepositoryImpl.swift
//  WeatherApp (iOS)
//
//  Created by Domagoj Bunoza on 03.03.2022..
//

import Foundation

class LocationRepositoryImpl : LocationRepository {
    
    override func fetch(cityName: String, completion: @escaping (Result<GeoResponse, NetworkError>) -> ()) {
        RestManager.fetch(url: "http://api.geonames.org/searchJSON?q=\(cityName)&maxRows=10&lang=es&username=\(Constants.username)", completionHandler: completion)
    }
}
