//
//  MobileLoggingError.swift
//  
//
//  Created by Inna Chystiakova on 06/09/2024.
//

import Foundation
///
///class `URLSessionHTTPClient`
///
///Creates default instance for URLSession
///
class URLSessionHTTPClient: HTTPClient {
    private let session: URLSession
    
    init(session: URLSession = .shared) {
        self.session = session
    }
}
///
///extension `URLSessionHTTPClient`
///
///Creates actual implementation for HTTPClient protocol methods.
///Can be extended with the HTTPClient and perform other URLSession data tasks
///
extension URLSessionHTTPClient {
    ///
    ///Function posts a PostRequest to the backend
    ///
    ///Parameters:
    ///`-urlRequest: URLRequest` - the post request
    ///`-completion: @escaping (HTTPClientResult) -> Void` - callback with the result of URLSession data task
    ///
    func post(with urlRequest: URLRequest, completion: @escaping (HTTPClientResult) -> Void) {
        session.dataTask(with: urlRequest) { _, response, error in
            if let error = error {
                completion(.failure(.requestFailed(error)))
            } else if let response = response as? HTTPURLResponse, (200...299).contains(response.statusCode) {
                completion(.success)
            } else {
                completion(.failure(.invalidResponse))
            }
        }
        .resume()
    }
}
