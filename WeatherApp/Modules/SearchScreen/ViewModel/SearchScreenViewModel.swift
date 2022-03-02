//
//  SearchScreenViewModel.swift
//  WeatherApp (iOS)
//
//  Created by Domagoj Bunoza on 02.03.2022..
//

import Combine
import Alamofire

class SearchScreenViewModel : ObservableObject {
    
    enum States {
        case Loading
        case Loaded
        case Error
    }
    
    struct ScreenData {
        var cities : [GeoItem]
    }
    
    struct Output {
        var screenData: ScreenData
        var outputAction: States
        var outputSubject: PassthroughSubject<States, Never>
    }
    
    var getStates = PassthroughSubject<States, Never>()
    var disposebag = Set<AnyCancellable>()
    var input = CurrentValueSubject<States, Never>(.Loading)
    
    @Published var output : Output = Output(
        screenData: ScreenData(
            cities: []
        ),
        outputAction: .Loading,
        outputSubject: PassthroughSubject<States, Never>()
    )
    
    let repository : Repository
    let persistence : Database
    
    init(repository : Repository, persistence : Database) {
        self.repository = repository
        self.persistence = persistence
    }
    
    func setupBindings(cityName: String) -> AnyCancellable {
        return input
            .flatMap { [unowned self] inputAction -> AnyPublisher<States, Never> in
                switch inputAction {
                case .Loading:
                    print("show loader")
                    return self.handleGettingLocation(cityName: cityName)
                case .Loaded:
                    print("dismiss loader")
                    return self.handleGettingLocation(cityName: cityName)
                case .Error:
                    print("error")
                    return self.handleGettingLocation(cityName: cityName)
                }
            }
            .subscribe(on: DispatchQueue.global(qos: .background))
            .receive(on: RunLoop.main)
            .sink { [unowned self] outputActions in
                self.output.outputSubject.send(outputActions)
            }
    }
    
    func handleGettingLocation(cityName: String) -> AnyPublisher<States, Never>{
        let cityNameModified = modifyCityName(cityName: cityName)
        repository.getLocationCoordinates(cityName: cityNameModified , completion: { result -> () in
            result.map { geoResponse in
                self.createOutput(response: geoResponse)
            }
        })
        return Just(.Loaded).eraseToAnyPublisher()
    }
    
    func startViewmodel(cityName: String) {
        setupBindings(cityName: cityName).store(in: &disposebag)
    }
    
    func createOutput(response: GeoResponse) {
        output.screenData.cities = response.geonames.map({
            GeoItem(name: $0.name, lat: $0.lat, lng: $0.lng)
        })
        print(output.screenData.cities)
        getStates.send(.Loaded)
    }
    
    func selectedCity(geoItem: GeoItem){
        persistence.storeNewCity(geoItem: geoItem)
    }
    
    func modifyCityName(cityName: String) -> String {
        let lowerCase = cityName.lowercased()
        let words = lowerCase.split(separator: " ")
        let joinedName = words.joined(separator: "-")
        let characters = Array(joinedName)
        
        var charsModified = Array<Character>()
        
        for item in characters {
            switch item {
            case "š":
                charsModified.append("s")
            case "ž":
                charsModified.append("z")
            case "đ":
                charsModified.append("d")
            case "č":
                charsModified.append("c")
            case "ć":
                charsModified.append("c")
            default:
                charsModified.append(item)
            }
        }
        return String(charsModified)

    }
}
