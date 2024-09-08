//
//  MobileLoggingSessionProtocols.swift
//  MobileLogginSDK
//
//  Created by Inna Chystiakova on 07/09/2024.
//

import Foundation
///
/// enum`HTTPClientResult`
///
/// This enum describes the result of URLSession tasks.
///
/// `-success` if data task was performed successfylly
/// `-error` if data task returns the error description
///
enum HTTPClientResult {
    case success
    case failure(HTTPClientError)
}
///
///protocol HTTPClient
///
///Declares methods interfaces for URLSession
///Can be extended to declare other functions to perform in a session
///
protocol HTTPClient {
    ///
    ///Function declaration to post pre-defined URLRequset
    ///Parameters:
    ///`-url: URLRequest` - the request to post
    ///`-completion: @escaping (HTTPClientResult) -> Void` - callback with the result of URLSession data task
    ///
    func post(with url: URLRequest, completion: @escaping (HTTPClientResult) -> Void)
    ///
    ///Can be extended to perform other tasks
    ///get, download or upload something, etc.
    ///
}
