//
//  MobileLoggingURLRequestTests.swift
//  MobileLogginSDKTests
//
//  Created by Inna Chystiakova on 08/09/2024.
//

import XCTest
@testable import MobileLogginSDK

class MobileLoggingURLRequestTests: XCTestCase {
    
    func testCreatePostRequestSuccess() {
        let requestFactory = MobileLoggingURLRequest()
        let body: [PostRequestKeys: String] = [.myString: "Test message"]
        
        let result = requestFactory.createPostRequest(with: body)
        
        XCTAssertNotNil(result.request)
        XCTAssertNil(result.error)
    }
    
    func testPostRequestURL() {
        let requestFactory = MobileLoggingURLRequest()
        let body: [PostRequestKeys: String] = [.myString: "Test message"]
        
        let result = requestFactory.createPostRequest(with: body)
        
        XCTAssertEqual(result.request?.request.url?.absoluteString, APIConstants.getPostURL()?.absoluteString)
    }
    
    func testRequestBodySerialization() {
        let mobileLoggingRequest = MobileLoggingURLRequest()
        let body: [PostRequestKeys: String] = [.myString: "Test message"]
        
        let result = mobileLoggingRequest.createPostRequest(with: body)
        
        XCTAssertNil(result.error)
        XCTAssertNotNil(result.request)
        
        if let request = result.request as? PostRequest, let httpBody = request.request.httpBody {
            let json = try? JSONSerialization.jsonObject(with: httpBody, options: []) as? [String: String]
            
            XCTAssertEqual(json?["myString"], "Test message")
        } else {
            XCTFail("Failed to cast request or extract httpBody")
        }
    }
    
    func testCreatePostRequestEmptyBody() {
        let requestFactory = MobileLoggingURLRequest()
        let emptyBody: [PostRequestKeys: String] = [:]
        
        let result = requestFactory.createPostRequest(with: emptyBody)
        
        XCTAssertNotNil(result.request)
        XCTAssertNil(result.error)
    }
    
    func testCreatePostRequestNilBody() {
        let requestFactory = MobileLoggingURLRequest()
        let result = requestFactory.createPostRequest(with: [:])
        
        XCTAssertNotNil(result.request)
        XCTAssertNil(result.error)
    }
    
    func testRequestHeaders() {
        let requestFactory = MobileLoggingURLRequest()
        let body: [PostRequestKeys: String] = [.myString: "Test message"]
        
        let result = requestFactory.createPostRequest(with: body)
        
        XCTAssertEqual(result.request?.request.allHTTPHeaderFields?["Content-Type"], "application/json", "Content-Type header should be 'application/json'")
    }
}
