//
//  HomeScreenDomainItem.swift
//  WeatherApp (iOS)
//
//  Created by Domagoj Bunoza on 07.03.2022..
//

import Foundation

struct HomeScreenDomainItem {
    var backgroundImage : String
    var currentTemperature : String
    var weatherDescription : String
    var cityName : String
    var lowTemperature : String
    var highTemperature : String
    var windSpeed : String
    var pressure : String
    var humidity : String
    var showWindSpeed : Bool
    var showPressure : Bool
    var showHumidity : Bool

    init() {
        backgroundImage = ""
        currentTemperature = ""
        weatherDescription = ""
        cityName = ""
        lowTemperature = ""
        highTemperature = ""
        windSpeed = ""
        pressure = ""
        humidity = ""
        showWindSpeed = true
        showPressure = true
        showHumidity = true
    }
    
    init(
        backgroundImage : String,
        currentTemperature : String,
        weatherDescription : String,
        cityName : String,
        lowTemperature : String,
        highTemperature : String,
        windSpeed : String,
        pressure : String,
        humidity : String,
        showWindSpeed : Bool,
        showPressure : Bool,
        showHumidity : Bool
    ) {
        self.backgroundImage = backgroundImage
        self.currentTemperature = currentTemperature
        self.weatherDescription = weatherDescription
        self.cityName = cityName
        self.lowTemperature = lowTemperature
        self.highTemperature = highTemperature
        self.windSpeed = windSpeed
        self.pressure = pressure
        self.humidity = humidity
        self.showWindSpeed = showWindSpeed
        self.showPressure = showPressure
        self.showHumidity = showHumidity
    }
}
