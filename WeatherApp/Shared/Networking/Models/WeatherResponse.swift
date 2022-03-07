//
//  WeatherResponse.swift
//  WeatherApp
//
//  Created by Domagoj Bunoza on 01.03.2022..
//

import Foundation

// MARK: - Welcome
struct WeatherResponse: Codable {
    let weather: [Weather]
    let main: Main
    let wind: Wind
    let name: String
}

// MARK: - Main
struct Main: Codable {
    let temp, tempMin, tempMax: Double
    let pressure, humidity: Int
    
    enum CodingKeys: String, CodingKey {
        case temp
        case tempMin = "temp_min"
        case tempMax = "temp_max"
        case pressure, humidity
    }
}

// MARK: - Weather
struct Weather: Codable {
    let main, weatherDescription: String
    
    enum CodingKeys: String, CodingKey {
        case main
        case weatherDescription = "description"
    }
}

// MARK: - Wind
struct Wind: Codable {
    let speed: Double
}
