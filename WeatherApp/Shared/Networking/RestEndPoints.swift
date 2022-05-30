//
//  RestEndPoints.swift
//  WeatherApp
//
//  Created by Domagoj Bunoza on 15.03.2022..
//

import Foundation

public enum RestEndpoints {
    case weather(lat: String, lng: String, units: String)
    case geo(cityName: String)
    
    static let weatherBaseUrl = Bundle.main.object(forInfoDictionaryKey: "WEATHER_BASE_URL") as! String
    static let weatherApiKey = Bundle.main.object(forInfoDictionaryKey: "WEATHER_API_KEY") as! String
    static let geoUsername = Bundle.main.object(forInfoDictionaryKey: "GEO_USERNAME") as! String
    static let geoBaseUrl = Bundle.main.object(forInfoDictionaryKey: "GEO_BASE_URL") as! String

    public func endpoint() -> String {
        switch self {
        case .weather(let lat, let lng, let units):
            return RestEndpoints.weatherBaseUrl +
            "lat=" + lat +
            "&lon=" + lng +
            "&units=" + units +
            "&appid=" + RestEndpoints.weatherApiKey
        case .geo(let cityName):
            return RestEndpoints.geoBaseUrl +
            "username=" + RestEndpoints.geoUsername +
            "&q=" + cityName
        }
    }
}
