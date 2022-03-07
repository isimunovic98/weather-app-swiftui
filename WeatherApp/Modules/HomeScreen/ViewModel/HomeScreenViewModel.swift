//
//  HomeScreenViewModel.swift
//  WeatherApp
//
//  Created by Domagoj Bunoza on 01.03.2022..
//

import Combine
import Foundation
import CoreImage

class HomeScreenViewModel : ObservableObject {
    
    @Published var isLoading : Bool = false
    @Published var error : Bool = false
    @Published var screenData : HomeScreenDomainItem
    
    struct Coords {
        var lat : String
        var lng : String
    }
    
    var coords : Coords
    let weatherRepository : WeatherRepository
    let persistence : UserDefaultsManager
    var disposebag = Set<AnyCancellable>()
    
    init(repository : WeatherRepository) {
        self.weatherRepository = repository
        self.persistence = UserDefaultsManager()
        self.screenData = HomeScreenDomainItem()
        coords = Coords(lat: "0", lng: "0")
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
    
    func onAppear() {
        handleGettingLocation()
        setFeatures()
        persistence.sendFirstSignal()
    }
    
    func setFeatures() {
        let currentFeatures = persistence.fetchFeatures()
        self.screenData.showHumidity = currentFeatures[0]
        self.screenData.showPressure = currentFeatures[1]
        self.screenData.showWindSpeed = currentFeatures[2]
    }
    
    func handleWeatherResponse(geoItem: GeoItem) {
        weatherRepository.fetch(lat: geoItem.lat, lon: geoItem.lng, units: persistence.fetchMeasuringUnit(), completion: { result -> () in
            do {
                try self.setOutput(response: result.get())
                print("output set weather")
            }
            catch {
                self.error = true
                return
            }
            self.isLoading = false
        })
    }
    
    func setOutput(response: WeatherResponse) {
        let currentFeatures = persistence.fetchFeatures()
        let measuringUnit = persistence.fetchMeasuringUnit()
        
        screenData = HomeScreenDomainItem(
            backgroundImage: Handler().handleImageChoice(weather: response.weather[0].main),
            currentTemperature: (measuringUnit == "Metric") ? String(Int(response.main.temp)) + " °C" : String(Int(response.main.temp)) + " °F",
            weatherDescription: response.weather[0].weatherDescription,
            cityName: response.name,
            lowTemperature: measuringUnit == "Metric" ? String(Int(response.main.tempMin)) + " °C" : String(Int(response.main.tempMin)) + " °F",
            highTemperature: measuringUnit == "Metric" ? String(Int(response.main.tempMax)) + " °C" : String(Int(response.main.tempMax)) + " °F",
            windSpeed: measuringUnit == "Metric" ? String(Int(response.wind.speed)) + " km/h" : String(Int(response.wind.speed)) + " mph",
            pressure: String(response.main.pressure) + " hPa",
            humidity: String(response.main.humidity) + " %",
            showWindSpeed : currentFeatures[0],
            showPressure : currentFeatures[1],
            showHumidity : currentFeatures[2]
        )
    }
}
