//
//  MobileLoggingPostRequest.swift
//  MobileLogginSDK
//
//  Created by Inna Chystiakova on 07/09/2024.
//

import Foundation
///
///enum `PostRequestKeys`
///
///Wraps the JSON keys into enum values
///Contains only keys for JSON to post on the backend
///
enum PostRequestKeys: String, Encodable, Decodable {
    case myString = "myString"
    ///
    ///Can be extended with other keys to post something
}
///
///class `PostRequest`
///
///Creates actual PostRequest with URL and a body passed through constructor injection
///
class PostRequest: Requestable {
    let request: URLRequest
    
    init(with url: URL, body: Data) {
        var request = URLRequest(url: url)
        request.httpMethod = HTTPMethod.post.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = body
                
        self.request = request
    }
}

///
/// extension `PostRequest`
///
/// Extends any PostRequest to create a curl command
///
extension PostRequest {
    func curlString() -> String {
        var curlCommand = "curl"
        
        if let location = self.request.url?.absoluteString {
            curlCommand += " --location \'\(location)\'\\"
        }
        
        if let headers = self.request.allHTTPHeaderFields {
            for (header, value) in headers {
                curlCommand += " --header \'\(header): \(value)\'\\"
            }
        }
        
        if let httpBody = self.request.httpBody {
            curlCommand += " --data '{"
            if let bodyDict = try? JSONHelper.decodeFromJSON(httpBody, as: [PostRequestKeys : String].self) {
                for element in bodyDict {
                    curlCommand += "\"\(element.key.rawValue)\":"
                    curlCommand += "\"\(element.value)\""
                }
            }
            curlCommand += "}'"
        }
        
        return curlCommand
    }
}
