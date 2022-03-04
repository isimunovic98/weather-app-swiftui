//
//  Handler.swift
//  WeatherApp (iOS)
//
//  Created by Domagoj Bunoza on 03.03.2022..
//

import Foundation

class Handler {
    
    func handleImageChoice(weather: String) -> String {
        switch weather {
        case "Thunderstorm":
            return "body_image-thunderstorm"
        case "Drizzle":
            return "body_image-rain"
        case "Rain":
            return "body_image-rain"
        case "Snow":
            return "body_image-snow"
        case "Clear":
            return "body_image-clear-day"
        case "Clouds":
            return "body_image-cloudy"
        default:
            return "body_image-tornado"
        }
    }
}
