//
//  SettingsScreenViewModel.swift
//  WeatherApp (iOS)
//
//  Created by Domagoj Bunoza on 03.03.2022..
//

import Combine
import Foundation
class SettingsScreenViewModel : ObservableObject {
        
    enum States {
        case Loading
        case Loaded
        case Error
    }
    
    struct ScreenData {
        var citiesNames : [String]
        var cities : [GeoItem]
    }
    
    struct Output {
        var screenData: ScreenData
        var features: [Bool]
        var outputAction: States
        var outputSubject: PassthroughSubject<States, Never>
    }
    
    var getStates = PassthroughSubject<States, Never>()
    var disposebag = Set<AnyCancellable>()
    var input = CurrentValueSubject<States, Never>(.Loading)

    @Published var output : Output = Output(
        screenData: ScreenData(citiesNames: [], cities: []),
        features: [true, true, true],
        outputAction: .Loading,
        outputSubject: PassthroughSubject<States, Never>()
    )
    
    let repository : Repository
    let persistence : Database
    
    init(repository : Repository, persistence : Database) {
        self.repository = repository
        self.persistence = persistence
    }
    
    func setupBindings() -> AnyCancellable {
            return input
                .flatMap { [unowned self] inputAction -> AnyPublisher<States, Never> in
                    switch inputAction {
                    case .Loading:
                        print("show loader")
                        return self.handleGettingLocationHistory()
                    case .Loaded:
                        print("dismiss loader")
                        return self.handleGettingLocationHistory()
                    case .Error:
                        print("error")
                        return self.handleGettingLocationHistory()
                    }
                }
                .subscribe(on: DispatchQueue.global(qos: .background))
                .receive(on: RunLoop.main)
                .sink { [unowned self] outputActions in
                    self.output.outputSubject.send(outputActions)
                }
        }
    
    func handleGettingLocationHistory() -> AnyPublisher<States, Never> {
        let cityHistory = persistence.fetchCityHistory()
        output.screenData = createScreenData(from: cityHistory)
        getFeatures()
        return Just(.Loaded).eraseToAnyPublisher()
    }
    
    func getFeatures() {
        output.features = persistence.fetchFeatures()
    }
    
    func startViewModel() {
        self.setupBindings().store(in: &self.disposebag)
    }
    
    func selectedCity(geoItem: GeoItem) {
        persistence.removeCity(geoItem: geoItem)
        persistence.storeNewCity(geoItem: geoItem)
    }
    
    func selectedDeleteCity(geoItem: GeoItem) {
        persistence.removeCity(geoItem: geoItem)
        handleGettingLocationHistory()
    }
    
    func createScreenData(from input: [GeoItem]) -> ScreenData {
        let screenData = ScreenData(citiesNames: input.map({ $0.name }), cities: input)
        return screenData
    }
    
    func selectMeasuringUnit(unit: String) {
        persistence.storeMeasuringUnit(unit: unit)
    }
    
    func toggleFeature(index: Int) {
        var currentFeatures = persistence.fetchFeatures()
        
        
        currentFeatures[index].toggle()
        output.features[index].toggle()
        persistence.storeFeatures(features: currentFeatures)
    }
}
