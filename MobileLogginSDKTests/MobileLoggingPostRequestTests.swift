//
//  MobileLoggingPostRequestTests.swift
//  MobileLogginSDKTests
//
//  Created by Inna Chystiakova on 08/09/2024.
//

import XCTest
@testable import MobileLogginSDK

class MobileLoggingPostRequestTests: XCTestCase {
    
    func testPostRequestInitialization() {
        let url = URL(string: "https://example.com")!
        let body = try! JSONHelper.encodeToJSON([PostRequestKeys.myString: "Test message"])
        
        let postRequest = PostRequest(with: url, body: body)
        
        XCTAssertEqual(postRequest.request.url, url)
        XCTAssertEqual(postRequest.request.httpMethod, HTTPMethod.post.rawValue)
        XCTAssertEqual(postRequest.request.allHTTPHeaderFields?["Content-Type"], "application/json")
        
        let requestBody = try! JSONHelper.decodeFromJSON(postRequest.request.httpBody!, as: [PostRequestKeys : String].self)
        XCTAssertEqual(requestBody[.myString], "Test message")
    }
    
    func testPostRequestInitializationWithEmptyBody() {
        let url = URL(string: "https://example.com")!
        let body = Data()
        
        let postRequest = PostRequest(with: url, body: body)
        
        XCTAssertEqual(postRequest.request.url, url)
        XCTAssertEqual(postRequest.request.httpMethod, HTTPMethod.post.rawValue)
        XCTAssertEqual(postRequest.request.allHTTPHeaderFields?["Content-Type"], "application/json")
        XCTAssertEqual(postRequest.request.httpBody, body)
    }
    
    func testCurlCommandGeneration() {
        let url = APIConstants.getPostURL()!//URL(string: "https://example.com")!
        let body = try! JSONHelper.encodeToJSON([PostRequestKeys.myString: "Test message"])
        let postRequest = PostRequest(with: url, body: body)
        
        let curlCommand = postRequest.curlString()
        
        let expectedCurlCommand = "curl --location 'https://us-central1-mobilesdklogging.cloudfunctions.net/saveString'\\ --header 'Content-Type: application/json'\\ --data '{\"myString\":\"Test message\"}'"
        
        XCTAssertEqual(curlCommand, expectedCurlCommand)
    }
    
    func testCurlCommandGenerationWithEmptyBody() {
        let url = URL(string: "https://example.com")!
        let body = Data() // Пустое тело
        let postRequest = PostRequest(with: url, body: body)
        
        let curlCommand = postRequest.curlString()
        
        let expectedCurlCommand = "curl --location 'https://example.com'\\ --header 'Content-Type: application/json'\\ --data '{}'"
        
        XCTAssertEqual(curlCommand, expectedCurlCommand)
    }
}
