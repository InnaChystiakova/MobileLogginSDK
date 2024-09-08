//
//  MobileLoggingRequestProtocols.swift
//  MobileLogginSDK
//
//  Created by Inna Chystiakova on 07/09/2024.
//

import Foundation
///
///enum `HTTPMethod`
///Wraps the String presentation of the HTTPMethod
///Can be extended in future
///
enum HTTPMethod: String {
    case post = "POST"
    case get = "GET"
    case put = "PUT"
    case delete = "DELETE"
    
    ///
    ///Can be extended with other HTTPMethods
    ///
}
///
///protocol `Requestable`
///Declares variable URLRequest to create a proper instance for particular instances of URLRequest
///Can be extended in future
///
protocol Requestable {
    ///
    ///Parameter that is used to create actual request instance
    ///
    var request: URLRequest { get }
}
///
///protocol `RequestFactory`
///
///Declares methods interfaces to work with different types of requests
///Can be extended for some new requests, like GET, PUT, DELETE, etc.
///
protocol RequestFactory {
    ///
    ///Function creates Post Request with the body section passed in parameters
    ///
    ///Parameters:
    ///`-body: [PostRequestKeys: String]` - dictionary, with wrapped keys and values to post
    ///
    ///Return type:
    ///`(request: Requestable?, error: HTTPClientError?)` - tuple that return the post request of an error, if something went wrong
    ///
    func createPostRequest(with body: [PostRequestKeys: String]) -> (request: Requestable?, error: HTTPClientError?)
    ///
    ///Can be extended to create and operate other requests
    ///get, put, delete, etc.
    ///
    
}
