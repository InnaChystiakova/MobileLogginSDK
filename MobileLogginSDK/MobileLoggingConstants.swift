//
//  MobileLoggingConstants.swift
//  MobileLogginSDK
//
//  Created by Inna Chystiakova on 07/09/2024.
//

import Foundation
///
/// struct `APIConstants`
/// 
/// Contains all the basic SDK string literals
/// Can be extended with other URLs or modified if the baseURL will be outdated
/// 
struct APIConstants {
    ///
    ///API URL
    ///
    static let baseURL = "https://us-central1-mobilesdklogging.cloudfunctions.net"
    
    ///API method to post something to backend
    ///
    static func getPostURL() -> URL? {
        return URL(string: "\(baseURL)/saveString")
    }
}
