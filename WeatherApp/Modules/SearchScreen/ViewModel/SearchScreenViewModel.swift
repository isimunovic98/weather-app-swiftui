//
//  SearchScreenViewModel.swift
//  WeatherApp (iOS)
//
//  Created by Domagoj Bunoza on 02.03.2022..
//
import Foundation
import Combine

class SearchScreenViewModel: ObservableObject {
    
    @Published var cities: [GeoItem] = []
    
    let locationRepository: LocationRepository
    let persistence: UserDefaultsManager
    var disposebag = Set<AnyCancellable>()
    
    init(repository: LocationRepository) {
        self.locationRepository = repository
        self.persistence = UserDefaultsManager()
    }
    
    func getLocation(cityName: String) {
        let cityNameModified = Handler.modifyCityName(cityName: cityName)
        locationRepository.fetch(cityName: cityNameModified)
            .subscribe(on: DispatchQueue.global(qos: .background))
            .receive(on: RunLoop.main)
            .tryMap { result -> GeoResponse in
                switch result {
                case .success(let result):
                    return result
                case .failure(let error):
                    throw error
                }
            }
            .map { result -> [GeoItem] in
                result.geonames.map { names in
                    return GeoItem(
                        name: names.name,
                        lat: names.lat,
                        lng: names.lng
                    )
                }
            }
            .sink(
                receiveCompletion: { completion in
                    switch completion {
                    case .finished:
                        break
                    case .failure(let error):
                        self.cities = [GeoItem(
                            name: "Error has occured: \(error.localizedDescription)",
                            lat: "0",
                            lng: "0"
                        )]
                        break
                    }
                },
                receiveValue: { result in
                    self.cities = result
                })
            .store(in: &disposebag)
    }
    
    func didSelectCity(geoItem: GeoItem) {
        persistence.storeNewCity(geoItem: geoItem)
    }
}
