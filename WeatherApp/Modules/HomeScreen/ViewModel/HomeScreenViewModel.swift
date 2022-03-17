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
        handleWeatherResponse()
    }
    
    func handleWeatherResponse() {
        self.isLoading = true
        let current = persistence.fetchCurrentCity()
        let lat = current.lat
        let lng = current.lng
        let units = persistence.fetchMeasuringUnit()
        weatherRepository.fetch(lat: lat, lon: lng, units: units)
            .subscribe(on: DispatchQueue.global(qos: .background))
            .receive(on: RunLoop.main)
            .sink(receiveValue: { [unowned self] response in
                self.isLoading = false
                switch response {
                case .success(let response):
                    self.screenData = createScreenData(response: response)
                case .failure(let error):
                    self.error = error
                }
            })
            .store(in: &disposebag)
    }
    
    func createScreenData(response: WeatherResponse) -> HomeScreenDomainItem {
        let currentFeatures = persistence.fetchFeatures()
        let measuringUnit = persistence.fetchMeasuringUnit()
        
        return HomeScreenDomainItem(
            backgroundImage: Handler.handleImageChoice(weather: response.weather[0].main),
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
