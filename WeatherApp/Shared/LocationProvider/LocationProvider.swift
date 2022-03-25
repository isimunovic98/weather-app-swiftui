//
//  LocationProvider.swift
//  WeatherApp (iOS)
//
//  Created by Domagoj Bunoza on 20.03.2022..
//

import CoreLocation

class LocationProvider: NSObject, CLLocationManagerDelegate {
    
    let locationManager: CLLocationManager
    
    @Published var currentLocation: CLLocation?
    
    override init() {
        self.locationManager = CLLocationManager()
        super.init()
    }
    
    func setupLocationManager() {
        self.locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        requestLocation()
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        requestLocation()
    }
    
    func requestLocation() {
        if self.locationManager.authorizationStatus == .authorizedWhenInUse {
            locationManager.requestLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            self.currentLocation = location
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error: " + "\(error.localizedDescription)")
    }
    
}
