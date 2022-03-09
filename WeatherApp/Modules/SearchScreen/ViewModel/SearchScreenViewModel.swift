//
//  SearchScreenViewModel.swift
//  WeatherApp (iOS)
//
//  Created by Domagoj Bunoza on 02.03.2022..
//

import Combine

class SearchScreenViewModel : ObservableObject {
    
    @Published var cities : [GeoItem]
    
    let locationRepository : LocationRepository
    let persistence : UserDefaultsManager
    
    init(repository : LocationRepository) {
        self.locationRepository = repository
        self.persistence = UserDefaultsManager()
        self.cities = []
    }
    
    func handleGettingLocation(cityName: String) {
        let cityNameModified = Handler.modifyCityName(cityName: cityName)
        locationRepository.fetch(cityName: cityNameModified , completion: { result -> () in
            switch result {
            case .success(let result):
                self.setOutput(response: result)
            case .failure(let error):
                print(error.localizedDescription)
            }
        })
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
