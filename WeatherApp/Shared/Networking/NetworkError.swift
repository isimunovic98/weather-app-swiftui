//
//  NetworkError.swift
//  WeatherApp
//
//  Created by Domagoj Bunoza on 01.03.2022..
//

import Foundation

public enum NetworkError: Error {
    case generalError
    case parseFailed
    case invalidUrl
    case connectionTimedOut
    case notConnectedToInternet
    case networkConnectionLost
}

extension NetworkError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .parseFailed:
            return "Parse failed"
        case .generalError:
            return "An error occured, please try again"
        case .invalidUrl:
            return "Invalid URL"
        case .connectionTimedOut:
            return "Connection timed out, try again later"
        case .notConnectedToInternet:
            return "You are not connected to interner, check your connection and try again"
        case .networkConnectionLost:
            return "Lost connection to server, try again later"
        }
    }
}
