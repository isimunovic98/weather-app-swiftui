//
//  SearchScreenViewModel.swift
//  WeatherApp (iOS)
//
//  Created by Domagoj Bunoza on 02.03.2022..
//

import Combine
import Alamofire

class SearchScreenViewModel : ObservableObject {
    
    @Published var cities : [GeoItem]
    
    let locationRepository : LocationRepository
    let persistence : UserDefaultsManager
    
    init(repository : LocationRepository, persistence : UserDefaultsManager) {
        self.locationRepository = repository
        self.persistence = persistence
        self.cities = []
    }
    
    func handleGettingLocation(cityName: String) {
        let cityNameModified = modifyCityName(cityName: cityName)
        locationRepository.fetch(cityName: cityNameModified , completion: { result -> () in
            do {
                try self.setOutput(response: result.get())
            }
            catch {}
        })
    }
    
    func startViewmodel(cityName: String) {
        handleGettingLocation(cityName: cityName)
    }
    
    func setOutput(response: GeoResponse) {
        cities = response.geonames.map({
            GeoItem(name: $0.name, lat: $0.lat, lng: $0.lng)
        })
    }
    
    func selectedCity(geoItem: GeoItem) {
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
