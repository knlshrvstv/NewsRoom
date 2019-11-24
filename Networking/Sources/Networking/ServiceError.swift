//
//  ServiceError.swift
//  
//
//  Created by Kunal Shrivastava on 11/23/19.
//

import Foundation

/**
List of error provided by the Networking module
*/
public enum ServiceError: Error {
    case error(_ error: Error)
    case invalidEndpoint
    case invalidResponse
    case unknownError
    case networkError
    case noData
}

extension ServiceError: Equatable {
    public static func ==(lhs: ServiceError, rhs: ServiceError) -> Bool {
        switch (lhs, rhs) {
        case (let .error(error1), let .error(error2)):
            return error1.localizedDescription == error2.localizedDescription
        case (.invalidEndpoint, .invalidEndpoint):
            return true
        case (.invalidResponse, .invalidResponse):
            return true
        case (.unknownError, .unknownError):
            return true
        case (.networkError, .networkError):
            return true
        case (.noData, .noData):
            return true
        default:
            return false
        }
    }
}
