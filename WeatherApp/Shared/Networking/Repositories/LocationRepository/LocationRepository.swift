//
//  Repository.swift
//  WeatherApp
//
//  Created by Domagoj Bunoza on 01.03.2022..
//

import Combine

protocol LocationRepository {
    func fetch(cityName: String) -> AnyPublisher<Result<GeoResponse, NetworkError>, Never>
}
