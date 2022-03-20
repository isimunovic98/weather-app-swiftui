//
//  HomeScreenViewModel.swift
//  WeatherApp
//
//  Created by Domagoj Bunoza on 01.03.2022..
//

import Combine
import Foundation
import CoreLocation

class HomeScreenViewModel : ObservableObject {
    
    @Published var isLoading : Bool = false
    @Published var error : Error?
    @Published var screenData : HomeScreenDomainItem
    
    var currentLocationIsSet : Bool = false
    
    let weatherRepository : WeatherRepository
    let persistence : UserDefaultsManager
    let locationManager = LocationProvider()
    var disposebag = Set<AnyCancellable>()
    
    init(repository : WeatherRepository) {
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
                        guard let city = city, error == nil else { return }
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
                if self.currentLocationIsSet {
                    self.handleWeatherResponse(city: newCurrentCity)
                }
            })
            .store(in: &disposebag)
    }
    
    func handleWeatherResponse(city: GeoItem) {
        self.isLoading = true
        let units = persistence.fetchMeasuringUnit()
        weatherRepository.fetch(lat: city.lat, lon: city.lng, units: units)
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
        let measuringUnit = persistence.fetchMeasuringUnit()
        
        return HomeScreenDomainItem(
            backgroundImage: Handler.handleImageChoice(weather: response.weather[0].main),
            currentTemperature: (measuringUnit == "Metric") ? String(Int(response.main.temp)) + " °C" : String(Int(response.main.temp)) + " °F",
            weatherDescription: response.weather[0].weatherDescription.capitalized + ".",
            cityName: response.name,
            lowTemperature: measuringUnit == "Metric" ? String(Int(response.main.tempMin)) + " °C" : String(Int(response.main.tempMin)) + " °F",
            highTemperature: measuringUnit == "Metric" ? String(Int(response.main.tempMax)) + " °C" : String(Int(response.main.tempMax)) + " °F",
            windSpeed: measuringUnit == "Metric" ? String(Int(response.wind.speed)) + " km/h" : String(Int(response.wind.speed)) + " mph",
            pressure: String(response.main.pressure) + " hPa",
            humidity: String(response.main.humidity) + "%",
            showWindSpeed : persistence.fetchWind(),
            showPressure : persistence.fetchPressure(),
            showHumidity : persistence.fetchHumidity()
        )
    }
}
