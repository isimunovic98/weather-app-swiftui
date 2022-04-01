//
//  CLLocation+Extensions.swift
//  WeatherApp (iOS)
//
//  Created by Domagoj Bunoza on 20.03.2022..
//

import CoreLocation

extension CLLocation {
    func fetchCityName(completion: @escaping (_ city: String?, _ error: Error?) -> ()) {
        CLGeocoder().reverseGeocodeLocation(self) {
            completion($0?.first?.locality, $1)
        }
    }
}
