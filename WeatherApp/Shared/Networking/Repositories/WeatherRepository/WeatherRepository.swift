//
//  WeatherRepository.swift
//  WeatherApp (iOS)
//
//  Created by Domagoj Bunoza on 03.03.2022..
//

protocol WeatherRepository {
    func fetch(lat: String, lon: String, units: String, completion: @escaping (Result<WeatherResponse, NetworkError>) -> ())
}
