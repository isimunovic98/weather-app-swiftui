//
//  HomeScreenViewModel.swift
//  WeatherApp
//
//  Created by Domagoj Bunoza on 01.03.2022..
//

import Combine
import Foundation
import CoreLocation

class HomeScreenViewModel: ObservableObject {
    
    @Published var isLoading: Bool = false
    @Published var error: Error?
    @Published var screenData: HomeScreenDomainItem
    
    var currentLocationIsSet : Bool = false
    
    let weatherRepository : WeatherRepository
    let persistence : UserDefaultsManager
    let locationManager = LocationProvider()
    var disposebag = Set<AnyCancellable>()
    
    init(repository: WeatherRepository) {
        self.weatherRepository = repository
        self.persistence = UserDefaultsManager()
        self.screenData = HomeScreenDomainItem()
    }
    
    func onAppear() {
        if !currentLocationIsSet {
            setupLocationListener()
        }
        requestWeatherUpdates()
    }
    
    func setupLocationListener() {
        isLoading = true
        locationManager.setupLocationManager()
        locationManager.$currentLocation
            .subscribe(on: DispatchQueue.global(qos: .background))
            .receive(on: RunLoop.main)
            .sink(receiveValue: { currentLocation in
                if let location = currentLocation {
                    location.fetchCityName { city, error in
                        guard let city = city, error == nil
                        else {
                            return
                        }
                        let newCity = GeoItem(
                            name: city,
                            lat: String(location.coordinate.latitude),
                            lng: String(location.coordinate.longitude)
                        )
                        self.persistence.storeNewCity(geoItem: newCity)
                        self.currentLocationIsSet = true
                        self.handleWeatherResponse(city: newCity)
                    }
                }
            })
            .store(in: &disposebag)
    }
    
    func requestWeatherUpdates() {
        persistence.fetchCurrentCityObservable()
            .subscribe(on: DispatchQueue.global(qos: .background))
            .receive(on: RunLoop.main)
            .sink(receiveValue: { newCurrentCity in
                    self.handleWeatherResponse(city: newCurrentCity)
            })
            .store(in: &disposebag)
    }
    
    func handleWeatherResponse(city: GeoItem) {
        self.isLoading = true
        let units = persistence.fetchSettingsModel().measuringUnit
        weatherRepository.fetch(lat: city.lat, lon: city.lng, units: units)
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
    
    func isAnyFeatureVisible() -> Bool {
        return screenData.showHumidity || screenData.showPressure || screenData.showWindSpeed
    }
    
    func createScreenData(response: WeatherResponse) -> HomeScreenDomainItem {
        let settings = persistence.fetchSettingsModel()
        
        return HomeScreenDomainItem(
            backgroundImage: Handler.handleImageChoice(weather: response.weather[0].main, icon: response.weather[0].icon),
            currentTemperature: (settings.measuringUnit == "Metric") ? String(Int(response.main.temp)) + " ??C": String(Int(response.main.temp)) + " ??F",
            weatherDescription: response.weather[0].weatherDescription.capitalized + ".",
            cityName: response.name,
            lowTemperature: settings.measuringUnit == "Metric" ? String(Int(response.main.tempMin)) + " ??C": String(Int(response.main.tempMin)) + " ??F",
            highTemperature: settings.measuringUnit == "Metric" ? String(Int(response.main.tempMax)) + " ??C": String(Int(response.main.tempMax)) + " ??F",
            windSpeed: settings.measuringUnit == "Metric" ? String(Int(response.wind.speed)) + " km/h": String(Int(response.wind.speed)) + " mph",
            pressure: String(response.main.pressure) + " hPa",
            humidity: String(response.main.humidity) + "%",
            showWindSpeed: settings.wind,
            showPressure: settings.pressure,
            showHumidity: settings.humidity
        )
    }
}
