//
//  Handler.swift
//  WeatherApp (iOS)
//
//  Created by Domagoj Bunoza on 03.03.2022..
//

import Foundation

class Handler {
    
    static func handleImageChoice(weather: String, icon: String) -> String {
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
            if icon.last == "d" {
                return "body_image-clear-day"
            }
            return "body_image-clear-night"
        case "Clouds":
            if icon.last == "d" {
                return "body_image-partly-cloudy-day"
            }
            return "body_image-partly-cloudy-night"
        default:
            return "body_image-tornado"
        }
    }
    
    static func modifyCityName(cityName: String) -> String {
        let lowerCase = cityName.lowercased()
        let words = lowerCase.split(separator: " ")
        let joinedName = words.joined(separator: "-")
        let characters = Array(joinedName)
        
        var charsModified = Array<Character>()
        
        for item in characters {
            switch item {
            case "š":
                charsModified.append("s")
            case "ž":
                charsModified.append("z")
            case "đ":
                charsModified.append("d")
            case "č":
                charsModified.append("c")
            case "ć":
                charsModified.append("c")
            default:
                charsModified.append(item)
            }
        }
        return String(charsModified)
    }
}
