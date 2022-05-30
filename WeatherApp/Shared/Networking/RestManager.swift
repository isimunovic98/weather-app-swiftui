//
//  RestManager.swift
//  WeatherApp
//
//  Created by Domagoj Bunoza on 01.03.2022..
//

import Foundation
import Alamofire
import Combine


public class RestManager {
    private static let manager: Alamofire.Session = {
        var configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 10
        configuration.timeoutIntervalForResource = 10
        let sessionManager = Session(configuration: configuration)
        return sessionManager
    }()
    
    public static func fetch<T: Codable>(url: String) -> AnyPublisher<Result<T, NetworkError>, Never> {
        return RestManager.manager
            .request(url, encoding: URLEncoding.default)
            .validate()
            .publishUnserialized()
            .map { response in
                switch response.result {
                case .success(let optionalData):
                    if let data = optionalData {
                        if let decodedObject: T = SerializationManager.parseData(jsonData: data) {
                            return .success(decodedObject)
                        } else {
                            return .failure(.parseFailed)
                        }
                    }
                    else {
                        return .failure(.parseFailed)
                    }
                case .failure(_):
                    return .failure(.generalError)
                }
            }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
}
