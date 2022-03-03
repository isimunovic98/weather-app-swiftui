//
//  HomeScreenViewModel.swift
//  WeatherApp
//
//  Created by Domagoj Bunoza on 01.03.2022..
//

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
        var screenData: WeatherItem
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
        screenData: WeatherItem(temp: "", tempMin: "", tempMax: "", pressure: "", humidity: "", backgroundImage: "", weatherDescription: "", wind: "", name: ""),
        outputAction: .Loading,
        outputSubject: PassthroughSubject<States, Never>()
    )
    
    var coords : Coords
    let repository : Repository
    let persistence : Database
    
    init(repository : Repository, persistence : Database) {
        self.repository = repository
        self.persistence = persistence
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
        let currentCity = persistence.fetchCurrentCity()
        coords.lng = currentCity.lng
        coords.lat = currentCity.lat
    }
    
    func startViewModel(){
        handleGettingLocation()
        self.setupBindings().store(in: &self.disposebag)
    }
    
    func handleWeatherResponse() -> AnyPublisher<States, Never> {
        repository.getWeatherData(lat: coords.lat, lon: coords.lng, units: persistence.fetchMeasuringUnit(), completion: { result -> () in
            result.map({ result in
                self.output = self.createOutput(response: result)
            })
        })
        return Just(.Loaded).eraseToAnyPublisher()
    }
    
    func createOutput(response: WeatherResponse) -> Output {
        print(response.weather[0].main)
        
        let measuringUnit = persistence.fetchMeasuringUnit()
        
        output.screenData = WeatherItem(
            temp: measuringUnit == "Metric" ? String(Int(response.main.temp)) + " °C" : String(Int(response.main.temp)) + " °F",
            tempMin: measuringUnit == "Metric" ? String(Int(response.main.tempMin)) + " °C" : String(Int(response.main.tempMin)) + " °F",
            tempMax: measuringUnit == "Metric" ? String(Int(response.main.tempMax)) + " °C" : String(Int(response.main.tempMax)) + " °F",
            pressure: String(response.main.pressure) + " hPa",
            humidity: String(response.main.humidity) + " %",
            backgroundImage: handleImageChoice(weather: response.weather[0].main),
            weatherDescription: response.weather[0].weatherDescription,
            wind: measuringUnit == "Metric" ? String(Int(response.wind.speed)) + " km/h" : String(Int(response.wind.speed)) + " mph",
            name: response.name
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
