//
//  MobileProtocolSessionError.swift
//  MobileLogginSDK
//
//  Created by Inna Chystiakova on 07/09/2024.
//

import Foundation
///
/// enum `HTTPClientError`
/// 
/// Contains all the possible errors that can be received from the server
/// Can be extended with other errors
///
enum HTTPClientError: Error {
    case invalidURL
    case invalidResponse
    case invalidJSONEncode
    case invalidMessageLength
    case invalidMessageFormat
    case requestFailed(Error)
    case unknown
}
///
///extension `HTTPClientError`
///
///Contains helpers to work with errors
///
extension HTTPClientError {
    ///
    ///Function returns description about each error that is declared in HTTPClientError
    ///It is used to return user-friendly description to the SDK users.
    ///
    func getErrorDescription() -> String {
        switch self {
        case .invalidURL:
            return "Invalid URL passed"
        case .invalidResponse:
            return "Request was finished with invalid response"
        case .invalidJSONEncode:
            return "Something went wrong with JSON endoding. Request was not sent."
        case .invalidMessageLength:
            return "Message length is invalid."
        case .invalidMessageFormat:
            return "Message format is invalid."
        case let .requestFailed(error):
            return "\(error.localizedDescription)"
        case .unknown:
            return "Unknown error"
        }
    }
}
