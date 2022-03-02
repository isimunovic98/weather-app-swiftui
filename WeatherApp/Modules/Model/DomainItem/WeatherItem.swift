//
//  WeatherItem.swift
//  WeatherApp (iOS)
//
//  Created by Domagoj Bunoza on 02.03.2022..
//

import Foundation

// MARK: - Welcome
struct WeatherItem: Codable {
    let temp: String
    let tempMin: String
    let tempMax: String
    let pressure: String
    let humidity: String
    let backgroundImage: String
    let weatherDescription: String
    let wind: String
    let name: String
}

