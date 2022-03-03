//
//  Repository.swift
//  WeatherApp
//
//  Created by Domagoj Bunoza on 01.03.2022..
//

class Repository {
    func getLocationCoordinates(cityName: String, completion: @escaping (Result<GeoResponse, NetworkError>) -> ()) {
        RestManager.fetch(url: "http://api.geonames.org/searchJSON?q=\(cityName)&maxRows=10&lang=es&username=\(Constants.username)", completionHandler: completion)
    }
    
    func getWeatherData(lat: String, lon: String, units: String, completion: @escaping (Result<WeatherResponse, NetworkError>) -> ()) {
        RestManager.fetch(url: "https://api.openweathermap.org/data/2.5/weather?lat=\(lat)&lon=\(lon)&units=\(units)&appid=\(Constants.APIKEY)", completionHandler: completion)
    }
}
