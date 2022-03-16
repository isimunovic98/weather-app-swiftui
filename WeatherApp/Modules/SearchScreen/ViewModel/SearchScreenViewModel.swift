//
//  SearchScreenViewModel.swift
//  WeatherApp (iOS)
//
//  Created by Domagoj Bunoza on 02.03.2022..
//
import Foundation
import Combine

class SearchScreenViewModel : ObservableObject {
    
    @Published var cities : [GeoItem]
    
    let locationRepository : LocationRepository
    let persistence : UserDefaultsManager
    var disposebag = Set<AnyCancellable>()
    
    init(repository : LocationRepository) {
        self.locationRepository = repository
        self.persistence = UserDefaultsManager()
        self.cities = []
    }
    
    func handleGettingLocation(cityName: String) {
        let cityNameModified = Handler.modifyCityName(cityName: cityName)
        locationRepository.fetch(cityName: cityNameModified)
            .subscribe(on: DispatchQueue.global(qos: .background))
            .receive(on: RunLoop.main)
            .sink(receiveValue: { [unowned self] response in
                do {
                    self.setOutput(response: try response.get())
                }
                catch(let error) {
                    print(error.localizedDescription)
                }
            })
            .store(in: &disposebag)
    }
    
    func setOutput(response: GeoResponse) {
        cities = response.geonames.map({
            GeoItem(name: $0.name, lat: $0.lat, lng: $0.lng)
        })
    }
    
    func selectedCity(geoItem: GeoItem) {
        persistence.storeNewCity(geoItem: geoItem)
    }
}
