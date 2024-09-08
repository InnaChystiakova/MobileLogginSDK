//
//  MobileLoggingManager.swift
//  
//
//  Created by Inna Chystiakova on 06/09/2024.
//

import Foundation

class MobileLoggingManager {
    private let requestFactory: RequestFactory
    private let httpClient: HTTPClient

    init(requestFactory: RequestFactory = MobileLoggingURLRequest(), httpClient: HTTPClient = URLSessionHTTPClient()) {
        self.requestFactory = requestFactory
        self.httpClient = httpClient
    }
    ///
    /// Function creates the PostRequest and send it with URLSession to the backend.
    /// If request was not created returns the error description.
    /// If message was not posted also returns error.
    /// Otherwise returns success.
    ///
    /// Parameters:
    /// `-body: [PostRequestKeys: String]` - dictionary that contains all the fields of request body
    /// `-@escaping (MobileLoggingManagerResult)` - callback with the result if massage was posted or not
    ///
    func post(body: [PostRequestKeys: String], completion: @escaping (MobileLoggerResult) -> Void) {
        let result = requestFactory.createPostRequest(with: body)
        print("Body: \(body)")
        
        guard let postRequest = result.request else {
            completion(.failure(result.error?.getErrorDescription() ?? HTTPClientError.unknown.getErrorDescription()))
            return
        }
        
        print("postRequest body: \(String(describing: postRequest.request.httpBody))")
        
        httpClient.post(with: postRequest.request) { result in
            switch result {
            case .success:
                completion(.success(nil))
            case let .failure(error):
                completion(.failure(error.getErrorDescription()))
            }
        }
    }
    
    func postMessageOfValidLength(
        string: String,
        minLen: Int = 1,
        maxLen: Int = 1000,
        completion: @escaping (MobileLoggerResult) -> Void
    ) {
        guard string.count >= minLen, string.count <= maxLen else {
            completion(.failure(HTTPClientError.invalidMessageLength.getErrorDescription()))
            return
        }
        
        post(body: [.myString : string], completion: completion)
    }
    
    func postMessageIfValidFormat(string: String, regex: String, completion: @escaping (MobileLoggerResult) -> Void) {
        let predicate = NSPredicate(format: "SELF MATCHES %@", regex)
        guard predicate.evaluate(with: string) else {
            completion(.failure(HTTPClientError.invalidMessageFormat.getErrorDescription()))
            return
        }
        
        post(body: [.myString : string], completion: completion)
    }
    
    func generatePostRequestCurlCommand(for message: String, completion: (MobileLoggerResult) -> Void) {
        let result = requestFactory.createPostRequest(with: [.myString: message])
        
        guard let postRequest = result.request as? PostRequest else {
            completion(.failure(result.error?.getErrorDescription() ?? HTTPClientError.unknown.getErrorDescription()))
            return
        }
        completion(.success(postRequest.curlString()))
    }
    
    // MARK: - Helpers
    func convert(dictionary: [String : String]) -> [PostRequestKeys: String] {
        var convertedDictionary: [PostRequestKeys: String] = [:]
        for (key, value) in dictionary {
            if let postKey = PostRequestKeys(rawValue: key) {
                convertedDictionary[postKey] = value
            }
        }
        return convertedDictionary
    }
}
