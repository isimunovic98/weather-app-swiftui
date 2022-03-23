//
//  HomeScreenViewModel.swift
//  WeatherApp
//
//  Created by Domagoj Bunoza on 01.03.2022..
//

import Combine
import Foundation

class HomeScreenViewModel : ObservableObject {
    
    @Published var isLoading : Bool = false
    @Published var error : Error?
    @Published var screenData : HomeScreenDomainItem
    
    let weatherRepository : WeatherRepository
    let persistence : UserDefaultsManager
    var disposebag = Set<AnyCancellable>()
    
    init(repository : WeatherRepository) {
        self.weatherRepository = repository
        self.persistence = UserDefaultsManager()
        self.screenData = HomeScreenDomainItem()
    }
    
    func onAppear() {
        getWeatherResponse()
    }
    
    func getWeatherResponse() {
        self.isLoading = true
        let current = persistence.fetchCurrentCity()
        let lat = current.lat
        let lng = current.lng
        let units = persistence.fetchSettingsModel().measuringUnit
        weatherRepository.fetch(lat: lat, lon: lng, units: units)
            .subscribe(on: DispatchQueue.global(qos: .background))
            .receive(on: RunLoop.main)
            .tryMap { result -> WeatherResponse in
                switch result {
                case .success(let result):
                    return result
                case .failure(let error):
                    throw error
                }
            }
            .map { result -> (HomeScreenDomainItem) in
                return self.createScreenData(response: result)
            }
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    self.isLoading = false
                    break
                case .failure(let error):
                    self.error = error
                }
            }, receiveValue: { screenData in
                self.screenData = screenData
            })
            .store(in: &disposebag)
    }
    
    func createScreenData(response: WeatherResponse) -> HomeScreenDomainItem {
        let settings = persistence.fetchSettingsModel()
        
        return HomeScreenDomainItem(
            backgroundImage: Handler.handleImageChoice(weather: response.weather[0].main),
            currentTemperature: (settings.measuringUnit == "Metric") ? String(Int(response.main.temp)) + " °C" : String(Int(response.main.temp)) + " °F",
            weatherDescription: response.weather[0].weatherDescription.capitalized + ".",
            cityName: response.name,
            lowTemperature: settings.measuringUnit == "Metric" ? String(Int(response.main.tempMin)) + " °C" : String(Int(response.main.tempMin)) + " °F",
            highTemperature: settings.measuringUnit == "Metric" ? String(Int(response.main.tempMax)) + " °C" : String(Int(response.main.tempMax)) + " °F",
            windSpeed: settings.measuringUnit == "Metric" ? String(Int(response.wind.speed)) + " km/h" : String(Int(response.wind.speed)) + " mph",
            pressure: String(response.main.pressure) + " hPa",
            humidity: String(response.main.humidity) + "%",
            showWindSpeed : settings.wind,
            showPressure : settings.pressure,
            showHumidity : settings.humidity
        )
    }
}
