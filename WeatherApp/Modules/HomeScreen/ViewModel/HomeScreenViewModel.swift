//
//  HomeScreenViewModel.swift
//  WeatherApp
//
//  Created by Domagoj Bunoza on 01.03.2022..
//

import Combine
import Foundation

class HomeScreenViewModel : ObservableObject {
    
    @Published var backgroundImage : String
    @Published var currentTemperature : String
    @Published var weatherDescription : String
    @Published var cityName : String
    @Published var lowTemperature : String
    @Published var highTemperature : String
    @Published var windSpeed : String
    @Published var pressure : String
    @Published var humidity : String
    
    @Published var isLoading : Bool
    @Published var error : Error?
    
    struct Coords {
        var lat : String
        var lng : String
    }
    
    var coords : Coords
    let weatherRepository : WeatherRepository
    let persistence : Database
    
    var disposebag = Set<AnyCancellable>()
    
    init(repository : WeatherRepository, persistence : Database) {
        self.weatherRepository = repository
        self.persistence = persistence
        backgroundImage = ""
        currentTemperature = ""
        weatherDescription = ""
        cityName = ""
        lowTemperature = ""
        highTemperature = ""
        windSpeed = ""
        pressure = ""
        humidity = ""
        coords = Coords(lat: "0", lng: "0")
        isLoading = true
        
        startViewModel()
    }
    
    func handleGettingLocation() {
        
        persistence.geoItemResult
            .subscribe(on: DispatchQueue.global(qos: .background))
            .receive(on: RunLoop.main)
            .sink(receiveValue: { [unowned self] geoItem in
                self.coords.lng = geoItem.lng
                self.coords.lat = geoItem.lat
                print("persistence changed")
                handleWeatherResponse(geoItem: geoItem)
            })
            .store(in: &self.disposebag)
        }
    
    func startViewModel() {
        handleGettingLocation()
    }
    
    func handleWeatherResponse(geoItem: GeoItem) {
        weatherRepository.fetch(lat: geoItem.lat, lon: geoItem.lng, units: persistence.fetchMeasuringUnit(), completion: { result -> () in
            do {
                try self.setOutput(response: result.get())
                print("output set")
            }
            catch (let caughtError) {
                self.error = caughtError
                return
            }
            self.isLoading = false
        })
    }
    
    func setOutput(response: WeatherResponse) {
        
        let measuringUnit = persistence.fetchMeasuringUnit()
        
        currentTemperature = (measuringUnit == "Metric") ? String(Int(response.main.temp)) + " °C" : String(Int(response.main.temp)) + " °F"
        lowTemperature = measuringUnit == "Metric" ? String(Int(response.main.tempMin)) + " °C" : String(Int(response.main.tempMin)) + " °F"
        highTemperature = measuringUnit == "Metric" ? String(Int(response.main.tempMax)) + " °C" : String(Int(response.main.tempMax)) + " °F"
        pressure = String(response.main.pressure) + " hPa"
        humidity = String(response.main.humidity) + " %"
        backgroundImage = Handler().handleImageChoice(weather: response.weather[0].main)
        weatherDescription = response.weather[0].weatherDescription
        windSpeed = measuringUnit == "Metric" ? String(Int(response.wind.speed)) + " km/h" : String(Int(response.wind.speed)) + " mph"
        cityName = response.name
    }
    
}
