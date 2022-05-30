//
//  WeatherRepository.swift
//  WeatherApp (iOS)
//
//  Created by Domagoj Bunoza on 03.03.2022..
//

import Combine

protocol WeatherRepository {
    func fetch(lat: String, lon: String, units: String) -> AnyPublisher<Result<WeatherResponse, NetworkError>, Never>
}
