//
//  HomeScreenViewModel.swift
//  WeatherApp
//
//  Created by Domagoj Bunoza on 01.03.2022..
//

import SwiftUI
import Combine
import Alamofire

class HomeScreenViewModel : ObservableObject {
        
    enum States {
        case Loading
        case Loaded
        case Error
    }
    
    struct ScreenData {
        var backgroundImage : String
        var currentTemperature : String
        var weatherDescription : String
        var cityName : String
        var lowTemperature : String
        var highTemperature : String
        var windSpeed : String
        var pressure : String
        var humidity : String
    }
    
    struct Output {
        var screenData: ScreenData
        var outputAction: States
        var outputSubject: PassthroughSubject<States, Never>
    }
    
    struct Coords {
        var lat : String
        var lng : String
    }
    
    var getStates = PassthroughSubject<States, Never>()
    var disposebag = Set<AnyCancellable>()
    var input = CurrentValueSubject<States, Never>(.Loading)

    @Published var output : Output = Output(
        screenData: ScreenData(
            backgroundImage: "",
            currentTemperature: "-15",
            weatherDescription: "0",
            cityName: "x",
            lowTemperature: "0",
            highTemperature: "0",
            windSpeed: "0",
            pressure: "0",
            humidity: "0"
        ),
        outputAction: .Loading,
        outputSubject: PassthroughSubject<States, Never>()
    )
    
    var coords : Coords
    let repository : Repository
    
    init(repository : Repository) {
        self.repository = repository
        coords = Coords(lat: "0", lng: "0")
    }
    
    func setupBindings() -> AnyCancellable {
            return input
                .flatMap { [unowned self] inputAction -> AnyPublisher<States, Never> in
                    switch inputAction {
                    case .Loading:
                        print("show loader")
                        return self.handleWeatherResponse()
                    case .Loaded:
                        print("dismiss loader")
                        return self.handleWeatherResponse()
                    case .Error:
                        print("error")
                        return self.handleWeatherResponse()
                    }
                }
                .subscribe(on: DispatchQueue.global(qos: .background))
                .receive(on: RunLoop.main)
                .sink { [unowned self] outputActions in
                    self.output.outputSubject.send(outputActions)
                }
        }
    
    func handleGettingLocation() {
        return repository.getLocationCoordinates(cityName: Constants.cityNameDefault , completion: { result -> () in
            result.map { geoResponse in
                self.coords.lat = geoResponse.geonames[0].lat
                self.coords.lng = geoResponse.geonames[0].lng
                
                print(self.coords.lat + " " + self.coords.lng)
                self.setupBindings().store(in: &self.disposebag)
            }
        })
    }
    
    func handleWeatherResponse() -> AnyPublisher<States, Never> {
        repository.getWeatherData(lat: coords.lat, lon: coords.lng, completion: { result -> () in
            result.map({ result in
                self.output = self.createOutput(response: result)
            })
        })
        return Just(.Loaded).eraseToAnyPublisher()
    }
    
    func createOutput(response: WeatherResponse) -> Output {
        print(response.weather[0].main)
        
        output.screenData = ScreenData(
            backgroundImage: handleImageChoice(weather: response.weather[0].main),
            currentTemperature: String(Int(response.main.temp)) + " °C",
            weatherDescription: response.weather[0].weatherDescription,
            cityName: response.name,
            lowTemperature: String(Int(response.main.tempMin)) + " °C",
            highTemperature: String(Int(response.main.tempMax)) + " °C",
            windSpeed: String(response.wind.speed) + " km/h",
            pressure: String(response.main.pressure) + " hPa",
            humidity: String(response.main.humidity) + " %"
        )
        getStates.send(.Loaded)
        return output
    }
    func handleImageChoice(weather: String) -> String {
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
            return "body_image-clear-day"
        case "Clouds":
            return "body_image-cloudy"
        default:
            return "body_image-tornado"
        }
    }
}
