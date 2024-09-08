//
//  MobileLoggingHTTPMethod.swift
//  MobileLogginSDK
//
//  Created by Inna Chystiakova on 07/09/2024.
//

import Foundation
///
///class `MobileLoggingURLRequest`
///
///Creates actual instance of RequestFactory
///
class MobileLoggingURLRequest: RequestFactory {}
///
/// extension `MobileLoggingURLRequest`
///
/// Creates actual implementation for RequestFactory protocol methods
/// Can be extended with the RequestFactory and perform other Request tasks
///
extension MobileLoggingURLRequest {
    ///
    ///Function creates PostRequest and returns either request or error
    ///
    ///Parameters:
    ///`- body: [PostRequestKeys: String]` - a dictionary with JSON parameters to post
    ///
    ///Return value:
    ///`(request: Requestable?, error: HTTPClientError?)` - a tuple with PostRequest created and the error, if something went wrong
    ///
    func createPostRequest(with body: [PostRequestKeys: String]) -> (request: Requestable?, error: HTTPClientError?) {
        
        guard let url = APIConstants.getPostURL() else {
            return (nil, .invalidURL)
        }
        
        let stringKeyedBody = Dictionary(uniqueKeysWithValues: body.map { ($0.rawValue, $1) })

        guard let jsonData = try? JSONSerialization.data(withJSONObject: stringKeyedBody, options: []) else {
            return (nil, .invalidJSONEncode)
        }
        
        let request = PostRequest(with: url, body: jsonData)
        return (request, nil)
    }
}
